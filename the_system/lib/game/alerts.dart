import '../models/models.dart';
import 'clock.dart';

/// What an alert is for. Decides how loudly it arrives.
enum AlertKind {
  /// The 5:30 wake buzzer. The one alert allowed to be an alarm — full
  /// volume, past a silenced phone, and it is the whole reason exact-alarm
  /// permission is worth asking for.
  wake('WAKE', 'THE SYSTEM'),

  /// A step's window has opened. Ordinary notification.
  stepDue('STEP DUE', 'QUEST AVAILABLE'),

  /// A step's window is about to shut and it is still unanswered.
  stepClosing('CLOSING', 'QUEST EXPIRING'),

  /// The day is over and something is still unclaimed.
  dayReview('REVIEW', 'THE DAY IS DONE');

  final String label;

  /// The notification title.
  final String title;

  const AlertKind(this.label, this.title);

  /// True for the one alert that should behave like an alarm clock.
  bool get isAlarm => this == AlertKind.wake;
}

/// One notification to be posted at one moment.
///
/// A VALUE, not a scheduled thing. Producing this list is pure and testable;
/// handing it to the operating system is somebody else's job.
class ScheduledAlert {
  /// Stable across reschedules, so re-running the planner replaces alerts
  /// rather than duplicating them. Derived from the day and the step, never
  /// random — a random id means yesterday's alert cannot be cancelled.
  final int id;

  final AlertKind kind;
  final DateTime at;
  final String title;
  final String body;

  /// The quest this belongs to, or null for day-level alerts.
  final String? templateId;

  const ScheduledAlert({
    required this.id,
    required this.kind,
    required this.at,
    required this.title,
    required this.body,
    this.templateId,
  });

  @override
  String toString() => '$kind at $at: $title — $body';

  @override
  bool operator ==(Object other) =>
      other is ScheduledAlert &&
      other.id == id &&
      other.at == at &&
      other.title == title &&
      other.body == body;

  @override
  int get hashCode => Object.hash(id, at, title, body);
}

/// What the routine wants the phone to say, and when.
///
/// Derived from the SAME quests the TODAY screen draws, so the routine and the
/// notifications can never disagree. There is no separate list of reminders to
/// keep in sync — a step whose time changes moves its alert with it, and a
/// step deleted from the catalog takes its alert with it too.
///
/// Pure: no plugin, no platform, no I/O. Everything below is a function of the
/// day's steps and a clock, which is what makes "the 8pm reminder fires at
/// 8pm and not at all once you have answered it" a real test rather than
/// something you find out by waiting until 8pm.
class AlertPlanner {
  /// How long before a window shuts to warn that it is about to.
  ///
  /// Fifteen minutes: long enough to actually do a two-minute step, short
  /// enough that the warning still means "now".
  static const int closingWarningMinutes = 15;

  const AlertPlanner();

  /// Every alert for [date], in time order.
  ///
  /// [tasks] are the day's steps as the routine issued them. ANSWERED STEPS
  /// GET NOTHING — the commonest way a reminder app becomes noise is by
  /// reminding you to do what you have already done.
  ///
  /// Alerts already in the past are dropped: rescheduling at 9pm must not fire
  /// the whole morning at once, which is exactly what happens if you hand an
  /// operating system a time that has already been and gone.
  List<ScheduledAlert> planFor({
    required DateTime date,
    required List<DailyTask> tasks,
    required Clock clock,
    bool includeWake = true,
    int wakeMinutes = 5 * 60 + 30,
  }) {
    final now = clock.now();
    final midnight = DateTime(date.year, date.month, date.day);
    final alerts = <ScheduledAlert>[];

    if (includeWake) {
      alerts.add(
        ScheduledAlert(
          id: _idFor(date, 'wake', 0),
          kind: AlertKind.wake,
          at: midnight.add(Duration(minutes: wakeMinutes)),
          title: AlertKind.wake.title,
          body: 'Wake up. Cold water on your face, no phone for ten minutes.',
        ),
      );
    }

    for (final task in tasks) {
      final scheduled = task.scheduledMinutes;
      if (scheduled == null) continue;

      // Answered is answered. No reminder, no warning, nothing.
      if (task.status != QuestStatus.pending) continue;

      final due = midnight.add(Duration(minutes: scheduled));
      alerts.add(
        ScheduledAlert(
          id: _idFor(date, task.template.id, 1),
          kind: AlertKind.stepDue,
          at: due,
          title: AlertKind.stepDue.title,
          body: '${task.template.title} — ${task.xpAwarded} XP.',
          templateId: task.template.id,
        ),
      );

      // The closing warning only earns its place when the window is long
      // enough for it to land meaningfully after the step opened.
      if (task.graceMinutes > closingWarningMinutes) {
        alerts.add(
          ScheduledAlert(
            id: _idFor(date, task.template.id, 2),
            kind: AlertKind.stepClosing,
            at: due.add(
              Duration(minutes: task.graceMinutes - closingWarningMinutes),
            ),
            title: AlertKind.stepClosing.title,
            body: '${task.template.title} closes in '
                '$closingWarningMinutes minutes.',
            templateId: task.template.id,
          ),
        );
      }
    }

    final future = [
      for (final alert in alerts)
        if (alert.at.isAfter(now)) alert,
    ]..sort((a, b) => a.at.compareTo(b.at));

    return future;
  }

  /// Wake alarms for the next [days] days, skipping any already past.
  ///
  /// SEPARATE from [planFor] on purpose, and the separation is the whole point.
  /// A step's alert needs that day's quests to exist in the database, and
  /// quests are only materialised when a day opens — so at seven in the
  /// evening tomorrow's steps do not exist yet. An app that only ever
  /// schedules TODAY can therefore never ring tomorrow morning, which is the
  /// entire reason for asking for exact-alarm permission in the first place.
  ///
  /// The wake time is CATALOG data, not database data, so it can be scheduled
  /// a week out without knowing anything about those days. A week rather than
  /// one night: it means the alarm survives a week of never opening the app,
  /// and seven pending alarms cost Android nothing.
  List<ScheduledAlert> wakeAlarms({
    required DateTime from,
    required Clock clock,
    int days = 7,
    int wakeMinutes = 5 * 60 + 30,
  }) {
    final now = clock.now();
    final start = DateTime(from.year, from.month, from.day);

    return [
      for (var i = 0; i < days; i++)
        if (start
            .add(Duration(days: i, minutes: wakeMinutes))
            .isAfter(now))
          ScheduledAlert(
            id: _idFor(start.add(Duration(days: i)), 'wake', 0),
            kind: AlertKind.wake,
            at: start.add(Duration(days: i, minutes: wakeMinutes)),
            title: AlertKind.wake.title,
            body: 'Wake up. Cold water on your face, no phone for ten '
                'minutes.',
          ),
    ];
  }

  /// The Sunday review reminder, for the next [weeks] Sundays.
  ///
  /// Scheduled the same way as the wake alarm and for the same reason: it does
  /// not depend on any day's quests existing, so it can be booked weeks ahead
  /// and survives the app not being opened.
  ///
  /// The notification does not WRITE the review — nothing in this app can run
  /// Dart from a notification, and a foreground service for one call a week
  /// would cost a permanent icon in the tray. It brings you to the app, and
  /// the app writes it on opening. Tapping it is the automatic path; ignoring
  /// it until Monday still gets you Sunday's review.
  List<ScheduledAlert> reviewReminders({
    required DateTime from,
    required Clock clock,
    int weeks = 4,
    int atMinutes = 20 * 60,
  }) {
    final now = clock.now();
    final start = DateTime(from.year, from.month, from.day);
    // Days until the coming Sunday; 0 when today is Sunday.
    final untilSunday = DateTime.sunday - start.weekday;

    return [
      for (var w = 0; w < weeks; w++)
        if (start
            .add(Duration(days: untilSunday + w * 7, minutes: atMinutes))
            .isAfter(now))
          ScheduledAlert(
            id: _idFor(
              start.add(Duration(days: untilSunday + w * 7)),
              'review',
              3,
            ),
            kind: AlertKind.dayReview,
            at: start.add(
              Duration(days: untilSunday + w * 7, minutes: atMinutes),
            ),
            title: AlertKind.dayReview.title,
            body: 'The week is done. Open the System for your review.',
          ),
    ];
  }

  /// A stable id from the date, the step and the slot.
  ///
  /// Android notification ids are 32-bit signed, so this has to stay inside
  /// that range — a hash that overflows silently collides, and a collision
  /// means one step's reminder cancels another's.
  static int _idFor(DateTime date, String key, int slot) {
    var hash = 0x811c9dc5;
    for (final unit in '${date.year}-${date.month}-${date.day}|$key|$slot'
        .codeUnits) {
      hash = (hash ^ unit) * 0x01000193;
      hash &= 0x7fffffff;
    }
    return hash;
  }
}
