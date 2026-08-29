import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// The primary action button — violet→cyan gradient inside a notched frame.
///
/// Deliberately the loudest control in the app, so it stays rare: one per
/// screen at most, reserved for the action that actually completes something
/// (claiming a day, acknowledging a level-up).
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Gradient endpoints. Defaults to violet→cyan; pass gold for reward moments.
  final List<Color> colors;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.colors = const [AppColors.accentPurple, AppColors.primary],
  });

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;

    return Opacity(
      // A disabled primary button should still be legible — it's telling you
      // there is nothing left to claim, which is information.
      opacity: enabled ? 1 : 0.4,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          gradient: LinearGradient(colors: colors),
          shape: const ChamferBorder(cut: 10),
          shadows: [
            if (enabled)
              BoxShadow(
                color: colors.last.withValues(alpha: 0.35),
                blurRadius: 16,
                spreadRadius: -3,
              ),
          ],
        ),
        // Material + InkWell inside the decoration so the ripple is clipped to
        // the chamfered shape rather than a rectangle.
        child: Material(
          color: Colors.transparent,
          shape: const ChamferBorder(cut: 10),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: AppColors.background),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label.toUpperCase(),
                    style: AppTextStyles.panelTitle.copyWith(
                      color: AppColors.background,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
