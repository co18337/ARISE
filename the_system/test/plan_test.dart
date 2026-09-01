import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/repositories/plan_repository.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';

/// Phase 14 — the catalog, editable.
///
/// The two rules worth proving are both consequences of daily quests
/// SNAPSHOTTING their xp and timings at issue: editing changes tomorrow, and a
/// step with history is archived rather than deleted.
void main() {
  late AppDatabase db;
  late PlanRepository plan;
  late QuestRepository quests;
  final clock = FixedClock.todayAt(9, 0);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    plan = PlanRepository(db);
    quests = QuestRepository(db, clock: clock);
  });

  tearDown(() async => db.close());

  test('the plan reads back in routine order', () async {
    final entries = await plan.read();

    expect(entries, isNotEmpty);
    // Earliest first; unscheduled steps coalesce to the end.
    final timed = [
      for (final e in entries)
        if (e.template.scheduledMinutes != null) e.template.scheduledMinutes!,
    ];
    for (var i = 1; i < timed.length; i++) {
      expect(timed[i], greaterThanOrEqualTo(timed[i - 1]));
    }
  });

  test('editing a step changes tomorrow, not yesterday', () async {
    // The rule the whole screen turns on. Re-timing a step must not decide,
    // after the fact, whether last Tuesday's had lapsed.
    await quests.materialiseDay(clock.now());
    final before = (await quests.readDay(clock.now()))
        .firstWhere((q) => q.template.id == 'detox_drink');
    final issuedXp = before.xpAwarded;
    final issuedTime = before.scheduledMinutes;

    final entry = (await plan.read())
        .firstWhere((e) => e.template.id == 'detox_drink');
    await plan.save(
      TaskTemplate(
        id: entry.template.id,
        title: entry.template.title,
        category: entry.template.category,
        stat: entry.template.stat,
        schedule: entry.template.schedule,
        daysOfWeek: entry.template.daysOfWeek,
        xp: issuedXp + 25,
        scheduledMinutes: (issuedTime ?? 0) + 90,
        graceMinutes: entry.template.graceMinutes,
      ),
    );

    // The catalog moved...
    final after = (await plan.read())
        .firstWhere((e) => e.template.id == 'detox_drink');
    expect(after.template.xp, issuedXp + 25);

    // ...and today's already-issued quest did not.
    final today = (await quests.readDay(clock.now()))
        .firstWhere((q) => q.template.id == 'detox_drink');
    expect(today.xpAwarded, issuedXp);
    expect(today.scheduledMinutes, issuedTime);
  });

  test('a step with history is archived, never deleted', () async {
    await quests.materialiseDay(clock.now());

    final deleted = await plan.delete('detox_drink');

    expect(deleted, isFalse, reason: 'it has days behind it');
    final entry = (await plan.read())
        .firstWhere((e) => e.template.id == 'detox_drink');
    expect(entry.isActive, isFalse);
    expect(entry.hasHistory, isTrue);
    // And the day that used it is intact.
    expect(await quests.readDay(clock.now()), isNotEmpty);
  });

  test('a step never issued is deleted outright', () async {
    await plan.save(
      const TaskTemplate(
        id: 'cold_shower',
        title: 'Cold shower',
        category: TaskCategory.grooming,
        stat: StatType.dis,
        schedule: ScheduleType.daily,
        xp: 5,
        scheduledMinutes: 7 * 60,
        graceMinutes: 60,
      ),
    );
    expect(await plan.delete('cold_shower'), isTrue);
    expect(
      (await plan.read()).where((e) => e.template.id == 'cold_shower'),
      isEmpty,
    );
  });

  test('an archived step stops being issued', () async {
    await plan.setActive('detox_drink', false);
    await quests.materialiseDay(clock.now());

    final ids = (await quests.readDay(clock.now()))
        .map((q) => q.template.id);
    expect(ids, isNot(contains('detox_drink')));
  });

  test('a new step is issued from the next day it is materialised', () async {
    await plan.save(
      const TaskTemplate(
        id: 'evening_walk',
        title: 'Evening walk',
        category: TaskCategory.workout,
        stat: StatType.sta,
        schedule: ScheduleType.daily,
        xp: 12,
        scheduledMinutes: 19 * 60,
        graceMinutes: 90,
      ),
    );
    await quests.materialiseDay(clock.now());

    final issued = (await quests.readDay(clock.now()))
        .firstWhere((q) => q.template.id == 'evening_walk');
    expect(issued.xpAwarded, 12);
    expect(issued.scheduledMinutes, 19 * 60);
  });

  test('titles become readable ids', () {
    expect(PlanRepository.idFor('Cold shower'), 'cold_shower');
    expect(PlanRepository.idFor('  Drink 3L water!  '), 'drink_3l_water');
    // Never empty, or the row could not be written at all.
    expect(PlanRepository.idFor('!!!'), startsWith('step_'));
  });
}
