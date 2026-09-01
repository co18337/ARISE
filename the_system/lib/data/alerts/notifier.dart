import '../../game/game.dart';

/// Whether the operating system will actually let us post anything.
///
/// Three separate grants on modern Android and they fail differently, so they
/// are reported separately rather than collapsed into one bool:
///   - POST_NOTIFICATIONS, refused → nothing appears at all;
///   - SCHEDULE_EXACT_ALARM, refused → alerts still arrive, but Android may
///     slide them by minutes to batch them, which is fine for a reminder and
///     useless for a 5:30 wake alarm;
///   - battery optimisation, aggressive → alerts arrive late or not at all
///     after the phone has been idle, and no API reports this reliably.
class NotifierStatus {
  final bool supported;
  final bool notificationsAllowed;
  final bool exactAlarmsAllowed;

  /// How many alerts are currently scheduled with the OS.
  final int scheduled;

  /// Something the platform said went wrong, verbatim.
  final String? error;

  const NotifierStatus({
    required this.supported,
    this.notificationsAllowed = false,
    this.exactAlarmsAllowed = false,
    this.scheduled = 0,
    this.error,
  });

  static const NotifierStatus unsupported = NotifierStatus(supported: false);

  /// True when the wake alarm can be trusted to land on the minute.
  bool get canWakeReliably => notificationsAllowed && exactAlarmsAllowed;

  String get summary {
    if (!supported) return 'Not available on this platform';
    if (!notificationsAllowed) return 'Notifications are switched off';
    if (!exactAlarmsAllowed) return 'Reminders on · wake alarm may drift';
    return 'Armed';
  }
}

/// The seam between the routine and the operating system.
///
/// The same shape as TrainerAdvisor and for the same reason: everything above
/// this line is pure and testable, everything below it is a plugin that cannot
/// run in `flutter test` or in Chrome. `NoopNotifier` is the floor — the app
/// must be completely usable with every notification refused.
abstract class Notifier {
  /// Set up channels and time zones. Safe to call more than once.
  Future<void> initialise();

  Future<NotifierStatus> status();

  /// Asks for whatever has not been granted. Returns the status afterwards.
  Future<NotifierStatus> requestPermissions();

  /// Replaces everything scheduled with exactly [alerts].
  ///
  /// Cancel-then-schedule rather than a diff. The alert ids are derived from
  /// the day and the step, so re-planning produces the same ids and a diff
  /// would be a lot of bookkeeping to avoid one cheap call — and getting the
  /// bookkeeping wrong means a stale reminder for a step you already did.
  Future<void> schedule(List<ScheduledAlert> alerts);

  Future<void> cancelAll();

  /// Posts one immediately, so "is this thing on" is answerable without
  /// waiting until 5:30 tomorrow.
  ///
  /// Proves the permission and the channel. It does NOT prove the alarm: this
  /// posts directly, while a real alert goes through AlarmManager. Those are
  /// different code paths and only one of them can be broken by battery
  /// optimisation. See [fireTestIn].
  Future<void> fireTest();

  /// Schedules a test through the SAME path the wake alarm uses.
  ///
  /// The one that actually matters. `show()` succeeding tells you nothing
  /// about whether Android will wake your app up in eight hours' time — which
  /// is the entire question — so this books a real exact alarm a couple of
  /// minutes out, on the wake channel, at alarm volume.
  Future<void> fireTestIn(Duration delay);
}

/// The implementation used on web and in tests: does nothing, successfully.
///
/// Records what it was asked to do so tests can assert on it without a
/// platform channel anywhere near them.
class NoopNotifier implements Notifier {
  final List<ScheduledAlert> lastScheduled = [];
  int cancelCount = 0;
  int testFireCount = 0;
  Duration? lastTestDelay;

  NoopNotifier();

  @override
  Future<void> initialise() async {}

  @override
  Future<NotifierStatus> status() async => NotifierStatus.unsupported;

  @override
  Future<NotifierStatus> requestPermissions() async =>
      NotifierStatus.unsupported;

  @override
  Future<void> schedule(List<ScheduledAlert> alerts) async {
    lastScheduled
      ..clear()
      ..addAll(alerts);
  }

  @override
  Future<void> cancelAll() async {
    cancelCount++;
    lastScheduled.clear();
  }

  @override
  Future<void> fireTest() async => testFireCount++;

  @override
  Future<void> fireTestIn(Duration delay) async {
    testFireCount++;
    lastTestDelay = delay;
  }
}
