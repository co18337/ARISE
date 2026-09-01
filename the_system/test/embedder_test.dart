import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/memory/embedder.dart';
import 'package:the_system/data/memory/memory_repository.dart';
import 'package:the_system/models/models.dart';

/// Phase 13's last piece: swapping the embedder without corrupting the corpus.
///
/// The rule the whole design turns on is that vectors from two embedders are
/// NOT comparable. Everything below is about never mixing them.
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() async => db.close());

  Future<void> fill(MemoryRepository repo, int n) async {
    for (var i = 0; i < n; i++) {
      await repo.ingest(
        kind: MemoryKind.workoutSession,
        title: 'Session $i',
        body: 'Easy run $i minutes, completed in full. Plank held.',
        externalId: 'session:$i',
      );
    }
  }

  test('switching embedder marks the corpus stale rather than mixing it',
      () async {
    final local = MemoryRepository(db);
    await fill(local, 3);
    expect((await local.stats()).staleChunks, 0);

    // A different embedder: same store, incomparable vectors.
    final other = MemoryRepository(db, embedder: _Fake());
    final stats = await other.stats();
    expect(stats.chunks, greaterThan(0));
    expect(
      stats.staleChunks,
      stats.chunks,
      reason: 'every chunk was written by the other embedder',
    );
  });

  test('converting rewrites every chunk and clears the staleness', () async {
    await fill(MemoryRepository(db), 5);

    final upgraded = MemoryRepository(db, embedder: _Fake());
    final converted = await upgraded.reembedAll();

    expect(converted, greaterThan(0));
    expect((await upgraded.stats()).staleChunks, 0);
    expect((await upgraded.stats()).embedder, contains('fake'));
  });

  test('converting twice is a no-op, not a second bill', () async {
    await fill(MemoryRepository(db), 3);
    final upgraded = MemoryRepository(db, embedder: _Fake());

    expect(await upgraded.reembedAll(), greaterThan(0));
    expect(await upgraded.reembedAll(), 0, reason: 'nothing left to convert');
  });

  test('it converts in batches, so one huge request is never sent', () async {
    // A corpus of several hundred chunks in one body is large enough to be
    // rejected outright, and a failure halfway would leave the store holding
    // two incomparable embedders — the one state this design prevents.
    await fill(MemoryRepository(db), 12);
    final embedder = _Fake();
    await MemoryRepository(db, embedder: embedder).reembedAll(batchSize: 4);

    expect(embedder.batches.length, greaterThan(1));
    expect(embedder.batches.every((b) => b <= 4), isTrue);
  });

  test('a resolving embedder settles its name before the corpus is compared',
      () async {
    // Without prepare(), a name that resolves late reports one label when
    // comparing and another when writing — so every chunk looks permanently
    // stale and the whole corpus is re-embedded on every launch.
    await fill(MemoryRepository(db), 3);
    final late = _LateNaming();
    final repo = MemoryRepository(db, embedder: late);

    await repo.reembedAll();
    expect(await repo.reembedAll(), 0, reason: 'stable after the first pass');
  });

  test('recall still works with the local embedder and no key', () async {
    // The floor: retrieval must not depend on a network or a key.
    final local = MemoryRepository(db);
    await fill(local, 4);

    final hits = await local.recall('run completed', limit: 2);
    expect(hits, isNotEmpty);
  });
}

/// Stands in for a different embedder, and counts how it was called.
class _Fake implements Embedder {
  final List<int> batches = [];

  @override
  String get name => 'fake-8';

  @override
  int get dimensions => 8;

  @override
  Future<void> prepare() async {}

  @override
  Future<List<Float32List>> embedAll(List<String> texts) async {
    batches.add(texts.length);
    return [
      for (var i = 0; i < texts.length; i++)
        Float32List.fromList(List<double>.filled(8, 0.5)),
    ];
  }
}

/// An embedder whose name is only final after prepare(), like the Gemini one.
class _LateNaming extends _Fake {
  bool _ready = false;

  @override
  String get name => _ready ? 'late-resolved-8' : 'late-auto-8';

  @override
  Future<void> prepare() async => _ready = true;
}
