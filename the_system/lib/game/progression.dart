
/// What the record says about one movement.
///
/// Everything the progression rules are allowed to read. Assembled from the
/// set history by the repository, so the rules themselves stay pure.
class ExerciseRecord {
  /// Sessions of this movement completed IN FULL. Half-done sessions have
  /// never counted, because growing a prescription on work you did not finish
  /// grows it past you.
  final int cleared;

  /// The weight last actually used, in half-kilos. Null for a movement that
  /// carries none, or one never yet performed.
  final int? lastLoadHalfKg;

  /// How the last few sets went against what was asked, as a ratio.
  ///
  /// 1.0 is exactly the prescription. 1.4 means finishing 12-minute runs at
  /// 17 minutes. Null when nothing has been logged with an amount.
  final double? margin;

  /// The most ever logged in one set — 22 for a 22-minute run, 14 for
  /// fourteen push-ups.
  ///
  /// BEST-EVER rather than most-recent, because a benchmark asks what you can
  /// do, and one bad Tuesday does not take away a thing you have proven.
  final int? bestActual;

  const ExerciseRecord({
    this.cleared = 0,
    this.lastLoadHalfKg,
    this.margin,
    this.bestActual,
  });

  static const ExerciseRecord none = ExerciseRecord();

  /// Comfortably beyond what was asked, repeatedly.
  ///
  /// 1.25 rather than anything tighter: one big day is enthusiasm, and only a
  /// sustained margin means the step itself is too small.
  bool get isEasy => (margin ?? 1) >= 1.25;

  /// Falling short of the prescription.
  bool get isHard => (margin ?? 1) < 0.9;
}

/// One movement graduating into a harder one.
///
/// The thing a phase template cannot express: WHEN you move on. A template
/// says "lat pulldown in week 3" whether or not you can hang from a bar for
/// twenty seconds. A ladder says you pull down until pulling down is easy,
/// and then you start doing the harder thing.
class ProgressionLadder {
  /// Easiest first. Each rung is an exercise id from the catalog.
  final List<String> rungs;

  /// Full sessions of a rung before the next one is even considered.
  ///
  /// Six: roughly a fortnight at the rate these appear in the week. Fewer and
  /// a good week promotes you; more and a genuinely ready athlete is held
  /// back for no reason.
  final int clearsPerRung;

  const ProgressionLadder(this.rungs, {this.clearsPerRung = 6});

  /// The rung to prescribe today, given how each has gone.
  ///
  /// Walks up from the bottom and stops at the first rung not yet earned. It
  /// never skips: earning the third rung means having earned the second, so
  /// somebody cannot arrive at full pull-ups because they were consistent at
  /// dead hangs alone.
  ///
  /// A rung is earned by clearing it [clearsPerRung] times AND finding it
  /// easy. Both, because six grinding sessions is not readiness — it is six
  /// grinding sessions.
  String currentRung(Map<String, ExerciseRecord> history) {
    for (var i = 0; i < rungs.length - 1; i++) {
      final record = history[rungs[i]] ?? ExerciseRecord.none;
      final earned = record.cleared >= clearsPerRung && !record.isHard;
      if (!earned) return rungs[i];
    }
    return rungs.last;
  }

  bool contains(String exerciseId) => rungs.contains(exerciseId);
}

/// How far past the prescription the last sets landed.
///
/// Returned as a ratio so it means the same thing for a 12-minute run and a
/// 5-rep set. Sets with no logged amount are skipped rather than counted as
/// exact — "done" without a number says nothing about the margin.
double? marginOf(Iterable<({int target, int? actual})> sets) {
  final counted = [
    for (final s in sets)
      if (s.actual != null && s.target > 0) s.actual! / s.target,
  ];
  if (counted.isEmpty) return null;
  return counted.reduce((a, b) => a + b) / counted.length;
}
