import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/export/export_repository.dart';
import 'package:the_system/data/repositories/progress_repository.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
import 'package:the_system/data/repositories/workout_repository.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';

/// A backup you cannot restore is worse than none — it feels like safety.
void main() {
  final clock = FixedClock(DateTime(2026, 8, 31, 21, 0));

  Future<AppDatabase> lived() async {
    final db = AppDatabase(NativeDatabase.memory());
    final quests = QuestRepository(db, clock: clock);
    await quests.materialiseDay(clock.now());
    final today = await quests.readDay(clock.now());
    await quests.setStatus(today.first, QuestStatus.done);
    await WorkoutRepository(db, clock: clock).openSession(clock.now());
    return db;
  }

  test('the backup carries the whole record, not just the routine', () async {
    final db = await lived();
    addTearDown(db.close);

    final backup = await ExportRepository(db).build();
    // The things that used to be missing entirely — losing them meant losing
    // the training history, the Tanita scan and the blood work.
    for (final key in [
      'workoutSessions',
      'workoutSets',
      'bodyMeasurements',
      'bodySegments',
      'labResults',
      'meals',
      'memoryDocuments',
    ]) {
      expect(backup.json, contains('"$key"'), reason: key);
    }
  });

  test('a full round trip returns what was there', () async {
    final source = await lived();
    final json = (await ExportRepository(source).build()).json;
    final beforeScan =
        (await ProgressRepository(source).read(ChartRange.all)).baseline!;
    final beforeQuests = await QuestRepository(source, clock: clock)
        .readDay(clock.now());
    await source.close();

    // A different database entirely — the phone you restore onto.
    final target = AppDatabase(NativeDatabase.memory());
    addTearDown(target.close);
    final repo = ExportRepository(target);

    final plan = repo.inspect(json);
    expect(plan.isValid, isTrue, reason: plan.problem);
    expect(plan.sessions, greaterThan(0));
    expect(await repo.restore(plan), greaterThan(0));

    final afterQuests =
        await QuestRepository(target, clock: clock).readDay(clock.now());
    expect(afterQuests, hasLength(beforeQuests.length));
    expect(
      afterQuests.where((q) => q.status == QuestStatus.done),
      hasLength(1),
      reason: 'the answered step came back answered',
    );

    final afterScan =
        (await ProgressRepository(target).read(ChartRange.all)).baseline!;
    expect(afterScan.weightKg, beforeScan.weightKg);
    expect(afterScan.segments, hasLength(beforeScan.segments.length));

    final sessions = await target.select(target.workoutSessions).get();
    expect(sessions, isNotEmpty, reason: 'training history survived');
  });

  test('restoring replaces rather than merging', () async {
    // Merging would leave two overlapping histories and no way to tell which
    // day was real.
    final source = await lived();
    final json = (await ExportRepository(source).build()).json;
    await source.close();

    final target = await lived();
    addTearDown(target.close);
    // Something the backup does not contain.
    await QuestRepository(target, clock: clock)
        .materialiseDay(DateTime(2026, 8, 25));
    final before = await target.select(target.dailyQuests).get();

    final repo = ExportRepository(target);
    await repo.restore(repo.inspect(json));

    final after = await target.select(target.dailyQuests).get();
    expect(after.length, lessThan(before.length));
  });

  test('a backup from a newer build is refused, not half-understood', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final plan = ExportRepository(db).inspect(
      '{"app":"The System","schemaVersion":9999,"formatVersion":2}',
    );
    expect(plan.isValid, isFalse);
    expect(plan.problem, contains('newer version'));
  });

  test('nonsense is refused before anything is touched', () async {
    final db = await lived();
    addTearDown(db.close);
    final repo = ExportRepository(db);
    final before = (await db.select(db.dailyQuests).get()).length;

    for (final bad in ['not json at all', '[]', '{"app":"Some Other App"}']) {
      final plan = repo.inspect(bad);
      expect(plan.isValid, isFalse, reason: bad);
      expect(() => repo.restore(plan), throwsStateError);
    }

    expect((await db.select(db.dailyQuests).get()).length, before,
        reason: 'a rejected restore touches nothing');
  });
}
