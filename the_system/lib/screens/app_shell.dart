import 'package:flutter/material.dart';

import '../data/export/export_repository.dart';
import '../data/repositories/activity_repository.dart';
import '../data/repositories/player_repository.dart';
import '../data/repositories/quest_repository.dart';
import '../theme/theme.dart';
import '../widgets/animated_counter.dart';
import '../widgets/hud_backdrop.dart';
import '../widgets/hud_route.dart';
import '../widgets/rank_header.dart';
import 'activity_log_screen.dart';
import 'backup_screen.dart';
import 'nav_hub.dart';
import 'status_screen.dart';
import 'today_screen.dart';
import 'weekly_report_screen.dart';

/// The persistent frame every screen lives inside.
///
/// RankHeader is pinned at the top and the counter bar at the bottom; only the
/// middle swaps. Because the shell owns the player stream, progression is
/// always on screen and never rebuilds just because the section changed.
///
/// Sections are swapped by index rather than pushed as routes — a pushed route
/// would put its own header on top of the shell's, which is exactly the
/// duplication the persistent strip is meant to avoid.
class AppShell extends StatefulWidget {
  final QuestRepository questRepository;
  final PlayerRepository playerRepository;
  final ActivityRepository activityRepository;
  final ExportRepository exportRepository;

  const AppShell({
    super.key,
    required this.questRepository,
    required this.playerRepository,
    required this.activityRepository,
    required this.exportRepository,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppSection _section = AppSection.quests;

  // Owned by the shell so the header keeps its value across section changes.
  late final Stream<PlayerSnapshot> _playerStream =
      widget.playerRepository.watch();

  Future<void> _openHub() async {
    final chosen = await Navigator.of(context).push<AppSection>(
      hudRoute(NavHub(current: _section)),
    );
    if (chosen != null && chosen != _section) {
      setState(() => _section = chosen);
    }
  }

  Widget _buildSection() {
    return switch (_section) {
      AppSection.quests => TodayScreen(
        key: const ValueKey('quests'),
        questRepository: widget.questRepository,
        onOpenReport: () => setState(() => _section = AppSection.weeklyReport),
      ),
      AppSection.status => StatusScreen(
        key: const ValueKey('status'),
        playerRepository: widget.playerRepository,
      ),
      AppSection.weeklyReport => WeeklyReportScreen(
        key: const ValueKey('report'),
        playerRepository: widget.playerRepository,
      ),
      AppSection.activityLog => ActivityLogScreen(
        key: const ValueKey('log'),
        activityRepository: widget.activityRepository,
      ),
      AppSection.backup => BackupScreen(
        // Keyed by nothing else, so leaving and returning rebuilds the export
        // — a backup screen showing yesterday's figures would be a trap.
        key: const ValueKey('backup'),
        exportRepository: widget.exportRepository,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HudBackdrop(
        child: SafeArea(
          child: StreamBuilder<PlayerSnapshot>(
            stream: _playerStream,
            builder: (context, snapshot) {
              final player = snapshot.data;

              return Column(
                children: [
                  RankHeader(player: player),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      child: _buildSection(),
                    ),
                  ),
                  _ShellBar(player: player, onOpenHub: _openHub),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Always-visible counters plus the button that opens the hub.
class _ShellBar extends StatelessWidget {
  final PlayerSnapshot? player;
  final VoidCallback onOpenHub;

  const _ShellBar({required this.player, required this.onOpenHub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.primaryDim, width: 1)),
      ),
      child: Row(
        children: [
          _Counter(
            label: 'TOTAL XP',
            value: player?.totalXp ?? 0,
            color: AppColors.accentPurple,
          ),
          const SizedBox(width: 22),
          _Counter(
            label: 'STREAK',
            value: player?.currentStreak ?? 0,
            color: (player?.currentStreak ?? 0) > 0
                ? AppColors.accentGold
                : AppColors.textDim,
          ),
          const SizedBox(width: 22),
          _Counter(
            label: 'PERFECT',
            value: player?.perfectDays ?? 0,
            color: AppColors.remaining,
          ),
          const Spacer(),
          _HubButton(onTap: onOpenHub),
        ],
      ),
    );
  }
}

class _HubButton extends StatelessWidget {
  final VoidCallback onTap;

  const _HubButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open navigation hub',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceRaised.withValues(alpha: 0.85),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.75),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.32),
                blurRadius: 12,
                spreadRadius: -2,
              ),
            ],
          ),
          child: const Icon(Icons.blur_circular, color: AppColors.primary, size: 24),
        ),
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _Counter({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyles.hudLabel.copyWith(fontSize: 9)),
        AnimatedCounter(
          value: value,
          style: AppTextStyles.counter.copyWith(color: color, fontSize: 15),
        ),
      ],
    );
  }
}
