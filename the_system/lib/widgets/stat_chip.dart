import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/theme.dart';

/// Small tag showing which stat a quest feeds — STR / STA / DIS / REC.
///
/// The stat lives on the ROW, not the panel. A category can mix stats (DIET
/// feeds both REC and DIS), so colouring a whole panel by "whichever quest
/// came first" was arbitrary — and it spent red, which this palette reserves
/// for penalties.
class StatChip extends StatelessWidget {
  final StatType stat;

  /// Resolved rows recede; the chip fades with the rest of the row rather than
  /// staying bright and pulling the eye back to finished work.
  final bool dimmed;

  const StatChip({super.key, required this.stat, this.dimmed = false});

  @override
  Widget build(BuildContext context) {
    final Color color = dimmed
        ? stat.color.withValues(alpha: 0.35)
        : stat.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.10),
        shape: ChamferBorder(
          cut: 4,
          side: BorderSide(color: color.withValues(alpha: 0.55), width: 1),
        ),
      ),
      child: Text(
        stat.label,
        style: AppTextStyles.hudLabel.copyWith(
          color: color,
          fontSize: 10,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
