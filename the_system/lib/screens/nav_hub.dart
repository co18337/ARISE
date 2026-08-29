import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../widgets/hud_circle_button.dart';
import '../widgets/hud_overlay_scaffold.dart';

/// The destinations the hub navigates between.
enum AppSection {
  quests('DAILY QUESTS', Icons.checklist_rtl),
  status('STATUS', Icons.insights),
  weeklyReport('REPORT', Icons.assessment_outlined),
  activityLog('LOG', Icons.forum_outlined),
  backup('BACKUP', Icons.save_alt);

  final String label;
  final IconData icon;

  const AppSection(this.label, this.icon);
}

/// A radial menu of glowing circular buttons — the only way between screens.
///
/// No bottom tab bar: permanent chrome would eat height on every screen for
/// navigation used a few times a day. A hub costs one tap and gives the
/// destinations room to breathe.
///
/// Buttons are laid out on a real circle rather than a grid, and spring
/// outward from the centre when the hub opens.
class NavHub extends StatelessWidget {
  final AppSection current;

  const NavHub({super.key, required this.current});

  static const double _radius = 88;
  static const double _button = 64;

  @override
  Widget build(BuildContext context) {
    const sections = AppSection.values;
    const boxSize = (_radius * 2) + _button + 30;

    return HudOverlayScaffold(
      title: 'NAV',
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutBack,
          builder: (context, t, _) => SizedBox(
            width: boxSize,
            height: boxSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const _HubCore(),
                for (var i = 0; i < sections.length; i++)
                  _radialButton(context, sections[i], i, sections.length, t),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _radialButton(
    BuildContext context,
    AppSection section,
    int index,
    int count,
    double t,
  ) {
    // Start at -90° so the first button sits at the top, then step evenly
    // around the circle.
    final angle = -math.pi / 2 + (2 * math.pi * index / count);
    final r = _radius * t;

    return Transform.translate(
      offset: Offset(r * math.cos(angle), r * math.sin(angle)),
      child: Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: HudCircleButton(
          icon: section.icon,
          label: section.label,
          size: _button,
          // The section you're already on is highlighted rather than disabled,
          // so the hub always shows where you are as well as where you can go.
          accent: section == current
              ? AppColors.accentGold
              : AppColors.primary,
          onTap: () => Navigator.of(context).pop(section),
        ),
      ),
    );
  }
}

/// A small glowing core at the centre of the radial menu, purely to anchor
/// the layout so the ring doesn't read as floating.
class _HubCore extends StatelessWidget {
  const _HubCore();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.7),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.6),
            blurRadius: 18,
          ),
        ],
      ),
    );
  }
}
