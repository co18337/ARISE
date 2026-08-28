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
  final Color color;

  /// Optional text on the right. Defaults to "value / max".
  final String? trailingText;

  final double height;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.max,
    this.color = AppColors.primary,
    this.trailingText,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    // Guard against divide-by-zero on a day with no scheduled quests.
    final double fraction = max <= 0 ? 0 : (value / max).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label.toUpperCase(), style: AppTextStyles.hudLabel),
            Text(trailingText ?? '$value / $max', style: AppTextStyles.readout),
          ],
        ),
        const SizedBox(height: 6),
        // TweenAnimationBuilder animates whenever `fraction` changes, without
        // needing an AnimationController — so the bar slides up smoothly each
        // time a quest is completed and the parent rebuilds.
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: fraction),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (context, animatedFraction, _) => _BarTrack(
            fraction: animatedFraction,
            color: color,
            height: height,
          ),
        ),
      ],
    );
  }
}

class _BarTrack extends StatelessWidget {
  final double fraction;
  final Color color;
  final double height;

  const _BarTrack({required this.fraction, required this.color, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border.all(color: color.withValues(alpha: 0.30), width: 1),
      ),
      // FractionallySizedBox fills a proportion of the parent's width, which
      // avoids having to measure the track ourselves with a LayoutBuilder.
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: fraction,
        child: DecoratedBox(
          decoration: BoxDecoration(
            // Gradient brightens toward the leading edge so the bar looks lit
            // from within rather than like a flat block of colour.
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.55), color],
            ),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.65), blurRadius: 8),
            ],
          ),
        ),
      ),
    );
  }
}
