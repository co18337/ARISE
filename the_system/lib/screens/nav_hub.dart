import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../widgets/hud_circle_button.dart';
import '../widgets/hud_overlay_scaffold.dart';

/// The destinations the hub navigates between.
enum AppSection {
  quests('DAILY QUESTS', Icons.checklist_rtl),
  training('TRAINING', Icons.fitness_center),
  nutrition('NUTRITION', Icons.restaurant_menu),
  status('STATUS', Icons.insights),
  progress('PROGRESS', Icons.show_chart),
  weeklyReport('REPORT', Icons.assessment_outlined),
  activityLog('LOG', Icons.forum_outlined),
  alerts('ALERTS', Icons.notifications_active_outlined),
  memory('MEMORY', Icons.psychology_outlined),
  backup('BACKUP', Icons.save_alt),

  /// DEV ONLY — remove with BadgeGalleryScreen once badge picks are settled.
  badges('BADGES', Icons.military_tech_outlined);

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

  static const double _button = 58;

  /// Width budget for one destination — the ring, and the label under it.
  /// Labels are what actually collide: "DAILY QUESTS" is far wider than the
  /// button it sits beneath.
  static const double _cell = 86;

  /// Clear space between neighbouring cells.
  ///
  /// Not cosmetic. Sizing the ring so cells exactly touch leaves adjacent tap
  /// targets sharing an edge, and a Stack hit-tests the LAST child painted at
  /// that point — so a tap on one destination opened the one after it. That
  /// shipped at nine destinations and sent TRAINING to STATUS.
  static const double _gap = 18;

  /// Radius that keeps adjacent cells from overlapping.
  ///
  /// The chord between two neighbours on a circle of radius r is
  /// 2r·sin(pi/n), so the radius has to GROW with the number of destinations.
  /// It was a constant 88 while there were four; at seven that put two
  /// buttons on top of each other and taps landed on the wrong screen.
  static double _radiusFor(int count) {
    if (count < 2) return 0;
    final needed = (_cell + _gap) / (2 * math.sin(math.pi / count));
    return needed < 88 ? 88 : needed;
  }

  @override
  Widget build(BuildContext context) {
    const sections = AppSection.values;
    final radius = _radiusFor(sections.length);
    final boxSize = (radius * 2) + _cell + 16;

    return HudOverlayScaffold(
      title: 'NAV',
      child: Center(
        // The ring grows with the number of destinations, so on a narrow
        // phone it can outgrow the screen. Scaling down beats clipping, and
        // beats abandoning the radial layout for a grid.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.all(8),
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
                    _HubCore(),
                    for (var i = 0; i < sections.length; i++)
                      _radialButton(
                        context,
                        sections[i],
                        i,
                        sections.length,
                        t,
                        radius,
                      ),
                  ],
                ),
              ),
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
    double radius,
  ) {
    // Start at -90° so the first button sits at the top, then step evenly
    // around the circle.
    final angle = -math.pi / 2 + (2 * math.pi * index / count);
    final r = radius * t;

    return Transform.translate(
      offset: Offset(r * math.cos(angle), r * math.sin(angle)),
      child: Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: SizedBox(
          // Fixed cell width so a long label cannot spill into its neighbour.
          width: _cell,
          child: HudCircleButton(
            icon: section.icon,
            label: section.label,
            size: _button,
            // The section you're already on is highlighted rather than
            // disabled, so the hub always shows where you are as well as
            // where you can go.
            accent: section == current
                ? AppColors.accentGold
                : AppColors.primary,
            onTap: () => Navigator.of(context).pop(section),
          ),
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
