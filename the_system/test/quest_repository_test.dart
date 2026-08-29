// `show Value` keeps drift's SQL helpers (isNotNull, etc.) from colliding with
// the test matchers of the same name.
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/day_key.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/data/task_catalog.dart';
import 'package:the_system/models/models.dart';

void main() {
  late AppDatabase db;
  late QuestRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = QuestRepository(db);
  });

  tearDown(() => db.close());

  // A Wednesday: the weekly Saturday quest must NOT appear.
  final wednesday = DateTime(2026, 8, 26);
  // A Saturday: it must. Deliberately a date in the past, so no test can
  // accidentally depend on it also happening to be today.
  final saturday = DateTime(2026, 8, 22);

  test('first launch seeds the catalog into the database', () async {
    final templates = await db.select(db.taskTemplates).get();
    expect(templates, hasLength(TaskCatalog.all.length));
    expect(
      templates.map((t) => t.id),
      containsAll(TaskCatalog.all.map((t) => t.id)),
    );
  });

  test('materialising a day creates only the quests scheduled for it', () async {
    await repo.materialiseDay(wednesday);
    final quests = await repo.watchDay(wednesday).first;

    // Nine daily quests, and NOT the Saturday-only one.
    expect(quests.map((q) => q.template.id), isNot(contains('saturday_full_care_day')));
    expect(quests, hasLength(9));
  });

  test('the weekly Saturday quest appears only on Saturday', () async {
    await repo.materialiseDay(saturday);
    final quests = await repo.watchDay(saturday).first;

    expect(quests.map((q) => q.template.id), contains('saturday_full_care_day'));
    expect(quests, hasLength(10));
  });

  test('materialising the same day twice does not duplicate quests', () async {
    await repo.materialiseDay(wednesday);
    await repo.materialiseDay(wednesday);

    final quests = await repo.watchDay(wednesday).first;
    expect(quests, hasLength(9));
  });

  test('completing a quest persists and updates the day rollup', () async {
    await repo.materialiseDay(wednesday);
    final before = await repo.watchDay(wednesday).first;
    final skincare =
        before.firstWhere((q) => q.template.id == 'morning_skincare');

    await repo.setDone(skincare, true);

    // Re-read from the database, not from the in-memory object.
    final after = await repo.watchDay(wednesday).first;
    final updated = after.firstWhere((q) => q.id == skincare.id);
    expect(updated.status, QuestStatus.done);
    expect(updated.done, isTrue);
    expect(updated.completedAt, isNotNull);

    final rollup = await (db.select(db.dayRollups)
          ..where((r) => r.day.equals(dayKeyOf(wednesday))))
        .getSingle();
    expect(rollup.xpEarned, 10);
    expect(rollup.questsCleared, 1);
    expect(rollup.questsTotal, 9);
    expect(rollup.isPerfect, isFalse);
    // Morning skincare feeds REC.
    expect(rollup.recXp, 10);
    expect(rollup.strXp, 0);
  });

  test('un-completing a quest reverses the totals', () async {
    await repo.materialiseDay(wednesday);
    final quests = await repo.watchDay(wednesday).first;
    final skincare = quests.firstWhere((q) => q.template.id == 'morning_skincare');

    await repo.setDone(skincare, true);
    await repo.setDone(skincare, false);

    final rollup = await (db.select(db.dayRollups)
          ..where((r) => r.day.equals(dayKeyOf(wednesday))))
        .getSingle();
    expect(rollup.xpEarned, 0);
    expect(rollup.questsCleared, 0);

    final player = await (db.select(db.playerStates)
          ..where((p) => p.id.equals(0)))
        .getSingle();
    expect(player.totalXp, 0);
  });

  test('clearing every quest marks the day perfect', () async {
    await repo.materialiseDay(wednesday);
    for (final quest in await repo.watchDay(wednesday).first) {
      await repo.setDone(quest, true);
    }

    final rollup = await (db.select(db.dayRollups)
          ..where((r) => r.day.equals(dayKeyOf(wednesday))))
        .getSingle();
    expect(rollup.isPerfect, isTrue);
    expect(rollup.xpEarned, rollup.xpAvailable);
  });

  test('player totals accumulate across multiple days', () async {
    await repo.materialiseDay(wednesday);
    await repo.materialiseDay(saturday);

    final wed = await repo.watchDay(wednesday).first;
    final sat = await repo.watchDay(saturday).first;

    await repo.setDone(wed.firstWhere((q) => q.template.id == 'morning_skincare'), true);
    await repo.setDone(sat.firstWhere((q) => q.template.id == 'sleep_by_11pm'), true);

    final player = await (db.select(db.playerStates)..where((p) => p.id.equals(0)))
        .getSingle();
    expect(player.totalXp, 25); // 10 skincare (REC) + 15 sleep (DIS)
    expect(player.recXp, 10);
    expect(player.disXp, 15);
  });

  test('XP is snapshotted, so re-rating a template cannot rewrite history', () async {
    await repo.materialiseDay(wednesday);
    final quests = await repo.watchDay(wednesday).first;
    final skincare = quests.firstWhere((q) => q.template.id == 'morning_skincare');
    await repo.setDone(skincare, true);

    // Re-rate the catalog entry from 10 XP to 99 XP.
    await (db.update(db.taskTemplates)..where((t) => t.id.equals('morning_skincare')))
        .write(const TaskTemplatesCompanion(xp: Value(99)));

    await repo.recomputeAll();

    final rollup = await (db.select(db.dayRollups)
          ..where((r) => r.day.equals(dayKeyOf(wednesday))))
        .getSingle();
    // Still 10 — the already-issued quest keeps the value it was scored at.
    expect(rollup.xpEarned, 10);
  });

  test('recomputeAll rebuilds caches that have been corrupted', () async {
    await repo.materialiseDay(wednesday);
    final quests = await repo.watchDay(wednesday).first;
    await repo.setDone(quests.first, true);

    // Deliberately corrupt the cached rollup and player totals.
    await (db.update(db.dayRollups)..where((r) => r.day.equals(dayKeyOf(wednesday))))
        .write(const DayRollupsCompanion(xpEarned: Value(9999)));
    await (db.update(db.playerStates)..where((p) => p.id.equals(0)))
        .write(const PlayerStatesCompanion(totalXp: Value(9999)));

    await repo.recomputeAll();

    final rollup = await (db.select(db.dayRollups)
          ..where((r) => r.day.equals(dayKeyOf(wednesday))))
        .getSingle();
    final player = await (db.select(db.playerStates)..where((p) => p.id.equals(0)))
        .getSingle();
    expect(rollup.xpEarned, quests.first.xpAwarded);
    expect(player.totalXp, quests.first.xpAwarded);
  });

  test('completing a quest writes an activity log entry', () async {
    await repo.materialiseDay(wednesday);
    final quests = await repo.watchDay(wednesday).first;
    await repo.setDone(quests.first, true);

    final log = await db.select(db.activityLogEntries).get();
    expect(log, hasLength(1));
    expect(log.single.kind, ActivityKind.questCleared);
    expect(log.single.xpDelta, quests.first.xpAwarded);
  });

  group('the guided routine', () {
    test('quests snapshot the timings they were issued with', () async {
      await repo.materialiseDay(wednesday);
      final quests = await repo.watchDay(wednesday).first;
      final detox = quests.firstWhere((q) => q.template.id == 'detox_drink');

      expect(detox.scheduledMinutes, 5 * 60 + 35);
      expect(detox.graceMinutes, 45);
      expect(detox.scheduledLabel, '5:35 AM');
    });

    test('the day is streamed in routine order, earliest step first', () async {
      await repo.materialiseDay(wednesday);
      final quests = await repo.watchDay(wednesday).first;

      final times = quests.map((q) => q.scheduledMinutes!).toList();
      expect(times, orderedEquals([...times]..sort()));
      expect(quests.first.template.id, 'detox_drink');
      expect(quests.last.template.id, 'sleep_by_11pm');
    });

    test('unanswered steps of a finished day close as missed', () async {
      await repo.materialiseDay(wednesday);
      final closed = await repo.closeLapsedSteps(dayKeyOf(wednesday));

      // Every window on a past day has shut, so every step resolves.
      expect(closed, 9);
      final quests = await repo.watchDay(wednesday).first;
      expect(quests.every((q) => q.status == QuestStatus.missed), isTrue);
    });

    test('closing lapsed steps is idempotent', () async {
      await repo.materialiseDay(wednesday);
      await repo.closeLapsedSteps(dayKeyOf(wednesday));
      // Nothing left to close, so the second pass must be a no-op rather than
      // logging every step as missed all over again.
      expect(await repo.closeLapsedSteps(dayKeyOf(wednesday)), 0);
    });

    test('a step answered in time is left alone when the day closes', () async {
      await repo.materialiseDay(wednesday);
      final quests = await repo.watchDay(wednesday).first;
      final detox = quests.firstWhere((q) => q.template.id == 'detox_drink');
      await repo.setStatus(detox, QuestStatus.done);

      await repo.closeLapsedSteps(dayKeyOf(wednesday));

      final after = await repo.watchDay(wednesday).first;
      final updated = after.firstWhere((q) => q.id == detox.id);
      expect(updated.status, QuestStatus.done);
    });

    test('today keeps its open steps pending while their windows last', () async {
      // 21:30: everything up to the evening has lapsed, but the 8pm water
      // step is still inside its window, and the 9pm dinner step has not
      // opened yet.
      final now = FixedClock.todayAt(21, 30);
      final timed = QuestRepository(db, clock: now);
      await timed.openToday();

      final quests = await timed.watchDay(now.now()).first;
      QuestStatus statusOf(String id) =>
          quests.firstWhere((q) => q.template.id == id).status;

      expect(statusOf('detox_drink'), QuestStatus.missed);
      expect(statusOf('morning_skincare'), QuestStatus.missed);
      expect(statusOf('drink_3l_water'), QuestStatus.pending);
      expect(statusOf('sleep_by_11pm'), QuestStatus.pending);
    });

    test('the routine engine makes the 8pm step the active one at 21:30', () async {
      final now = FixedClock.todayAt(21, 30);
      final timed = QuestRepository(db, clock: now);
      await timed.openToday();

      final quests = await timed.watchDay(now.now()).first;
      final routine = buildRoutine(
        steps: quests,
        cursor: dayCursor(
          dayKey: dayKeyOf(now.now()),
          todayKey: dayKeyOf(now.now()),
          now: now.now(),
        ),
      );

      final active = routine.where((s) => s.isActive).toList();
      expect(active, hasLength(1));
      expect(active.single.task.template.id, 'drink_3l_water');
    });

    test('a miss costs no XP but does fail the day', () async {
      await repo.materialiseDay(wednesday);
      final quests = await repo.watchDay(wednesday).first;
      final skincare =
          quests.firstWhere((q) => q.template.id == 'morning_skincare');

      await repo.setStatus(skincare, QuestStatus.done);
      final earned = await _xpEarned(db, wednesday);

      await repo.setStatus(
        quests.firstWhere((q) => q.template.id == 'detox_drink'),
        QuestStatus.missed,
      );

      // XP is the record of what happened; a miss never rewrites it.
      expect(await _xpEarned(db, wednesday), earned);

      final rollup = await (db.select(db.dayRollups)
            ..where((r) => r.day.equals(dayKeyOf(wednesday))))
          .getSingle();
      expect(rollup.questsMissed, 1);
      expect(rollup.isPerfect, isFalse);
    });

    test('a missed step is logged without an XP delta', () async {
      await repo.materialiseDay(wednesday);
      final quests = await repo.watchDay(wednesday).first;
      await repo.setStatus(quests.first, QuestStatus.missed);

      final log = await db.select(db.activityLogEntries).get();
      expect(log.single.kind, ActivityKind.questMissed);
      expect(log.single.xpDelta, isNull);
    });

    test('reopening a completed step gives back the XP it awarded', () async {
      await repo.materialiseDay(wednesday);
      final quests = await repo.watchDay(wednesday).first;
      final skincare =
          quests.firstWhere((q) => q.template.id == 'morning_skincare');

      await repo.setStatus(skincare, QuestStatus.done);
      final done = await repo.watchDay(wednesday).first;
      await repo.setStatus(
        done.firstWhere((q) => q.id == skincare.id),
        QuestStatus.pending,
      );

      expect(await _xpEarned(db, wednesday), 0);
    });
  });
}

/// The XP actually banked for a day, read back from the cached rollup.
Future<int> _xpEarned(AppDatabase db, DateTime date) async {
  final rollup = await (db.select(db.dayRollups)
        ..where((r) => r.day.equals(dayKeyOf(date))))
      .getSingle();
  return rollup.xpEarned;
}
