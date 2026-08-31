import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// A circular icon button with a thin glowing ring and a label beneath.
///
/// The OPS menu is built entirely from these, and the quest-detail actions
/// will be too. Modelled on Ingress's action buttons (Hack / Link / Charge),
/// which is why it's a ring rather than a filled button — the dark centre
/// keeps the backdrop visible through the HUD.
class HudCircleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? accent;
  final double size;

  /// Shows a small dot on the ring — "there is something unseen in here".
  final bool showBadge;

  const HudCircleButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.accent,
    this.size = 62,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    // A disabled button stays visible but clearly inert, so the menu shows
    // what exists in the app even before a screen is built.
    final bool enabled = onTap != null;
    final Color color =
        enabled ? (accent ?? AppColors.primary) : AppColors.textDim;

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: size,
                    height: size,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceRaised.withValues(alpha: 0.75),
                      border: Border.all(
                        color: color.withValues(alpha: enabled ? 0.75 : 0.35),
                        width: 1.2,
                      ),
                      boxShadow: [
                        if (enabled)
                          BoxShadow(
                            color: color.withValues(alpha: 0.28),
                            blurRadius: 14,
                            spreadRadius: -2,
                          ),
                      ],
                    ),
                    child: Icon(icon, color: color, size: size * 0.42),
                  ),
                  if (showBadge)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.accentPurple,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentPurple.withValues(alpha: 0.8),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                label,
                textAlign: TextAlign.center,
                // Two lines: the hub gives each destination a fixed-width
                // cell, and a long label has to wrap inside it rather than
                // overlap the button next to it.
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.hudLabel.copyWith(
                  color: color,
                  fontSize: 10,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
