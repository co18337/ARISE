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
  /// Nullable because a default parameter value must be a compile-time
  /// constant, and palette colours are runtime getters now.
  final List<Color>? colors;

  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final List<Color> colors =
        this.colors ?? [AppColors.accentPurple, AppColors.primary];

    return Opacity(
      // A disabled primary button should still be legible — it's telling you
      // there is nothing left to claim, which is information.
      opacity: enabled ? 1 : 0.4,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          gradient: LinearGradient(colors: colors),
          shape: AppShapes.control(),
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
          shape: AppShapes.control(),
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
                  // Flexible + ellipsis: labels here are uppercase with wide
                  // letter-spacing, and a long one ("Forget cached answers")
                  // overflowed the row on a 360dp phone.
                  Flexible(
                    child: Text(
                      label.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.panelTitle.copyWith(
                        color: AppColors.background,
                        fontSize: 13,
                      ),
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
