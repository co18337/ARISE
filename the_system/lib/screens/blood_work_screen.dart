import 'package:flutter/material.dart';

import '../data/repositories/progress_repository.dart';
import '../theme/theme.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/system_panel.dart';

/// BLOOD WORK — the medical record, on its own.
///
/// It used to sit on PROGRESS, which was wrong. PROGRESS answers "is my body
/// changing?", and liver enzymes and kidney markers do not answer that. They
/// are a record that matters at the next test, not a training signal, and
/// mixing them into a transformation screen invited reading them as one.
///
/// Every value keeps the reference interval it was measured against, because
/// ranges differ by lab and method and a number without its range says
/// nothing. The FLAGS are the report's own — deciding a value is out of range
/// is interpretation, and that belongs to the doctor who ordered the test.
class BloodWorkScreen extends StatelessWidget {
  final ProgressView view;

  const BloodWorkScreen({super.key, required this.view});

  @override
  Widget build(BuildContext context) {
    final flagged = view.flaggedLabs;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Row(
                children: [
                  Text(
                    'RECORD',
                    style: AppTextStyles.hudLabel.copyWith(
                      color: AppColors.textDim,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: Icon(Icons.close, color: AppColors.textSecondary),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: [
                  HudSectionTitle('BLOOD WORK'),
                  const SizedBox(height: 14),
                  if (view.labs.isEmpty)
                    SystemPanel(
                      child: Text(
                        'No results on record.',
                        style: AppTextStyles.body,
                      ),
                    )
                  else ...[
                    if (view.lastLabDate != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Drawn ${_longDate(view.lastLabDate!)}',
                          style: AppTextStyles.hudLabel.copyWith(
                            fontSize: 10,
                            color: AppColors.textDim,
                          ),
                        ),
                      ),
                    if (flagged.isNotEmpty) ...[
                      SystemPanel(
                        title: 'OUTSIDE THE REFERENCE RANGE',
                        accent: AppColors.accentGold,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final lab in flagged) LabRow(lab: lab),
                            const SizedBox(height: 8),
                            Text(
                              'Flagged on the report itself, not by this app. '
                              'What any of it means is a conversation with '
                              'your doctor.',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 11,
                                height: 1.4,
                                color: AppColors.textDim,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    for (final entry in view.labsByPanel.entries) ...[
                      SystemPanel(
                        title: entry.key,
                        glow: 0.14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final lab in entry.value) LabRow(lab: lab),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const List<String> _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];

  static String _longDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';
}

/// One line of a report: name, value, and the range it was measured against.
class LabRow extends StatelessWidget {
  final LabResult lab;

  const LabRow({super.key, required this.lab});

  @override
  Widget build(BuildContext context) {
    final flagged = lab.isFlagged;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              lab.name,
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Expanded, not fixed: a long analyte name at a large system font
          // is how this row overflows on a narrow phone.
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  lab.reading,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.readout.copyWith(
                    fontSize: 12,
                    color: flagged
                        ? AppColors.accentGold
                        : AppColors.textPrimary,
                  ),
                ),
                if (lab.refText.isNotEmpty)
                  Text(
                    lab.refText,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.hudLabel.copyWith(
                      fontSize: 9,
                      color: AppColors.textDim,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
