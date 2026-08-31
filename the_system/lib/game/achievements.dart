/// Tiered achievements, in the style Ingress and Pokémon Go use: one medal per
/// category, earned again and again at rising thresholds.
///
/// Pure, like the rest of lib/game — thresholds in, tiers out. Nothing here
/// touches the database, so "does 20 days give gold" is a one-line test.
///
/// Nothing is stored. A tier is a function of totals the player already has,
/// so a medal can never disagree with the record that earned it — the same
/// rule levels and ranks follow.
library;

import '../models/models.dart';

/// The four steps of every medal.
enum AchievementTier {
  bronze('BRONZE'),
  silver('SILVER'),
  gold('GOLD'),
  platinum('PLATINUM');

  final String label;

  const AchievementTier(this.label);

  /// Artwork for this tier, in assets/badges.
  String get badgeAsset => 'tier_$name';

  AchievementTier? get next {
    final i = index + 1;
    return i < AchievementTier.values.length
        ? AchievementTier.values[i]
        : null;
  }
}

/// Everything a medal can be earned against.
///
/// Deliberately a small snapshot rather than a database handle: it is what
/// makes the engine testable and what lets the repository evaluate the same
/// rules against the totals BEFORE a write, to notice a newly earned tier.
class AchievementMetrics {
  final int longestStreak;
  final int perfectDays;
  final int questsCleared;
  final int totalXp;
  final Map<StatType, int> statXp;

  const AchievementMetrics({
    this.longestStreak = 0,
    this.perfectDays = 0,
    this.questsCleared = 0,
    this.totalXp = 0,
    this.statXp = const {},
  });

  static const AchievementMetrics empty = AchievementMetrics();

  int statOf(StatType stat) => statXp[stat] ?? 0;
}

/// The medals themselves.
///
/// Thresholds rise steeply on purpose. A medal that arrives every week stops
/// meaning anything; the gap between gold and platinum should be a season's
/// work, not a fortnight's.
enum AchievementId {
  resolve(
    label: 'RESOLVE',
    description: 'Longest streak',
    unit: 'days',
    thresholds: [3, 10, 20, 50],
  ),
  flawless(
    label: 'FLAWLESS',
    description: 'Days with every quest cleared',
    unit: 'days',
    thresholds: [1, 5, 15, 40],
  ),
  diligence(
    label: 'DILIGENCE',
    description: 'Quests cleared, all time',
    unit: 'quests',
    thresholds: [50, 250, 1000, 3000],
  ),
  ascent(
    label: 'ASCENT',
    description: 'Total XP earned',
    unit: 'XP',
    thresholds: [500, 2500, 10000, 30000],
  ),
  ironwill(
    label: 'IRON WILL',
    description: 'Strength XP earned',
    unit: 'STR',
    thresholds: [100, 500, 2000, 6000],
  ),
  vitality(
    label: 'VITALITY',
    description: 'Recovery XP earned',
    unit: 'REC',
    thresholds: [100, 500, 2000, 6000],
  );

  final String label;
  final String description;
  final String unit;

  /// One threshold per tier, in [AchievementTier] order.
  final List<int> thresholds;

  const AchievementId({
    required this.label,
    required this.description,
    required this.unit,
    required this.thresholds,
  });

  /// The metric this medal measures.
  int valueFrom(AchievementMetrics m) => switch (this) {
    AchievementId.resolve => m.longestStreak,
    AchievementId.flawless => m.perfectDays,
    AchievementId.diligence => m.questsCleared,
    AchievementId.ascent => m.totalXp,
    AchievementId.ironwill => m.statOf(StatType.str),
    AchievementId.vitality => m.statOf(StatType.rec),
  };
}

/// Where one medal stands right now.
class AchievementProgress {
  final AchievementId id;

  /// Highest tier earned, or null if none yet.
  final AchievementTier? tier;

  /// The current value of the measured metric.
  final int value;

  /// What the next tier costs, or null once platinum is held.
  final int? nextThreshold;

  const AchievementProgress({
    required this.id,
    required this.tier,
    required this.value,
    required this.nextThreshold,
  });

  bool get earned => tier != null;
  bool get isMaxed => nextThreshold == null;

  /// Progress toward the NEXT tier, 0..1. Measured from the tier already held
  /// rather than from zero, so a bar that is nearly full genuinely means
  /// nearly there.
  double get fraction {
    final next = nextThreshold;
    if (next == null) return 1;
    final floor = tier == null ? 0 : id.thresholds[tier!.index];
    final span = next - floor;
    if (span <= 0) return 1;
    return ((value - floor) / span).clamp(0.0, 1.0);
  }

  /// The tier this progress is working toward, or null once maxed.
  AchievementTier? get nextTier =>
      tier == null ? AchievementTier.bronze : tier!.next;
}

/// The highest tier [value] has reached for [id], or null for none.
AchievementTier? tierFor(AchievementId id, int value) {
  AchievementTier? earned;
  for (final tier in AchievementTier.values) {
    if (value >= id.thresholds[tier.index]) {
      earned = tier;
    } else {
      break; // thresholds ascend, so the first miss ends it
    }
  }
  return earned;
}

/// Every medal's standing, in declaration order.
List<AchievementProgress> evaluateAchievements(AchievementMetrics metrics) {
  return [
    for (final id in AchievementId.values)
      () {
        final value = id.valueFrom(metrics);
        final tier = tierFor(id, value);
        final next = tier == null
            ? AchievementTier.bronze
            : tier.next;
        return AchievementProgress(
          id: id,
          tier: tier,
          value: value,
          nextThreshold: next == null ? null : id.thresholds[next.index],
        );
      }(),
  ];
}

/// Tiers newly reached going from [before] to [after].
///
/// Used to write an activity-log entry exactly once per unlock. Comparing two
/// metric snapshots (rather than storing an "acknowledged" flag per medal)
/// keeps the no-stored-derived-state rule intact, and means a recompute that
/// doesn't move the totals announces nothing.
List<({AchievementId id, AchievementTier tier})> newlyEarned({
  required AchievementMetrics before,
  required AchievementMetrics after,
}) {
  final out = <({AchievementId id, AchievementTier tier})>[];

  for (final id in AchievementId.values) {
    final was = tierFor(id, id.valueFrom(before));
    final now = tierFor(id, id.valueFrom(after));
    if (now == null) continue;
    if (was != null && was.index >= now.index) continue;

    // Crossing two thresholds in one write is possible (a big backfill), so
    // every tier gained is announced, not just the top one.
    final from = was == null ? 0 : was.index + 1;
    for (var i = from; i <= now.index; i++) {
      out.add((id: id, tier: AchievementTier.values[i]));
    }
  }

  return out;
}
