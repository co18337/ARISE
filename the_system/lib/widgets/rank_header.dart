import 'package:flutter/material.dart';

import '../data/repositories/player_repository.dart';
import '../game/game.dart';
import '../theme/theme.dart';
import 'animated_counter.dart';
import 'stat_bar.dart';

/// The persistent status strip pinned to the top of every screen.
///
/// Hunter name, Rank (E→S), Level, and the XP bar toward the next level.
/// Keeping it on every screen — not just the home screen — means progression
/// is always in view, so the reason for doing any of this is never more than a
/// glance away.
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
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        border: const Border(
          bottom: BorderSide(color: AppColors.primaryDim, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _RankChip(rank: rank),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('HUNTER', style: AppTextStyles.hudLabel.copyWith(fontSize: 9)),
                    Text(
                      player?.hunterName ?? '—',
                      style: AppTextStyles.hunterName.copyWith(fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('LEVEL', style: AppTextStyles.hudLabel.copyWith(fontSize: 9)),
                  AnimatedCounter(
                    value: level,
                    style: AppTextStyles.counter.copyWith(
                      fontSize: 20,
                      color: rank.color,
                    ),
                  ),
                ],
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ],
            ],
          ),
          const SizedBox(height: 8),
          StatBar(
            label: 'XP',
            value: progress?.xpIntoLevel ?? 0,
            max: progress?.xpForLevel ?? 1,
            color: AppColors.accentPurple,
            height: 6,
            showHeader: false,
          ),
        ],
      ),
    );
  }
}

/// The rank letter in a notched chip, coloured by tier.
class _RankChip extends StatelessWidget {
  final Rank rank;

  const _RankChip({required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: rank.color.withValues(alpha: 0.12),
        shape: ChamferBorder(
          cut: 8,
          side: BorderSide(color: rank.color, width: 1.2),
        ),
        shadows: [
          BoxShadow(
            color: rank.color.withValues(alpha: 0.35),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        rank.label,
        style: AppTextStyles.hunterName.copyWith(
          color: rank.color,
          fontSize: 16,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
