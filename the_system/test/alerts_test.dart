import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';

/// Phase 9 — the half of notifications that needs no phone.
///
/// Which alerts exist, when they fire, and which ones deliberately do NOT is
/// a pure function of the day's steps and a clock. That is worth testing here
/// rather than by waiting until 8pm on a real device to find out.
void main() {
  const planner = AlertPlanner();
  final day = DateTime(2026, 9, 2);

  DailyTask task(
    String id,
    String title, {
    required int? minutes,
    int grace = 120,
    QuestStatus status = QuestStatus.pending,
    int xp = 10,
  }) => DailyTask(
    id: id.hashCode,
    template: TaskTemplate(
      id: id,
      title: title,
      category: TaskCategory.hydration,
      stat: StatType.rec,
      schedule: ScheduleType.daily,
      xp: xp,
      scheduledMinutes: minutes,
      graceMinutes: grace,
    ),
    date: day,
    status: status,
    completedAt: null,
    xpAwarded: xp,
    stat: StatType.rec,
    scheduledMinutes: minutes,
    graceMinutes: grace,
  );

  /// Just before the day starts, so everything is still ahead.
  Clock atMidnight() => FixedClock(DateTime(2026, 9, 2, 0, 1));

  test('the wake alarm is scheduled for the time the plan names', () {
    final alerts = planner.planFor(
      date: day,
      tasks: const [],
      clock: atMidnight(),
    );

    expect(alerts, hasLength(1));
    expect(alerts.single.kind, AlertKind.wake);
    expect(alerts.single.at, DateTime(2026, 9, 2, 5, 30));
    // The one alert allowed to behave like an alarm clock.
    expect(alerts.single.kind.isAlarm, isTrue);
    expect(AlertKind.stepDue.isAlarm, isFalse);
  });

  test('each pending step gets a reminder and a closing warning', () {
    final alerts = planner.planFor(
      date: day,
      tasks: [task('water', 'Drink 3L water', minutes: 20 * 60, grace: 60)],
      clock: atMidnight(),
      includeWake: false,
    );

    expect(alerts, hasLength(2));
    expect(alerts.first.kind, AlertKind.stepDue);
    expect(alerts.first.at, DateTime(2026, 9, 2, 20, 0));
    expect(alerts.first.body, contains('Drink 3L water'));

    // 60 minutes of grace, warned 15 before it shuts.
    expect(alerts.last.kind, AlertKind.stepClosing);
    expect(alerts.last.at, DateTime(2026, 9, 2, 20, 45));
    expect(alerts.last.body, contains('closes in 15 minutes'));
  });

  test('an answered step is silent — done and missed alike', () {
    // The commonest way a reminder app becomes noise is reminding you to do
    // what you have already done.
    for (final status in [QuestStatus.done, QuestStatus.missed]) {
      final alerts = planner.planFor(
        date: day,
        tasks: [
          task('water', 'Drink 3L water', minutes: 20 * 60, status: status),
        ],
        clock: atMidnight(),
        includeWake: false,
      );
      expect(alerts, isEmpty, reason: status.name);
    }
  });

  test('a step with no scheduled time gets no alert', () {
    // Untimed steps exist — there is nothing to remind you AT.
    final alerts = planner.planFor(
      date: day,
      tasks: [task('anytime', 'Whenever', minutes: null)],
      clock: atMidnight(),
      includeWake: false,
    );
    expect(alerts, isEmpty);
  });

  test('alerts already in the past are dropped, never fired late', () {
    // Rescheduling at 9pm must not dump the whole morning into the tray at
    // once, which is exactly what happens if you hand the OS a past time.
    final alerts = planner.planFor(
      date: day,
      tasks: [
        task('detox', 'Detox drink', minutes: 5 * 60 + 35),
        task('sleep', 'Sleep by 11pm', minutes: 23 * 60),
      ],
      clock: FixedClock(DateTime(2026, 9, 2, 21, 0)),
    );

    expect(
      alerts.map((a) => a.templateId),
      everyElement(anyOf(isNull, 'sleep')),
      reason: 'the morning is gone; only tonight is left',
    );
    for (final alert in alerts) {
      expect(alert.at.isAfter(DateTime(2026, 9, 2, 21, 0)), isTrue);
    }
  });

  test('alerts come back in time order', () {
    final alerts = planner.planFor(
      date: day,
      tasks: [
        task('sleep', 'Sleep by 11pm', minutes: 23 * 60),
        task('detox', 'Detox drink', minutes: 5 * 60 + 35),
        task('water', 'Drink 3L water', minutes: 20 * 60),
      ],
      clock: atMidnight(),
    );

    for (var i = 1; i < alerts.length; i++) {
      expect(
        alerts[i].at.isBefore(alerts[i - 1].at),
        isFalse,
        reason: 'alert $i is out of order',
      );
    }
  });

  test('ids are stable, unique, and inside Android\'s 32-bit range', () {
    // A random id cannot be cancelled tomorrow, and a colliding one means
    // cancelling the water reminder silently kills the sleep reminder.
    List<ScheduledAlert> plan() => planner.planFor(
      date: day,
      tasks: [
        task('detox', 'Detox drink', minutes: 5 * 60 + 35),
        task('water', 'Drink 3L water', minutes: 20 * 60),
        task('sleep', 'Sleep by 11pm', minutes: 23 * 60),
      ],
      clock: atMidnight(),
    );

    final first = plan();
    final second = plan();
    expect(first, second, reason: 'replanning must produce the same ids');

    final ids = first.map((a) => a.id).toList();
    expect(ids.toSet(), hasLength(ids.length), reason: 'ids collide');
    for (final id in ids) {
      expect(id, greaterThanOrEqualTo(0));
      expect(id, lessThanOrEqualTo(0x7fffffff));
    }
  });

  test('a different day produces different ids', () {
    // Otherwise tomorrow's reschedule cancels today's still-pending alerts.
    List<int> idsOn(DateTime d) => planner
        .planFor(
          date: d,
          tasks: const [],
          clock: FixedClock(DateTime(d.year, d.month, d.day, 0, 1)),
        )
        .map((a) => a.id)
        .toList();

    expect(idsOn(DateTime(2026, 9, 2)), isNot(idsOn(DateTime(2026, 9, 3))));
  });

  test('a short window gets a reminder but no closing warning', () {
    // A 10-minute window warned 15 minutes before it shuts would fire before
    // the step even opened.
    final alerts = planner.planFor(
      date: day,
      tasks: [task('quick', 'Sunscreen', minutes: 7 * 60 + 25, grace: 10)],
      clock: atMidnight(),
      includeWake: false,
    );

    expect(alerts, hasLength(1));
    expect(alerts.single.kind, AlertKind.stepDue);
  });
}
