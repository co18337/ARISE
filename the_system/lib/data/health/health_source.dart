/// One day of health figures, as read from the platform.
///
/// A plain value with no database and no plugin in it, so the repository can be
/// tested against a handful of these without Health Connect existing.
class HealthDay {
  final DateTime date;
  final int? steps;
  final int? sleepMinutes;
  final int? restingHeartRate;
  final int? activeKcal;
  final int? distanceM;
  final int? workoutMinutes;

  const HealthDay({
    required this.date,
    this.steps,
    this.sleepMinutes,
    this.restingHeartRate,
    this.activeKcal,
    this.distanceM,
    this.workoutMinutes,
  });

  /// True when the platform gave us nothing at all for this day.
  ///
  /// Worth distinguishing from a day of zero steps: an empty day means the
  /// phone was off or unworn, and writing zeros for it would draw a flat line
  /// that looks like a fortnight of lying still.
  bool get isEmpty =>
      steps == null &&
      sleepMinutes == null &&
      restingHeartRate == null &&
      activeKcal == null &&
      distanceM == null &&
      workoutMinutes == null;
}

/// Whether the platform will give us anything.
class HealthStatus {
  final bool supported;
  final bool available;
  final bool authorised;
  final String? error;

  const HealthStatus({
    required this.supported,
    this.available = false,
    this.authorised = false,
    this.error,
  });

  static const HealthStatus unsupported = HealthStatus(supported: false);

  bool get canSync => supported && available && authorised;

  String get summary {
    if (!supported) return 'Not available on this platform';
    if (!available) return 'Health Connect is not installed';
    if (!authorised) return 'Permission not granted';
    return 'Connected';
  }
}

/// The seam between the System and Health Connect.
///
/// The same shape as TrainerAdvisor and Notifier, and for the same reason:
/// everything above this line is pure and testable, everything below it is a
/// plugin that cannot run in `flutter test` or in Chrome. The app must be
/// completely usable with health sync refused — every quest can still be
/// answered by hand, which is how it has worked all along.
abstract class HealthSource {
  Future<HealthStatus> status();

  /// Asks for read access. Returns the status afterwards.
  Future<HealthStatus> requestPermissions();

  /// Daily totals for [days] back from today, oldest first.
  ///
  /// Days the platform knows nothing about are OMITTED rather than returned as
  /// zeros — see [HealthDay.isEmpty].
  Future<List<HealthDay>> readDays({required int days});
}

/// Web, tests, and anywhere Health Connect does not exist.
class NoopHealthSource implements HealthSource {
  /// Days handed back by [readDays], so a test can drive the repository
  /// without a platform channel anywhere near it.
  final List<HealthDay> days;

  int readCount = 0;

  NoopHealthSource({this.days = const []});

  @override
  Future<HealthStatus> status() async => HealthStatus.unsupported;

  @override
  Future<HealthStatus> requestPermissions() async => HealthStatus.unsupported;

  @override
  Future<List<HealthDay>> readDays({required int days}) async {
    readCount++;
    return this.days;
  }
}
