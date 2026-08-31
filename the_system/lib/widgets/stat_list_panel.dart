import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// One label/value row inside a [StatListPanel].
class StatRow {
  final String label;
  final String value;

  /// Optional override — use it to make one figure stand out, not for decoration.
  final Color? valueColor;

  const StatRow(this.label, this.value, {this.valueColor});
}

/// A titled block of label-on-the-left, value-on-the-right rows with a
/// coloured left edge — Ingress's Combat / Defense / Health stat blocks.
///
/// This is the workhorse for the STATUS screen: dense, scannable, and it
/// scales to any number of figures without redesign.
class StatListPanel extends StatelessWidget {
  final String title;
  final List<StatRow> rows;
  final Color? accent;

  const StatListPanel({
    super.key,
    required this.title,
    required this.rows,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = this.accent ?? AppColors.primary;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.55),
        border: Border(left: BorderSide(color: accent, width: 3)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.panelTitle.copyWith(color: accent),
          ),
          const SizedBox(height: 10),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      row.label,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    row.value,
                    style: AppTextStyles.readout.copyWith(color: row.valueColor),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
