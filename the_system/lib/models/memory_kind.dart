/// What a stored memory document actually is.
///
/// The kind matters for retrieval, not just tidiness: asking "how has my
/// training been going" should search sessions, not a six-month-old blood
/// panel, and a body scan should be weighted differently from yesterday's
/// step count.
enum MemoryKind {
  /// A body-composition scan (Tanita BCA and the like). The baseline
  /// everything else is measured against.
  bodyScan('BODY SCAN'),

  /// The written transformation plan.
  transformationPlan('PLAN'),

  /// One completed training session, summarised.
  workoutSession('SESSION'),

  /// A day of synced health data — steps, sleep, heart rate.
  healthSync('HEALTH'),

  /// How a day's routine actually went.
  dailyLog('DAY'),

  /// Anything written by hand.
  note('NOTE');

  final String label;

  const MemoryKind(this.label);
}
