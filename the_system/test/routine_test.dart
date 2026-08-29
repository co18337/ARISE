import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';

/// The unlock rule is the part of Phase 6 that's easy to get wrong, so it gets
/// tested on its own, away from any database or widget: **time gates a step,
/// answering it advances the day.**
void main() {
  /// Builds a step. Only the fields the engine actually reads are meaningful.
  DailyTask step({
    required int id,
    required int at,
    int grace = 60,
    QuestStatus status = QuestStatus.pending,
  }) => DailyTask(
    id: id,
    template: TaskTemplate(
      id: 'step_$id',
      title: 'Step $id',
      category: TaskCategory.diet,
      stat: StatType.rec,
      schedule: ScheduleType.daily,
      xp: 10,
      scheduledMinutes: at,
      graceMinutes: grace,
    ),
    date: DateTime(2026, 8, 26),
    status: status,
    completedAt: null,
    xpAwarded: 10,
    stat: StatType.rec,
    scheduledMinutes: at,
    graceMinutes: grace,
  );

  int at(int hour, int minute) => hour * 60 + minute;

  List<RoutineState> statesAt(List<DailyTask> steps, int cursor) =>
      buildRoutine(steps: steps, cursor: cursor).map((s) => s.state).toList();

  group('dayCursor', () {
    test('a past day is fully closed', () {
      expect(
        dayCursor(dayKey: 10, todayKey: 11, now: DateTime(2026, 8, 26, 9)),
        minutesInDay,
      );
    });

    test('a future day has not opened', () {
      expect(
        dayCursor(dayKey: 12, todayKey: 11, now: DateTime(2026, 8, 26, 9)),
        lessThan(0),
      );
    });

    test('today is the wall clock, in minutes since midnight', () {
      expect(
        dayCursor(dayKey: 11, todayKey: 11, now: DateTime(2026, 8, 26, 9, 30)),
        at(9, 30),
      );
    });
  });

  group('windows', () {
    test('a window shuts grace minutes after the scheduled time', () {
      expect(
        windowClosesAt(scheduledMinutes: at(5, 35), graceMinutes: 45),
        at(6, 20),
      );
    });

    test('a generous grace period cannot spill past midnight', () {
      // 23:00 + 3h would be 2am tomorrow, which is a day this step was never
      // issued for.
      expect(
        windowClosesAt(scheduledMinutes: at(23, 0), graceMinutes: 180),
        minutesInDay,
      );
    });
  });

  group('the unlock rule', () {
    final day = [
      step(id: 1, at: at(5, 35), grace: 45),
      step(id: 2, at: at(7, 10), grace: 90),
      step(id: 3, at: at(21, 0), grace: 60),
    ];

    test('before the first step, everything is locked', () {
      expect(statesAt(day, at(5, 0)), [
        RoutineState.locked,
        RoutineState.locked,
        RoutineState.locked,
      ]);
    });

    test('the step whose time has come is the active one', () {
      expect(statesAt(day, at(5, 40)), [
        RoutineState.active,
        RoutineState.locked,
        RoutineState.locked,
      ]);
    });

    test('a later step stays locked while an earlier one is still open', () {
      // Both times have come, but step 1's window is still open, so the day
      // has not advanced past it. This is the sequential half of the rule.
      final stillOpen = [
        step(id: 1, at: at(5, 35), grace: 300), // open until 10:35
        step(id: 2, at: at(7, 10), grace: 90),
      ];
      expect(statesAt(stillOpen, at(7, 30)), [
        RoutineState.active,
        RoutineState.locked,
      ]);
    });

    test('an unanswered step whose window shut counts as missed', () {
      // Step 1 shut at 6:20 and nobody answered it. The day closes itself.
      expect(statesAt(day, at(7, 30))[0], RoutineState.missed);
    });

    test('a lapsed step still advances the day', () {
      // Step 1's window shut unanswered at 6:20, so by 7:30 the day has moved
      // on to step 2. This is what stops the routine stranding you forever on
      // a step you can no longer do.
      expect(statesAt(day, at(7, 30)), [
        RoutineState.missed,
        RoutineState.active,
        RoutineState.locked,
      ]);
    });

    test('answering a step advances to the next one', () {
      final answered = [
        step(id: 1, at: at(5, 35), grace: 45, status: QuestStatus.done),
        step(id: 2, at: at(7, 10), grace: 90),
      ];
      // 6:00: step 1 is answered and step 2's time has NOT come, so nothing
      // is active — the routine waits rather than running ahead.
      expect(statesAt(answered, at(6, 0)), [
        RoutineState.done,
        RoutineState.locked,
      ]);
      // 7:15: its time has come and nothing blocks it.
      expect(statesAt(answered, at(7, 15))[1], RoutineState.active);
    });

    test('an answered step keeps its answer even after its window shuts', () {
      final done = [
        step(id: 1, at: at(5, 35), grace: 45, status: QuestStatus.done),
      ];
      expect(statesAt(done, at(23, 0)), [RoutineState.done]);
    });

    test('at most one step is ever active', () {
      for (var minute = 0; minute <= minutesInDay; minute += 5) {
        final active = statesAt(day, minute)
            .where((s) => s == RoutineState.active)
            .length;
        expect(active, lessThanOrEqualTo(1), reason: 'at minute $minute');
      }
    });

    test('a finished past day has no pending steps left', () {
      final states = statesAt(day, minutesInDay);
      expect(states, everyElement(isNot(RoutineState.active)));
      expect(states, everyElement(isNot(RoutineState.locked)));
    });
  });

  test('an unscheduled step is available from the start of the day', () {
    final anytime = [
      step(id: 1, at: 0, grace: minutesInDay),
    ];
    expect(statesAt(anytime, at(0, 30)), [RoutineState.active]);
  });
}
