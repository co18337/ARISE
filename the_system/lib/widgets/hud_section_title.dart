import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// A centred heading flanked by hairlines — the System announcing a window.
///
/// Shared by the Today screen and every overlay so headings look identical
/// wherever they appear.
class HudSectionTitle extends StatelessWidget {
  final String text;
  final Color? accent;

  // Nullable rather than defaulted: a default parameter value must be a
  // compile-time constant, and palette colours are now runtime getters so the
  // theme can be swapped. Resolved in build() instead.
  const HudSectionTitle(this.text, {super.key, this.accent});

  @override
  Widget build(BuildContext context) {
    final Color accent = this.accent ?? AppColors.primary;
    final Widget rule = Expanded(
      child: Container(height: 1, color: accent.withValues(alpha: 0.3)),
    );

    return Row(
      children: [
        rule,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            text,
            style: AppTextStyles.display.copyWith(
              fontSize: 16,
              color: accent == AppColors.primary ? AppColors.textPrimary : accent,
              // A soft glow behind the text reads as emitted light, which is
              // what makes it feel projected rather than printed.
              shadows: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.55),
                  blurRadius: 14,
                ),
              ],
            ),
          ),
        ),
        rule,
      ],
    );
  }
}
