import 'package:flutter/material.dart';

import '../data/day_key.dart';
import '../data/repositories/activity_repository.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/hud_section_title.dart';

/// The activity feed: what happened, newest first, grouped by day.
///
/// Real from the start — the quest repository has been writing these entries
/// since Phase 3, so there is already history to show.
class ActivityLogScreen extends StatefulWidget {
  final ActivityRepository activityRepository;

  const ActivityLogScreen({super.key, required this.activityRepository});

  @override
  State<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  late final Stream<List<ActivityEntry>> _stream =
      widget.activityRepository.watchRecent();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ActivityEntry>>(
      stream: _stream,
      builder: (context, snapshot) {
        final entries = snapshot.data;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            const HudSectionTitle('ACTIVITY LOG'),
            const SizedBox(height: 18),
            if (entries == null)
              const Center(child: CircularProgressIndicator())
            else if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  'NO ACTIVITY RECORDED',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.hudLabel,
                ),
              )
            else
              ..._buildGroupedEntries(entries),
          ],
        );
      },
    );
  }

  /// Inserts a date divider whenever the day changes, so the feed reads as a
  /// timeline rather than an undifferentiated list.
  List<Widget> _buildGroupedEntries(List<ActivityEntry> entries) {
    final widgets = <Widget>[];
    int? lastDay;

    for (final entry in entries) {
      if (entry.day != lastDay) {
        widgets.add(_DateDivider(day: entry.day));
        lastDay = entry.day;
      }
      widgets.add(_ActivityRow(entry: entry));
    }
    return widgets;
  }
}

/// A date heading flanked by rules — the timeline separator.
class _DateDivider extends StatelessWidget {
  final int day;

  const _DateDivider({required this.day});

  @override
  Widget build(BuildContext context) {
    final date = dateOfDayKey(day);
    final today = todayKey();

    final String label = switch (day) {
      _ when day == today => 'TODAY',
      _ when day == today - 1 => 'YESTERDAY',
      _ => '${_months[date.month - 1]} ${date.day}',
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 18, 0, 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: AppTextStyles.hudLabel.copyWith(color: AppColors.primary),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
        ],
      ),
    );
  }

  static const _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];
}

/// One event: time on the left, an icon marker, the title, and any XP change.
class _ActivityRow extends StatelessWidget {
  final ActivityEntry entry;

  const _ActivityRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _styleFor(entry.kind);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            child: Text(
              _time(entry.at),
              style: AppTextStyles.counter.copyWith(
                fontSize: 11,
                color: AppColors.textDim,
              ),
            ),
          ),
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: color.withValues(alpha: 0.12),
              shape: ChamferBorder(
                cut: 6,
                side: BorderSide(color: color.withValues(alpha: 0.7)),
              ),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.title, style: AppTextStyles.questTitle),
                if (entry.detail != null)
                  Text(entry.detail!, style: AppTextStyles.body.copyWith(fontSize: 12)),
              ],
            ),
          ),
          if (entry.xpDelta != null && entry.xpDelta != 0)
            Text(
              entry.xpDelta! > 0 ? '+${entry.xpDelta}' : '${entry.xpDelta}',
              style: AppTextStyles.counter.copyWith(
                fontSize: 13,
                color: entry.xpDelta! > 0 ? AppColors.accentGold : AppColors.textDim,
              ),
            ),
        ],
      ),
    );
  }

  static (IconData, Color) _styleFor(ActivityKind kind) => switch (kind) {
    ActivityKind.questCleared => (Icons.check, AppColors.primary),
    ActivityKind.questUncleared => (Icons.undo, AppColors.textDim),
    ActivityKind.questMissed => (Icons.close, AppColors.danger),
    ActivityKind.levelUp => (Icons.arrow_upward, AppColors.accentPurple),
    ActivityKind.rankUp => (Icons.workspace_premium, AppColors.accentGold),
    ActivityKind.streakBroken => (Icons.link_off, AppColors.danger),
    ActivityKind.achievementUnlocked => (Icons.hexagon_outlined, AppColors.accentGold),
    ActivityKind.dailyBriefing => (Icons.smart_toy_outlined, AppColors.accentMagenta),
  };

  static String _time(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}
