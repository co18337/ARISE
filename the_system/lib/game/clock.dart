/// The app's source of "now".
///
/// Everything time-dependent goes through a Clock instead of calling
/// `DateTime.now()` directly. That one indirection is what makes the guided
/// routine testable: "the 9pm step lapses at 9:15" is a real rule with real
/// consequences, and there is no way to check it if the only clock available
/// is the machine's own.
///
/// The default implementation IS the system clock, so production code just
/// writes `const Clock()` and forgets about it.
class Clock {
  const Clock();

  DateTime now() => DateTime.now();
}

/// A clock frozen at one instant, for tests.
///
/// Tests build one at a chosen time of day — 21:30, say — so a known step of
/// the routine is the active one, no matter what time the test suite happens
/// to run at.
class FixedClock implements Clock {
  final DateTime instant;

  const FixedClock(this.instant);

  /// A fixed clock at [hour]:[minute] on today's date. Using today's date (and
  /// not a hardcoded one) keeps the fixed time consistent with day-number
  /// logic elsewhere, which is always relative to the real calendar.
  factory FixedClock.todayAt(int hour, int minute) {
    final now = DateTime.now();
    return FixedClock(DateTime(now.year, now.month, now.day, hour, minute));
  }

  @override
  DateTime now() => instant;
}
