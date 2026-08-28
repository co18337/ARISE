import 'package:flutter/material.dart';

import '../data/daily_generator.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/hud_backdrop.dart';
import '../widgets/quest_tile.dart';
import '../widgets/stat_bar.dart';
import '../widgets/system_panel.dart';

/// The home screen, styled as the System's "DAILY QUESTS" window: a status
/// header with today's XP, then one panel per category of quests.
///
/// Still entirely in-memory — completions reset on restart until Phase 3
/// wires up Drift.
class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  late final List<DailyTask> _todaysTasks = generateTasksForDate(DateTime.now());

  void _toggleTask(DailyTask task, bool done) {
    setState(() {
      task.done = done;
      task.completedAt = done ? DateTime.now() : null;
    });
  }

  int get _xpEarned =>
      _todaysTasks.where((t) => t.done).fold(0, (sum, t) => sum + t.template.xp);

  /// Every XP point available today — the denominator for the XP bar.
  int get _xpAvailable => _todaysTasks.fold(0, (sum, t) => sum + t.template.xp);

  int get _questsCleared => _todaysTasks.where((t) => t.done).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HudBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              const _SystemBrandBar(),
              const SizedBox(height: 16),
              _buildStatusHeader(),
              const SizedBox(height: 28),
              const _SectionTitle('DAILY QUESTS'),
              const SizedBox(height: 14),
              ..._buildCategoryPanels(),
            ],
          ),
        ),
      ),
    );
  }

  /// The status window: who you are, what day it is, and today's XP.
  Widget _buildStatusHeader() {
    return SystemPanel(
      glow: 0.45,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('HUNTER', style: AppTextStyles.hudLabel),
                    const SizedBox(height: 2),
                    // Placeholder name — becomes a real profile in Phase 4.
                    Text('PRINCE', style: AppTextStyles.hunterName),
                  ],
                ),
              ),
              const _RankBadge('E'),
            ],
          ),
          const SizedBox(height: 10),
          Text(_formatDate(DateTime.now()), style: AppTextStyles.body),
          const SizedBox(height: 16),
          StatBar(
            label: 'Daily XP',
            value: _xpEarned,
            max: _xpAvailable,
            height: 10,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('QUESTS CLEARED', style: AppTextStyles.hudLabel),
              Text(
                '$_questsCleared / ${_todaysTasks.length}',
                style: AppTextStyles.readout,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// One panel per category that actually has quests today, in enum order so
  /// the layout stays stable from day to day.
  List<Widget> _buildCategoryPanels() {
    final List<Widget> panels = [];

    for (final category in TaskCategory.values) {
      final tasks = _todaysTasks.where((t) => t.template.category == category).toList();
      if (tasks.isEmpty) continue;

      // Colour the panel by the stat its quests feed, so the four stat
      // colours are already familiar by the time Phase 4 shows them.
      final Color accent = tasks.first.template.stat.color;

      panels.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: SystemPanel(
            title: category.label,
            accent: accent,
            glow: 0.22,
            // Tighter horizontal padding: the quest rows supply their own.
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Column(
              children: [
                for (final task in tasks)
                  QuestTile(
                    task: task,
                    accent: accent,
                    onChanged: (done) => _toggleTask(task, done),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return panels;
  }
}

/// Thin branding strip at the top of the screen.
class _SystemBrandBar extends StatelessWidget {
  const _SystemBrandBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppColors.primary, blurRadius: 8)],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'THE SYSTEM',
          style: AppTextStyles.hudLabel.copyWith(color: AppColors.textSecondary),
        ),
        const Spacer(),
        Text('ONLINE', style: AppTextStyles.hudLabel.copyWith(color: AppColors.primary)),
      ],
    );
  }
}

/// A centred heading flanked by hairlines — the System announcing a window.
class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    final Widget rule = Expanded(
      child: Container(height: 1, color: AppColors.primary.withValues(alpha: 0.3)),
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
              // A soft glow behind the text reads as "emitted light" and is
              // what makes it feel like a projected System message.
              shadows: [
                BoxShadow(color: AppColors.primary.withValues(alpha: 0.55), blurRadius: 14),
              ],
            ),
          ),
        ),
        rule,
      ],
    );
  }
}

/// Rank chip in the status header. Static "E" until Phase 4 computes ranks.
class _RankBadge extends StatelessWidget {
  final String rank;

  const _RankBadge(this.rank);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: AppColors.accentGold.withValues(alpha: 0.10),
        shape: const ChamferBorder(
          cut: 8,
          side: BorderSide(color: AppColors.accentGold, width: 1),
          topLeft: true,
          bottomRight: true,
        ),
        shadows: [
          BoxShadow(color: AppColors.accentGold.withValues(alpha: 0.30), blurRadius: 10),
        ],
      ),
      child: Text(
        rank,
        style: AppTextStyles.hunterName.copyWith(
          color: AppColors.accentGold,
          fontSize: 15,
          letterSpacing: 0,
        ),
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

// Hand-rolled instead of pulling in the `intl` package just for one date
// string — not worth a new dependency yet.
String _formatDate(DateTime date) {
  final weekday = _weekdayNames[date.weekday - 1];
  final month = _monthNames[date.month - 1];
  return '$weekday  ·  $month ${date.day}';
}
