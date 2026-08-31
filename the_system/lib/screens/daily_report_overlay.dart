import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hud_overlay_scaffold.dart';
import '../widgets/stat_bar.dart';
import '../widgets/stat_chip.dart';
import '../widgets/stat_list_panel.dart';
import '../widgets/system_panel.dart';

/// The day's debrief, shown when every step has an answer.
///
/// The counterpart to the weekly report, and the reason the claim button
/// exists: closing the day should be an event, not the list quietly going
/// grey. It reports what happened — including the misses, which is the half
/// that makes the good days mean something.
class DailyReportOverlay extends StatelessWidget {
  final DateTime date;
  final List<DailyTask> tasks;

  /// Opens the weekly report from here.
  final VoidCallback? onOpenWeek;

  const DailyReportOverlay({
    super.key,
    required this.date,
    required this.tasks,
    this.onOpenWeek,
  });

  @override
  Widget build(BuildContext context) {
    final cleared = tasks.where((t) => t.done).toList();
    final missed = tasks.where((t) => t.missed).toList();
    final xpEarned = cleared.fold(0, (sum, t) => sum + t.xpAwarded);
    final xpAvailable = tasks.fold(0, (sum, t) => sum + t.xpAwarded);
    final perfect = tasks.isNotEmpty && missed.isEmpty;

    final byStat = <StatType, int>{};
    for (final task in cleared) {
      byStat[task.stat] = (byStat[task.stat] ?? 0) + task.xpAwarded;
    }

    return HudOverlayScaffold(
      title: 'DAY COMPLETE',
      accent: perfect ? AppColors.accentGold : AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          SystemPanel(
            glow: perfect ? 0.5 : 0.3,
            accent: perfect ? AppColors.accentGold : AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  perfect ? 'PERFECT DAY' : 'DAY CLOSED',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.display.copyWith(
                    fontSize: 20,
                    color: perfect ? AppColors.accentGold : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatDate(date),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 16),
                StatBar(
                  label: 'XP earned',
                  value: xpEarned,
                  max: xpAvailable,
                  height: 12,
                  color: perfect ? AppColors.accentGold : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          StatListPanel(
            title: 'The day',
            accent: perfect ? AppColors.accentGold : AppColors.primary,
            rows: [
              StatRow('Cleared', '${cleared.length} / ${tasks.length}'),
              StatRow(
                'Missed',
                '${missed.length}',
                valueColor: missed.isEmpty ? null : AppColors.danger,
              ),
              StatRow('XP earned', '$xpEarned'),
              StatRow('XP available', '$xpAvailable'),
            ],
          ),
          if (byStat.isNotEmpty) ...[
            const SizedBox(height: 14),
            SystemPanel(
              title: 'Where it went',
              glow: 0.2,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final stat in StatType.values)
                    if ((byStat[stat] ?? 0) > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StatChip(stat: stat),
                          const SizedBox(width: 6),
                          Text(
                            '+${byStat[stat]}',
                            style: AppTextStyles.counter.copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                ],
              ),
            ),
          ],
          if (missed.isNotEmpty) ...[
            const SizedBox(height: 14),
            SystemPanel(
              title: 'Missed',
              accent: AppColors.danger,
              glow: 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final task in missed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Icon(Icons.close, size: 14, color: AppColors.danger),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              task.template.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body.copyWith(fontSize: 13),
                            ),
                          ),
                          Text(
                            task.scheduledLabel,
                            style: AppTextStyles.hudLabel.copyWith(fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 4),
                  // Said plainly, once. A miss costs no XP; it costs the day.
                  Text(
                    'Missing a step costs no XP — it costs the day its bar, '
                    'and the streak.',
                    style: AppTextStyles.body.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          GradientButton(
            label: 'See the week',
            icon: Icons.assessment_outlined,
            colors: [AppColors.accentGold, AppColors.accentMagenta],
            onPressed: onOpenWeek == null
                ? null
                : () {
                    Navigator.of(context).maybePop();
                    onOpenWeek!();
                  },
          ),
        ],
      ),
    );
  }
}

const _weekdayNames = [
  'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY',
];
const _monthNames = [
  'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY',
  'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER',
];

String _formatDate(DateTime date) =>
    '${_weekdayNames[date.weekday - 1]}  ·  '
    '${_monthNames[date.month - 1]} ${date.day}';
