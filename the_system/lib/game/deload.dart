/// Why a week was backed off.
enum DeloadReason {
  /// Every sixth week, whether or not anything is wrong.
  ///
  /// The one that actually keeps people training for a year. Waiting for a
  /// stall means the stall arrives, and by then you have already spent the
  /// weeks that produced it.
  planned('PLANNED', 'Sixth week. Volume down, weight the same.'),

  /// Two sessions in a row left unfinished.
  ///
  /// Not a verdict on you — an unfinished session is the body reporting
  /// something, and twice running is worth listening to.
  stalled('STALLED', 'Two sessions unfinished. Backing off before it breaks.');

  final String label;
  final String explanation;

  const DeloadReason(this.label, this.explanation);
}

/// A week of reduced volume.
class Deload {
  final DeloadReason reason;

  /// Sets are multiplied by this. 0.6 — a 40% cut.
  ///
  /// VOLUME down, INTENSITY held: fewer sets at the same weight and the same
  /// reps. Cutting the weight instead would detrain the very thing the block
  /// built, which is the classic way to make a deload cost you something.
  static const double volumeFactor = 0.6;

  const Deload(this.reason);
}

/// Whether this week should be backed off.
///
/// Nobody progresses in a straight line for twelve months. Without a planned
/// retreat, a programme that works in month two is what breaks somebody in
/// month four — and the break arrives as an injury or as quitting, not as a
/// number on a chart.
///
/// Pure: given the week and what the last few sessions looked like, it decides.
class DeloadRule {
  /// Weeks of normal training between planned deloads.
  final int everyWeeks;

  /// Consecutive unfinished sessions that force an early one.
  final int stallThreshold;

  const DeloadRule({this.everyWeeks = 6, this.stallThreshold = 2});

  /// The deload for [week], or null for a normal week.
  ///
  /// [recentUnfinished] counts sessions from most recent backwards that were
  /// issued and not completed in full. [weeksSinceLastDeload] is null when
  /// there has never been one.
  Deload? forWeek({
    required int week,
    required int recentUnfinished,
    int? weeksSinceLastDeload,
  }) {
    // A stall outranks the calendar: the body has already said something.
    if (recentUnfinished >= stallThreshold) {
      // Unless one just happened — otherwise a rough patch after a deload
      // triggers a second, and a third, and the programme quietly stops.
      if ((weeksSinceLastDeload ?? everyWeeks) >= 2) {
        return const Deload(DeloadReason.stalled);
      }
      return null;
    }

    // Never in the first block: there is nothing to recover from yet, and a
    // beginner losing volume in week one loses the habit instead.
    if (week < everyWeeks) return null;

    final since = weeksSinceLastDeload ?? week;
    return since >= everyWeeks ? const Deload(DeloadReason.planned) : null;
  }

  /// Sets after the cut, never below one.
  ///
  /// A deload that removes a movement entirely is a rest day wearing a
  /// disguise; the point is to keep the pattern and lose the fatigue.
  static int setsFor(int sets, Deload? deload) {
    if (deload == null) return sets;
    final cut = (sets * Deload.volumeFactor).round();
    return cut < 1 ? 1 : cut;
  }
}
