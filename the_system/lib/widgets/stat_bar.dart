import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// A labelled, glowing progress bar.
///
/// Used for today's XP now; in Phase 4 the STATUS screen will stack four of
/// these for STR / STA / DIS / REC, which is why the label, colour and
/// value/max are all parameters rather than hardcoded.
class StatBar extends StatelessWidget {
  /// Short caps label, e.g. "DAILY XP" or "STR".
  final String label;

  final int value;
  final int max;
  final Color? color;

  /// Optional text on the right. Defaults to "value / max".
  final String? trailingText;

  final double height;

  /// Set false when the caller already shows the label and value itself, so
  /// the bar renders as just the track (used by the STATUS stat rows).
  final bool showHeader;

  /// Threshold values drawn as ticks along the track, e.g. `[8, 24, 56]`.
  /// Milestones you're working toward are much more motivating when they're
  /// visible on the bar rather than implied by a number.
  final List<int> tiers;

  /// Splits the bar into "earned" (gold) and "still to earn" (green) instead
  /// of one flat colour. Reserved for goal bars, not routine progress.
  final bool showEarnedRemaining;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.max,
    this.color,
    this.trailingText,
    this.height = 8,
    this.showHeader = true,
    this.tiers = const [],
    this.showEarnedRemaining = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color barColor = color ?? AppColors.primary;
    // Guard against divide-by-zero on a day with no scheduled quests.
    final double fraction = max <= 0 ? 0 : (value / max).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showHeader) ...[
          Row(
            children: [
              // Expanded + ellipsis: HUD labels are uppercase with wide
              // letter-spacing, so a slightly long one overflows a phone-width
              // row surprisingly easily. The value on the right must never be
              // the thing that gets pushed off.
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: AppTextStyles.hudLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(trailingText ?? '$value / $max', style: AppTextStyles.readout),
            ],
          ),
          const SizedBox(height: 6),
        ],
        // TweenAnimationBuilder animates whenever `fraction` changes, without
        // needing an AnimationController — so the bar slides up smoothly each
        // time a quest is completed and the parent rebuilds.
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: fraction),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (context, animatedFraction, _) => _BarTrack(
            fraction: animatedFraction,
            color: showEarnedRemaining ? AppColors.accentGold : barColor,
            trackColor: showEarnedRemaining
                ? AppColors.remaining.withValues(alpha: 0.22)
                : AppColors.surfaceRaised,
            height: height,
            tierFractions: [
              for (final t in tiers)
                if (max > 0 && t > 0 && t < max) t / max,
            ],
          ),
        ),
        if (tiers.isNotEmpty) ...[
          const SizedBox(height: 3),
          _TierLabels(tiers: tiers, max: max),
        ],
      ],
    );
  }
}

/// Threshold values printed under the bar, positioned at their tick.
class _TierLabels extends StatelessWidget {
  final List<int> tiers;
  final int max;

  const _TierLabels({required this.tiers, required this.max});

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder because each label has to sit at its own fraction of the
    // track width, which isn't known until layout.
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: 12,
          child: Stack(
            children: [
              for (final t in tiers)
                if (max > 0 && t > 0 && t <= max)
                  Positioned(
                    left: (width * (t / max) - 14).clamp(0.0, width - 28),
                    child: SizedBox(
                      width: 28,
                      child: Text(
                        '$t',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.counter.copyWith(
                          fontSize: 9,
                          color: AppColors.textDim,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}

class _BarTrack extends StatelessWidget {
  final double fraction;
  final Color color;
  final Color trackColor;
  final double height;
  final List<double> tierFractions;

  const _BarTrack({
    required this.fraction,
    required this.color,
    required this.trackColor,
    required this.height,
    this.tierFractions = const [],
  });

  @override
  Widget build(BuildContext context) {
    // Fully round ends. Square-ended bars looked deliberate next to cut
    // corners; next to rounded cards they just look unfinished.
    final radius = BorderRadius.circular(height);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: radius,
        border: Border.all(color: color.withValues(alpha: 0.30), width: 1),
      ),
      // Clips the fill and the tier ticks to the rounded track, so the fill
      // can stay a plain rectangle and still end in a round cap.
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // FractionallySizedBox fills a proportion of the parent's width,
          // which avoids measuring the track ourselves with a LayoutBuilder.
          //
          // heightFactor: 1 is load-bearing, not decoration. A Stack lays its
          // non-positioned children out with LOOSE constraints, so without it
          // the child is free to be as short as it likes — and a DecoratedBox
          // with no child of its own takes the smallest size allowed, which is
          // zero height. The fill was invisible in every bar in the app: a
          // 4/4 session showed an empty track. The tick marks below never had
          // the bug because Align expands to fill bounded constraints where
          // DecoratedBox does not.
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: fraction,
            heightFactor: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                // Gradient brightens toward the leading edge so the bar looks
                // lit from within rather than like a flat block of colour.
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.55), color],
                ),
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.65), blurRadius: 8),
                ],
              ),
            ),
          ),
          // Tier ticks sit on top of the fill so a passed threshold still
          // reads as a marker rather than disappearing under the bar.
          for (final f in tierFractions)
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: f,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 1.5,
                  color: AppColors.background.withValues(alpha: 0.85),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
