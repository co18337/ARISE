import '../../game/game.dart';
import '../alerts/notifier.dart';
import 'quest_repository.dart';

/// Keeps the phone's alerts in step with the routine.
///
/// One rule holds the whole thing together: THE ROUTINE IS THE SOURCE OF
/// TRUTH. There is no second list of reminders to maintain — every alert is
/// derived from the same quests the TODAY screen draws, so a step whose time
/// changes moves its alert with it, a step removed from the catalog takes its
/// alert with it, and a step you have answered stops nagging you.
///
/// That means rescheduling is cheap and idempotent, which is why it is done
/// generously: on launch, when the day rolls over, and after every answer.
class AlertRepository {
  final QuestRepository quests;
  final Notifier notifier;
  final AlertPlanner planner;
  final Clock clock;

  /// Set false to keep the routine running with the phone silent. Alerts are
  /// an enhancement; the app has to be completely usable without them.
  bool enabled;

  AlertRepository({
    required this.quests,
    required this.notifier,
    this.planner = const AlertPlanner(),
    this.clock = const Clock(),
    this.enabled = true,
  });

  Future<NotifierStatus> status() => notifier.status();

  Future<NotifierStatus> requestPermissions() =>
      notifier.requestPermissions();

  Future<void> fireTest() => notifier.fireTest();

  /// Books a real alarm through the wake path, to prove scheduling works.
  Future<void> fireTestIn(Duration delay) => notifier.fireTestIn(delay);

  /// Everything that would be scheduled, without touching the OS.
  ///
  /// TWO horizons, because the two kinds of alert know different things.
  /// Step reminders come from today's quests and can only ever cover today —
  /// tomorrow's quests do not exist until tomorrow opens. Wake alarms come
  /// from the catalog and are scheduled a WEEK ahead, so the 5:30 buzzer rings
  /// tomorrow even though the app was last opened this evening. Without that
  /// split the alarm could only ever fire on a day you had already opened the
  /// app before 5:30, which is nobody.
  ///
  /// Exposed so the ALERTS screen can show the real times. A list you can read
  /// beats a promise that something will happen.
  Future<List<ScheduledAlert>> planAhead() async {
    final today = clock.now();
    return [
      ...planner.planFor(
        date: today,
        tasks: await quests.readDay(today),
        clock: clock,
        includeWake: false,
      ),
      ...planner.wakeAlarms(from: today, clock: clock),
      // Booked a month out, like the wake alarm: it needs no day's quests to
      // exist, so it survives the app not being opened.
      ...planner.reviewReminders(from: today, clock: clock),
    ]..sort((a, b) => a.at.compareTo(b.at));
  }

  /// Reconciles the operating system with the routine.
  ///
  /// Safe to call as often as you like — the planner produces stable ids from
  /// the date and the step, so re-running replaces rather than duplicates.
  /// Never throws: a phone that refuses notifications is still a phone that
  /// runs the app, and a failure here must not break opening the day.
  Future<void> reschedule() async {
    try {
      if (!enabled) {
        await notifier.cancelAll();
        return;
      }
      await notifier.schedule(await planAhead());
    } catch (_) {
      // Deliberately swallowed. Callers are `openToday` and "quest answered",
      // and neither should fail because a notification could not be posted.
    }
  }

  Future<void> disable() async {
    enabled = false;
    await notifier.cancelAll();
  }

  Future<void> enable() async {
    enabled = true;
    await reschedule();
  }
}
