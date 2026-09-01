import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/config/app_config.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/memory/chunking.dart';
import 'package:the_system/data/memory/embedder.dart';
import 'package:the_system/data/memory/memory_repository.dart';
import 'package:the_system/data/memory/memory_seeder.dart';
import 'package:the_system/data/memory/memory_trainer.dart';
import 'package:the_system/data/repositories/workout_repository.dart';
import 'package:the_system/data/training_plan.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';

void main() {
  group('chunking', () {
    test('short text stays whole', () {
      expect(chunkText('A single short line.'), ['A single short line.']);
    });

    test('empty text produces nothing', () {
      expect(chunkText('   '), isEmpty);
    });

    test('long text splits, and every chunk carries content', () {
      final text = List.generate(
        60,
        (i) => 'Sentence number $i about running and intervals.',
      ).join(' ');

      final chunks = chunkText(text);
      expect(chunks.length, greaterThan(1));
      expect(chunks.every((c) => c.trim().isNotEmpty), isTrue);
      // Nothing is lost: the first and last words both survive somewhere.
      expect(chunks.first, contains('number 0'));
      expect(chunks.last, contains('number 59'));
    });

    test('chunks overlap, so a sentence on a boundary is not orphaned', () {
      final text = List.generate(40, (i) => 'word$i').join(' ');
      final chunks = chunkText(text, size: 100, overlap: 30);
      expect(chunks.length, greaterThan(2));
      // Consecutive chunks share some text.
      final firstTail = chunks[0].split(' ').last;
      expect(chunks[1], contains(firstTail));
    });
  });

  group('the local embedder', () {
    // The real default. Dimension count is not incidental here — see the note
    // on HashingEmbedder for the collision that a small one caused.
    const embedder = HashingEmbedder();

    test('is deterministic', () async {
      final a = await embedder.embed('sprint intervals on wednesday');
      final b = await embedder.embed('sprint intervals on wednesday');
      expect(a, equals(b));
    });

    test('produces unit vectors, so cosine is a dot product', () async {
      final v = await embedder.embed('plank and sit-ups for the core');
      var sum = 0.0;
      for (final x in v) {
        sum += x * x;
      }
      expect(sum, closeTo(1.0, 0.0001));
    });

    test('scores related text above unrelated text', () async {
      final query = await embedder.embed('sprint intervals running');
      final related = await embedder.embed(
        'Did sprint intervals today, four sets of twenty seconds running hard.',
      );
      final unrelated = await embedder.embed(
        'Applied sunscreen and finished the night skincare routine.',
      );

      expect(
        cosineSimilarity(query, related),
        greaterThan(cosineSimilarity(query, unrelated)),
      );
    });

    test('empty text yields a zero vector rather than throwing', () async {
      final v = await embedder.embed('');
      expect(v.every((x) => x == 0), isTrue);
    });

    test('stopwords are dropped so the real words dominate', () {
      expect(
        HashingEmbedder.tokenise('Steady run: 1 of 1 sets at 12 min'),
        ['steady', 'run', '1', '1', 'sets', '12', 'min'],
      );
    });

    test('a real session query beats an unrelated one by a clear margin',
        () async {
      // Pinned because this exact pair once scored 0.0000: a colliding token
      // flipped the sign of a shared bucket at 256 dimensions and cancelled
      // the match completely.
      final query = await embedder.embed(
        'ENDURANCE Steady run Chin tucks Cool-down stretch',
      );
      final related = await embedder.embed(
        'Steady run: 1 of 1 sets at 12 min completed. Felt easy.',
      );
      final unrelated = await embedder.embed(
        'Morning skincare and sunscreen done, dinner finished by nine.',
      );

      expect(cosineSimilarity(query, related), greaterThan(0.05));
      expect(cosineSimilarity(query, unrelated), lessThan(0.02));
    });

    test('vectors survive the round trip through the database format', () async {
      final original = await embedder.embed('bench press three sets of eight');
      final restored = unpackVector(
        Uint8List.fromList(packVector(original)),
      );
      expect(restored.length, original.length);
      expect(cosineSimilarity(original, restored), closeTo(1.0, 0.0001));
    });
  });

  group('the corpus', () {
    late AppDatabase db;
    late MemoryRepository memory;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      memory = MemoryRepository(db, clock: FixedClock(DateTime(2026, 8, 30)));
    });

    tearDown(() => db.close());

    test('ingesting a document chunks and embeds it', () async {
      await memory.ingest(
        kind: MemoryKind.note,
        title: 'A note',
        body: 'Knee felt sore during the sprint intervals this morning.',
      );

      final stats = await memory.stats();
      expect(stats.documents, 1);
      expect(stats.chunks, greaterThanOrEqualTo(1));
      expect(stats.byKind[MemoryKind.note], 1);
      expect(stats.staleChunks, 0);
    });

    test('re-ingesting the same externalId replaces rather than duplicates',
        () async {
      await memory.ingest(
        kind: MemoryKind.bodyScan,
        title: 'Scan',
        body: 'Body fat 24 percent.',
        externalId: 'scan:1',
      );
      await memory.ingest(
        kind: MemoryKind.bodyScan,
        title: 'Scan corrected',
        body: 'Body fat 23 percent.',
        externalId: 'scan:1',
      );

      final stats = await memory.stats();
      expect(stats.documents, 1);

      final hits = await memory.recall('body fat percent');
      expect(hits.single.title, 'Scan corrected');
    });

    test('recall ranks the relevant passage first', () async {
      await memory.ingest(
        kind: MemoryKind.workoutSession,
        title: 'Intervals',
        body: 'Sprint intervals: four sets of twenty seconds, all completed.',
      );
      await memory.ingest(
        kind: MemoryKind.dailyLog,
        title: 'Skincare',
        body: 'Morning skincare and sunscreen done, dinner finished by nine.',
      );

      final hits = await memory.recall('how did the sprint intervals go');
      expect(hits, isNotEmpty);
      expect(hits.first.title, 'Intervals');
      expect(hits.first.score, greaterThan(0));
    });

    test('recall can be restricted to certain kinds', () async {
      await memory.ingest(
        kind: MemoryKind.workoutSession,
        title: 'Session',
        body: 'Steady run for twelve minutes, completed.',
      );
      await memory.ingest(
        kind: MemoryKind.healthSync,
        title: 'Health',
        body: 'Steady heart rate through a twelve minute run.',
      );

      final hits = await memory.recall(
        'twelve minute run',
        kinds: {MemoryKind.healthSync},
      );
      expect(hits, isNotEmpty);
      expect(hits.every((h) => h.kind == MemoryKind.healthSync), isTrue);
    });

    test('vectors from another embedder are excluded, not silently mixed',
        () async {
      await memory.ingest(
        kind: MemoryKind.note,
        title: 'Note',
        body: 'Sprint intervals felt good today.',
      );

      // A different embedder: same corpus, incomparable vectors.
      final other = MemoryRepository(
        db,
        embedder: const HashingEmbedder(dimensions: 64),
      );

      expect(await other.recall('sprint intervals'), isEmpty);
      final stats = await other.stats();
      expect(stats.staleChunks, stats.chunks);

      // Re-embedding brings them back rather than leaving them stranded.
      final rebuilt = await other.reembedAll();
      expect(rebuilt, greaterThan(0));
      expect(await other.recall('sprint intervals'), isNotEmpty);
      expect((await other.stats()).staleChunks, 0);
    });

    test('the sample corpus can be seeded and removed cleanly', () async {
      await memory.ingest(
        kind: MemoryKind.note,
        title: 'Real note',
        body: 'This one is mine and must survive.',
        externalId: 'real:1',
      );

      final written = await MemorySeeder(memory).seed(
        days: 5,
        endingOn: DateTime(2026, 8, 30),
      );
      expect(written, greaterThan(5));

      var stats = await memory.stats();
      expect(stats.documents, greaterThan(5));
      expect(stats.byKind[MemoryKind.workoutSession], 5);
      expect(stats.byKind[MemoryKind.bodyScan], 1);

      await memory.clear(externalIdPrefix: MemorySeeder.prefix);

      stats = await memory.stats();
      expect(stats.documents, 1, reason: 'only the real note should remain');
      expect((await memory.recall('this one is mine')).single.title,
          'Real note');
    });

    test('the same seed produces the same corpus', () async {
      final written = await MemorySeeder(memory, seed: 7)
          .seed(days: 3, endingOn: DateTime(2026, 8, 30));

      final db2 = AppDatabase(NativeDatabase.memory());
      final memory2 = MemoryRepository(db2);
      final written2 = await MemorySeeder(memory2, seed: 7)
          .seed(days: 3, endingOn: DateTime(2026, 8, 30));

      expect(written2, written);
      final a = await memory.recall('sprint intervals');
      final b = await memory2.recall('sprint intervals');
      expect(b.map((h) => h.passage), a.map((h) => h.passage));

      await db2.close();
    });
  });

  group('the memory-backed trainer', () {
    late AppDatabase db;
    late MemoryRepository memory;

    // A Monday, so the template is fixed.
    final monday = DateTime(2026, 8, 31);

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      memory = MemoryRepository(db);
    });

    tearDown(() => db.close());

    test('an empty corpus still issues a full session', () async {
      final plan = await MemoryTrainerAdvisor(memory: memory).planSession(
        weekday: DateTime.monday,
        week: 1,
        clearedByExercise: const {},
      );

      expect(plan.items, isNotEmpty);
      expect(plan.notes, isEmpty);
      expect(plan.phase, TrainingPhase.groundwork);
    });

    test('with no key, the passages are quoted and labelled as such', () async {
      await memory.ingest(
        kind: MemoryKind.workoutSession,
        title: 'Last Monday',
        // Names what Monday actually prescribes now, so the recall has
        // something to match on. The corpus is the record of real sessions,
        // and a fixture that names a movement no longer in the plan tests
        // nothing.
        body: 'Easy run: 1 of 1 sets at 12 min — completed.',
      );

      final plan = await MemoryTrainerAdvisor(memory: memory).planSession(
        weekday: DateTime.monday,
        week: 1,
        clearedByExercise: const {},
      );

      // The floor: no model, so the record speaks for itself — and the screen
      // is told which it is reading.
      expect(plan.noteSource, TrainerNoteSource.history);
      expect(plan.notes.first, contains('SESSION'));
    });

    test('an empty corpus says nothing rather than inventing', () async {
      final plan = await MemoryTrainerAdvisor(memory: memory).planSession(
        weekday: DateTime.monday,
        week: 1,
        clearedByExercise: const {},
      );
      expect(plan.notes, isEmpty);
      expect(plan.noteSource, TrainerNoteSource.none);
    });

    test('the session summary describes what was prescribed', () async {
      // This is what the trainer lane is given to comment on, so it has to
      // name the movements and the phase rather than just the focus.
      final plan = await const RuleBasedTrainer().planSession(
        weekday: DateTime.monday,
        week: 1,
        clearedByExercise: const {},
      );

      expect(plan.summary, contains('GROUNDWORK'));
      expect(plan.summary, contains('week 1'));
      expect(plan.summary, contains('Easy run'));
      expect(plan.summary, contains('min'));
    });

    test('history the session is about becomes a note', () async {
      await memory.ingest(
        kind: MemoryKind.workoutSession,
        title: 'Last Monday',
        body: 'Steady run: 1 of 1 sets at 12 min — completed. '
            'Felt easy after the first ten minutes.',
      );

      final plan = await MemoryTrainerAdvisor(memory: memory).planSession(
        weekday: DateTime.monday,
        week: 1,
        clearedByExercise: const {},
      );

      expect(plan.notes, isNotEmpty);
      expect(plan.notes.first, contains('SESSION'));
      // The sets are still the rule engine's, untouched by retrieval. Monday
      // in RESET opens with the warm-up, then the run.
      expect(plan.items.first.exercise.id, 'dynamic_warmup');
      expect(
        plan.items.map((i) => i.exercise.id),
        contains('steady_run'),
      );
    });

    test('finishing a session writes it into memory', () async {
      // The loop the whole thing turns on: train, remember, prescribe better.
      final workouts = WorkoutRepository(
        db,
        clock: FixedClock(monday),
        memory: memory,
      );

      final session = await workouts.openSession(monday);
      for (final exercise in session!.exercises) {
        for (final set in exercise.sets) {
          await workouts.setDone(set.id, true);
        }
      }
      await workouts.completeSession(session.id);

      final stats = await memory.stats();
      expect(stats.byKind[MemoryKind.workoutSession], 1);

      final hits = await memory.recall('easy run completed');
      expect(hits, isNotEmpty);
      expect(hits.first.passage, contains('Easy run'));
    });
  });

  group('configuration', () {
    test('reports no key when none is set', () {
      AppConfig.overrideForTest(apiKey: null);
      expect(AppConfig.hasGeminiKey, isFalse);
      expect(AppConfig.geminiApiKey, isEmpty);
      // The defaults still resolve, so nothing downstream needs a null check.
      expect(AppConfig.geminiModel, isNotEmpty);
      expect(AppConfig.geminiEmbeddingModel, isNotEmpty);
    });

    test('reports a key once one is supplied', () {
      AppConfig.overrideForTest(apiKey: 'test-key-123');
      expect(AppConfig.hasGeminiKey, isTrue);
      expect(AppConfig.geminiApiKey, 'test-key-123');
      AppConfig.overrideForTest(apiKey: null); // leave it as it was found
    });
  });
}
