/// The moments worth interrupting for.
///
/// Pure: works out what the player has earned but not yet been shown, from
/// what they have earned and what they have acknowledged. No storage, no
/// Flutter — which is what makes "does crossing two levels at once queue two
/// modals" a one-line test.
library;

import 'achievements.dart';
import 'level_curve.dart';
import 'rank.dart';

/// Something the player has earned and not yet seen celebrated.
sealed class RewardEvent {
  const RewardEvent();

  /// Ordered so the biggest moment lands last and is what you remember.
  int get weight;
}

class LevelUpReward extends RewardEvent {
  final int level;

  const LevelUpReward(this.level);

  @override
  int get weight => 1;
}

class RankUpReward extends RewardEvent {
  final Rank rank;

  const RankUpReward(this.rank);

  @override
  int get weight => 3;
}

class MedalReward extends RewardEvent {
  final AchievementId id;
  final AchievementTier tier;

  const MedalReward(this.id, this.tier);

  @override
  int get weight => 2;
}

/// What the player has been shown so far.
class AcknowledgedRewards {
  final int level;
  final Rank rank;

  /// Highest tier already celebrated per medal. Absent means none.
  final Map<AchievementId, AchievementTier> medals;

  const AcknowledgedRewards({
    this.level = 1,
    this.rank = Rank.e,
    this.medals = const {},
  });
}

/// Everything earned since [seen] was recorded.
///
/// Levels are collapsed to the highest reached rather than queued one per
/// level: crossing three levels in a backfill should feel like one big moment,
/// not three identical modals to tap through.
List<RewardEvent> pendingRewards({
  required int totalXp,
  required LevelCurve curve,
  required List<AchievementProgress> achievements,
  required AcknowledgedRewards seen,
}) {
  final events = <RewardEvent>[];

  final level = curve.levelForXp(totalXp);
  if (level > seen.level) events.add(LevelUpReward(level));

  final rank = Rank.forLevel(level);
  if (rank.index > seen.rank.index) events.add(RankUpReward(rank));

  for (final achievement in achievements) {
    final tier = achievement.tier;
    if (tier == null) continue;
    final already = seen.medals[achievement.id];
    if (already != null && already.index >= tier.index) continue;
    events.add(MedalReward(achievement.id, tier));
  }

  // Smallest first, so a session that levels you up AND promotes you ends on
  // the promotion.
  events.sort((a, b) => a.weight.compareTo(b.weight));
  return events;
}

/// Encodes acknowledged medals for storage: `resolve:2,flawless:0`.
///
/// A compact string in one column rather than a table. It is a UI bookkeeping
/// detail, not history — the medals themselves are always derived from totals,
/// and losing this would cost a duplicate modal, nothing more.
String encodeAcknowledgedMedals(Map<AchievementId, AchievementTier> medals) =>
    medals.entries.map((e) => '${e.key.name}:${e.value.index}').join(',');

Map<AchievementId, AchievementTier> decodeAcknowledgedMedals(String? raw) {
  if (raw == null || raw.trim().isEmpty) return const {};

  final out = <AchievementId, AchievementTier>{};
  for (final part in raw.split(',')) {
    final bits = part.split(':');
    if (bits.length != 2) continue;
    final id = AchievementId.values
        .where((a) => a.name == bits[0].trim())
        .firstOrNull;
    final index = int.tryParse(bits[1].trim());
    // Unknown ids and out-of-range tiers are skipped, not thrown on: this
    // string can outlive the build that wrote it.
    if (id == null || index == null) continue;
    if (index < 0 || index >= AchievementTier.values.length) continue;
    out[id] = AchievementTier.values[index];
  }
  return out;
}
