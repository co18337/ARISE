import '../models/models.dart';

/// Which regions of the body the programme should favour, read from the most
/// recent body-composition scan.
///
/// This is the piece that makes the programme YOURS rather than a generic
/// beginner plan. The MC-780 rates every segment against its reference
/// population on a -4..+4 scale, and one line of that report is worth more
/// than any amount of guessing from photographs: on 7 Aug 2026 the trunk was
/// the only segment rated below average for muscle (-1) while all four limbs
/// were average (0). So the trunk gets the extra volume, and the limbs get
/// maintenance.
///
/// Scope, deliberately narrow: this decides WHICH REGIONS GET MORE WORK. It
/// does not interpret the scan medically, set a target body-fat percentage, or
/// say anything about what a rating means for your health. That reading stays
/// with the doctor. The only claim made here is a programming one.
///
/// Pure — no database, no Flutter. The repository reads the scan and hands the
/// ratings in.
class BodyEmphasis {
  /// Regions to give extra volume, strongest need first.
  final List<BodyRegion> priority;

  /// Regions that only need holding.
  final List<BodyRegion> maintain;

  /// One line for the session card explaining why, or null when there is no
  /// scan to base it on.
  final String? reason;

  const BodyEmphasis({
    this.priority = const [],
    this.maintain = const [],
    this.reason,
  });

  /// No scan on record. Everything is trained evenly, which is the right
  /// default and NOT a claim that everything is balanced.
  static const BodyEmphasis none = BodyEmphasis();

  bool get hasPriority => priority.isNotEmpty;

  bool isPriority(BodyRegion region) => priority.contains(region);

  /// How many extra sets a movement in [region] earns, 0 or 1.
  ///
  /// One. Not two, and never a multiplier: the emphasis nudges the session,
  /// it does not rewrite it. Doubling the volume of a weak area is how a weak
  /// area becomes an injured one, and the phase plan already decides what the
  /// session IS.
  int extraSetsFor(BodyRegion region) => isPriority(region) ? 1 : 0;

  /// Reads a scan's segment ratings.
  ///
  /// [muscleRatings] and [fatRatings] are the report's own -4..+4 numbers,
  /// keyed by segment. Missing entries are simply not considered — a bathroom
  /// scale reports no segments, and the answer to that is [none], not a guess.
  factory BodyEmphasis.fromRatings({
    required Map<BodySegment, int> muscleRatings,
    Map<BodySegment, int> fatRatings = const {},
  }) {
    if (muscleRatings.isEmpty) return none;

    // Below average for muscle is the actionable signal. Fat distribution says
    // where fat sits, but fat is lost systemically — you cannot train it off a
    // region, and pretending otherwise is the oldest bad advice in fitness.
    final weak = <BodySegment>[
      for (final entry in muscleRatings.entries)
        if (entry.value < 0) entry.key,
    ]..sort((a, b) => muscleRatings[a]!.compareTo(muscleRatings[b]!));

    if (weak.isEmpty) {
      return BodyEmphasis(
        maintain: BodyRegion.values,
        reason: 'Every segment rates average or better for muscle. Holding '
            'what you have while the fat comes off.',
      );
    }

    final priority = <BodyRegion>[];
    for (final segment in weak) {
      final region = regionOf(segment);
      if (!priority.contains(region)) priority.add(region);
    }

    final maintain = [
      for (final region in BodyRegion.values)
        if (!priority.contains(region) && region != BodyRegion.wholeBody)
          region,
    ];

    final names = weak.map((s) => s.label.toLowerCase()).join(' and ');
    return BodyEmphasis(
      priority: priority,
      maintain: maintain,
      reason: 'Your last scan rates $names below average for muscle while the '
          'rest are average. That is where the extra work goes.',
    );
  }

  /// Which region of the exercise library a scan segment belongs to.
  static BodyRegion regionOf(BodySegment segment) => switch (segment) {
    BodySegment.trunk => BodyRegion.trunk,
    BodySegment.rightArm || BodySegment.leftArm => BodyRegion.upperBody,
    BodySegment.rightLeg || BodySegment.leftLeg => BodyRegion.lowerBody,
  };
}
