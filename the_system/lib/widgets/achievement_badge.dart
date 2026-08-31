import 'package:flutter/material.dart';

import '../game/game.dart';
import '../theme/theme.dart';
import 'badge_image.dart';

/// The colour each tier is drawn in for its label, ring and glow.
///
/// Taken from the artwork itself so the text under a badge matches the metal
/// above it.
extension AchievementTierColor on AchievementTier {
  Color get color => switch (this) {
    AchievementTier.bronze => const Color(0xFFC98A4B),
    AchievementTier.silver => const Color(0xFFC3D0DE),
    AchievementTier.gold => AppColors.accentGold,
    AchievementTier.platinum => const Color(0xFF9BE8FF),
  };
}

/// One medal: the tier already earned, and how far along the next one is.
///
/// Modelled on the way Ingress and Pokémon Go do medals — the same badge
/// earned again and again at rising thresholds, so there is always a next one
/// in sight. That "always something in progress" is the whole mechanic; a
/// badge that is simply locked or unlocked stops mattering the moment it lands.
class AchievementBadge extends StatelessWidget {
  final AchievementProgress progress;
  final double size;
  final VoidCallback? onTap;

  const AchievementBadge({
    super.key,
    required this.progress,
    this.size = 74,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // A locked medal shows the tier it is WORKING TOWARD, greyed out. Showing
    // nothing would hide what is on offer, which is the point of a medal case.
    final displayTier =
        progress.tier ?? progress.nextTier ?? AchievementTier.bronze;
    final earned = progress.earned;
    final color = earned ? displayTier.color : AppColors.textDim;

    return Semantics(
      label: '${progress.id.label}, '
          '${earned ? '${displayTier.label} tier' : 'not yet earned'}',
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.rowRadius,
        child: SizedBox(
          width: size + 22,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BadgeImage(
                asset: displayTier.badgeAsset,
                size: size,
                opacity: earned ? 1.0 : 0.32,
                glow: earned ? displayTier.color : null,
              ),
              const SizedBox(height: 6),
              Text(
                progress.id.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.hudLabel.copyWith(
                  color: color,
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 5),
              // Progress toward the NEXT tier, measured from the one already
              // held — so a nearly full bar genuinely means nearly there.
              StatBarMini(fraction: progress.fraction, color: color),
              const SizedBox(height: 4),
              Text(
                progress.isMaxed
                    ? 'MAX'
                    : '${progress.value} / ${progress.nextThreshold}',
                style: AppTextStyles.counter.copyWith(
                  fontSize: 10,
                  color: progress.isMaxed
                      ? AppColors.accentGold
                      : AppColors.textDim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A hairline progress bar, sized for sitting under a badge.
class StatBarMini extends StatelessWidget {
  final double fraction;
  final Color color;

  const StatBarMini({super.key, required this.fraction, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        height: 4,
        child: Stack(
          children: [
            Container(color: AppColors.surfaceRaised),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction.clamp(0.0, 1.0),
              child: Container(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
