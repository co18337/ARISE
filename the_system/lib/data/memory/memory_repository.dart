import 'package:drift/drift.dart';

import '../../game/game.dart';
import '../../models/models.dart';
import '../day_key.dart';
import '../db/database.dart';
import 'chunking.dart';
import 'embedder.dart';

/// One retrieved passage, with how well it matched.
class MemoryHit {
  final int documentId;
  final MemoryKind kind;
  final String title;
  final String passage;
  final int? day;
  final double score;

  const MemoryHit({
    required this.documentId,
    required this.kind,
    required this.title,
    required this.passage,
    required this.day,
    required this.score,
  });
}

/// What the corpus currently holds.
class MemoryStats {
  final int documents;
  final int chunks;
  final Map<MemoryKind, int> byKind;
  final String embedder;
  final int dimensions;

  /// Chunks embedded by something OTHER than the current embedder. They are
  /// excluded from search until re-embedded, because comparing vectors from
  /// two models returns noise that looks like a result.
  final int staleChunks;

  const MemoryStats({
    required this.documents,
    required this.chunks,
    required this.byKind,
    required this.embedder,
    required this.dimensions,
    required this.staleChunks,
  });

  static const MemoryStats empty = MemoryStats(
    documents: 0,
    chunks: 0,
    byKind: {},
    embedder: '—',
    dimensions: 0,
    staleChunks: 0,
  );

  bool get isEmpty => documents == 0;
}

/// The System's long-term memory: documents, chunked and embedded, searchable
/// by meaning-ish similarity.
///
/// This is the retrieval half of RAG. It is deliberately built and working
/// BEFORE the LLM exists, because the alternative — building the model
/// integration first and the memory afterwards — means the model has nothing
/// to reason over on the day it arrives.
///
/// Scale: search loads every current chunk and scores it in Dart. For one
/// person over years that is thousands of rows, not millions, and a linear
/// scan of a few thousand 256-float vectors is under a millisecond. If this
/// ever holds a hundred thousand chunks it will need an index; it will not.
class MemoryRepository {
  final AppDatabase db;
  final Embedder embedder;
  final Clock clock;

  MemoryRepository(
    this.db, {
    this.embedder = const HashingEmbedder(),
    this.clock = const Clock(),
  });

  /// Stores a document and its embedded chunks.
  ///
  /// Re-ingesting the same [externalId] REPLACES the previous version, so a
  /// corrected body scan or a re-finished session updates rather than
  /// duplicating.
  Future<int> ingest({
    required MemoryKind kind,
    required String title,
    required String body,
    int? day,
    String? sourcePath,
    String? externalId,
  }) async {
    final chunks = chunkText(body);
    final vectors = await embedder.embedAll(chunks);

    return db.transaction(() async {
      if (externalId != null) {
        await (db.delete(db.memoryDocuments)
              ..where((d) => d.externalId.equals(externalId)))
            .go();
      }

      final documentId = await db.into(db.memoryDocuments).insert(
            MemoryDocumentsCompanion.insert(
              kind: kind,
              title: title,
              body: body,
              day: Value(day),
              createdAt: clock.now(),
              sourcePath: Value(sourcePath),
              externalId: Value(externalId),
            ),
          );

      await db.batch((b) {
        for (final (i, chunk) in chunks.indexed) {
          b.insert(
            db.memoryChunks,
            MemoryChunksCompanion.insert(
              documentId: documentId,
              chunkIndex: i,
              content: chunk,
              embedding: packVector(vectors[i]),
              dimensions: embedder.dimensions,
              embedder: embedder.name,
            ),
          );
        }
      });

      return documentId;
    });
  }

  /// The passages most like [query].
  ///
  /// Only chunks written by the CURRENT embedder are considered. Mixing
  /// vectors from two models does not fail loudly — it quietly returns
  /// plausible-looking nonsense, which is worse.
  Future<List<MemoryHit>> recall(
    String query, {
    int limit = 5,
    Set<MemoryKind>? kinds,
    double minScore = 0.02,
  }) async {
    final queryVector = await embedder.embed(query);

    final rows = await (db.select(db.memoryChunks).join([
      innerJoin(
        db.memoryDocuments,
        db.memoryDocuments.id.equalsExp(db.memoryChunks.documentId),
      ),
    ])..where(db.memoryChunks.embedder.equals(embedder.name)))
        .get();

    final hits = <MemoryHit>[];
    for (final row in rows) {
      final chunk = row.readTable(db.memoryChunks);
      final document = row.readTable(db.memoryDocuments);
      if (kinds != null && !kinds.contains(document.kind)) continue;

      final score = cosineSimilarity(
        queryVector,
        unpackVector(Uint8List.fromList(chunk.embedding)),
      );
      if (score < minScore) continue;

      hits.add(
        MemoryHit(
          documentId: document.id,
          kind: document.kind,
          title: document.title,
          passage: chunk.content,
          day: document.day,
          score: score,
        ),
      );
    }

    hits.sort((a, b) => b.score.compareTo(a.score));
    return hits.take(limit).toList();
  }

  Future<MemoryStats> stats() async {
    final documents = await db.select(db.memoryDocuments).get();
    final chunks = await db.select(db.memoryChunks).get();

    final byKind = <MemoryKind, int>{};
    for (final d in documents) {
      byKind[d.kind] = (byKind[d.kind] ?? 0) + 1;
    }

    return MemoryStats(
      documents: documents.length,
      chunks: chunks.length,
      byKind: byKind,
      embedder: embedder.name,
      dimensions: embedder.dimensions,
      staleChunks: chunks.where((c) => c.embedder != embedder.name).length,
    );
  }

  /// Re-embeds every chunk with the current embedder.
  ///
  /// The upgrade path for the day the Gemini embedder is switched on: the
  /// stored text is the source of truth, the vectors are a derived cache, and
  /// a cache built by a different model has to be rebuilt rather than trusted.
  Future<int> reembedAll({int batchSize = 40}) async {
    // Settle the name BEFORE comparing against it, or a resolving embedder
    // reports one name here and a different one when it writes — and every
    // chunk looks stale forever.
    await embedder.prepare();

    final chunks = await db.select(db.memoryChunks).get();
    final stale = chunks.where((c) => c.embedder != embedder.name).toList();
    if (stale.isEmpty) return 0;

    // BATCHED. A corpus of several hundred chunks in one request is a body
    // large enough to be rejected outright, and a failure halfway through
    // would leave the store half-converted — with two incomparable embedders
    // in it, which is the one state the design exists to prevent.
    var converted = 0;
    for (var start = 0; start < stale.length; start += batchSize) {
      final batch = stale.skip(start).take(batchSize).toList();
      final vectors = await embedder.embedAll([
        for (final c in batch) c.content,
      ]);

      // One transaction PER BATCH, so an interruption leaves whole batches
      // converted rather than a torn one.
      await db.transaction(() async {
        for (final (i, chunk) in batch.indexed) {
          await (db.update(db.memoryChunks)
                ..where((c) => c.id.equals(chunk.id)))
              .write(
            MemoryChunksCompanion(
              embedding: Value(packVector(vectors[i])),
              dimensions: Value(embedder.dimensions),
              embedder: Value(embedder.name),
            ),
          );
        }
      });
      converted += batch.length;
    }

    return converted;
  }

  /// Deletes documents, optionally only those whose externalId starts with
  /// [externalIdPrefix] — which is how the sample corpus is removed without
  /// touching anything real.
  Future<int> clear({String? externalIdPrefix}) async {
    final delete = db.delete(db.memoryDocuments);
    if (externalIdPrefix != null) {
      delete.where((d) => d.externalId.like('$externalIdPrefix%'));
    }
    // Chunks go with them: the foreign key cascades.
    return delete.go();
  }

  /// Records a finished training session so the trainer can remember it.
  ///
  /// This is the loop the whole thing turns on: the app prescribes, you train,
  /// the session becomes a document, and the next prescription can be informed
  /// by it. Without this step the corpus never fills and the memory is a
  /// feature nobody can use.
  Future<void> rememberSession({
    required int day,
    required String phase,
    required int week,
    required String focus,
    required List<String> lines,
  }) => ingest(
    kind: MemoryKind.workoutSession,
    title: '$focus · week $week',
    day: day,
    externalId: 'session:$day',
    body: [
      'Training session on ${_isoDate(day)}.',
      'Phase $phase, week $week, focus $focus.',
      ...lines,
    ].join('\n'),
  );

  static String _isoDate(int day) {
    final d = dateOfDayKey(day);
    return '${d.year}-${_two(d.month)}-${_two(d.day)}';
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}
