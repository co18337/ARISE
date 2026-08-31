import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Cycles DARK → WARM → AUTO, pinned to the top-right of every screen.
///
/// A cycle rather than a switch: there are three states, and a two-position
/// switch cannot express "follow the phone". One tap, always visible, and the
/// label says which one is active rather than making you guess from an icon.
class ThemeToggleButton extends StatelessWidget {
  final AppThemeMode mode;
  final ValueChanged<AppThemeMode> onChanged;

  const ThemeToggleButton({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  static const Map<AppThemeMode, IconData> _icons = {
    AppThemeMode.dark: Icons.dark_mode_outlined,
    AppThemeMode.warm: Icons.light_mode_outlined,
    AppThemeMode.auto: Icons.brightness_auto_outlined,
  };

  AppThemeMode get _next {
    final values = AppThemeMode.values;
    return values[(mode.index + 1) % values.length];
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Theme: ${mode.label}. Tap to switch.',
      child: Tooltip(
        message: 'Theme: ${mode.label}',
        child: Material(
          color: Colors.transparent,
          shape: AppShapes.pill(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => onChanged(_next),
            child: Container(
              padding: const EdgeInsets.fromLTRB(9, 6, 11, 6),
              decoration: ShapeDecoration(
                color: AppColors.surfaceRaised.withValues(alpha: 0.75),
                shape: AppShapes.pill(
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_icons[mode], size: 14, color: AppColors.primary),
                  const SizedBox(width: 5),
                  Text(
                    mode.label,
                    style: AppTextStyles.hudLabel.copyWith(
                      fontSize: 9,
                      color: AppColors.primary,
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
