import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/theme.dart';
import 'game_icon.dart';

/// Small pill showing which stat a quest feeds — STR / STA / DIS / REC, each
/// with its own emblem.
///
/// The stat lives on the ROW, not the panel. A category can mix stats (DIET
/// feeds both REC and DIS), so colouring a whole panel by "whichever quest came
/// first" was arbitrary — and it spent red, which this palette reserves for
/// penalties.
///
/// The emblem earns its place: at a glance the icon is read before the three
/// letters are, so the day's shape is legible while scrolling.
class StatChip extends StatelessWidget {
  final StatType stat;

  /// Resolved rows recede; the chip fades with the rest of the row rather than
  /// staying bright and pulling the eye back to finished work.
  final bool dimmed;

  const StatChip({super.key, required this.stat, this.dimmed = false});

  @override
  Widget build(BuildContext context) {
    final Color color = dimmed
        ? stat.color.withValues(alpha: 0.45)
        : stat.color;

    return Container(
      padding: const EdgeInsets.fromLTRB(7, 3, 9, 3),
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: AppShapes.pill(
          side: BorderSide(color: color.withValues(alpha: 0.45), width: 1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GameIcon(stat.iconAsset, color: color, size: 11),
          const SizedBox(width: 5),
          Text(
            stat.label,
            style: AppTextStyles.hudLabel.copyWith(
              color: color,
              fontSize: 10,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
