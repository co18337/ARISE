import 'package:flutter/material.dart';

import '../data/repositories/player_repository.dart';
import '../game/game.dart';
import '../theme/theme.dart';
import 'rank_emblem.dart';
import 'stat_bar.dart';

/// The persistent status strip pinned to the top of every screen.
///
/// Rank crest, Hunter name, Level, and the XP bar toward the next level.
/// Keeping it on every screen — not just the home screen — means progression
/// is always in view, so the reason for doing any of this is never more than a
/// glance away.
///
/// Laid out as one block rather than a title row plus a full-width bar
/// underneath: the crest anchors the left edge, and the level line reads
/// straight across, which is what makes it feel like an identity card instead
/// of a toolbar.
class RankHeader extends StatelessWidget {
  final PlayerSnapshot? player;

  /// Optional trailing widget, e.g. a countdown on the quests screen.
  final Widget? trailing;

  const RankHeader({super.key, required this.player, this.trailing});

  @override
  Widget build(BuildContext context) {
    final rank = player?.rank ?? Rank.e;
    final level = player?.level ?? 1;
    final progress = player?.progress;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primaryDim.withValues(alpha: 0.55),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RankEmblem(rank: rank, size: 38),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'HUNTER',
                      style: AppTextStyles.hudLabel.copyWith(fontSize: 9),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '·',
                      style: AppTextStyles.hudLabel.copyWith(fontSize: 9),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${rank.label} RANK',
                      style: AppTextStyles.hudLabel.copyWith(
                        fontSize: 9,
                        color: rank.color,
                      ),
                    ),
                  ],
                ),
                Text(
                  player?.hunterName ?? '—',
                  style: AppTextStyles.hunterName.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'LEVEL $level',
                      style: AppTextStyles.hudLabel.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Expanded so the bar takes whatever is left after the
                    // two labels, at any screen width.
                    Expanded(
                      child: StatBar(
                        label: 'XP',
                        value: progress?.xpIntoLevel ?? 0,
                        max: progress?.xpForLevel ?? 1,
                        color: AppColors.accentPurple,
                        height: 5,
                        showHeader: false,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Flexible + ellipsis: the header now also carries the
                    // theme switch, so this row's spare width is thin. It must
                    // shrink rather than overflow on a 360dp phone.
                    Flexible(
                      child: Text(
                        '${progress?.xpIntoLevel ?? 0} / ${progress?.xpForLevel ?? 0}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.counter.copyWith(
                          fontSize: 11,
                          letterSpacing: 0.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );
  }
}
