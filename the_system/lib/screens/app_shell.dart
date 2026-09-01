import 'package:flutter/material.dart';

import '../data/export/export_repository.dart';
import '../data/repositories/activity_repository.dart';
import '../data/repositories/player_repository.dart';
import '../data/repositories/quest_repository.dart';
import '../ai/ai_log_repository.dart';
import '../data/memory/memory_repository.dart';
import '../data/repositories/nutrition_repository.dart';
import '../data/repositories/alert_repository.dart';
import '../data/repositories/health_repository.dart';
import '../data/repositories/plan_repository.dart';
import '../data/repositories/review_repository.dart';
import '../data/repositories/progress_repository.dart';
import '../data/repositories/workout_repository.dart';
import '../theme/theme.dart';
import '../widgets/animated_counter.dart';
import '../widgets/hud_backdrop.dart';
import '../widgets/hud_route.dart';
import '../widgets/rank_header.dart';
import '../widgets/theme_toggle_button.dart';
import 'activity_log_screen.dart';
import 'backup_screen.dart';
import 'nav_hub.dart';
import 'reward_overlay.dart';
import 'status_screen.dart';
import 'memory_screen.dart';
import 'alerts_screen.dart';
import 'nutrition_screen.dart';
import 'plan_screen.dart';
import 'progress_screen.dart';
import 'training_screen.dart';
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
  final WorkoutRepository workoutRepository;
  final MemoryRepository memoryRepository;
  final AiLogRepository aiLogRepository;
  final NutritionRepository nutritionRepository;
  final ProgressRepository progressRepository;
  final AlertRepository alertRepository;
  final HealthRepository healthRepository;
  final PlanRepository planRepository;
  final ReviewRepository reviewRepository;

  /// The look currently in force, and the way to change it. Owned by MyApp,
  /// because switching theme rebuilds everything below it.
  final AppThemeMode themeMode;
  final ValueChanged<AppThemeMode> onThemeModeChanged;

  const AppShell({
    super.key,
    required this.questRepository,
    required this.playerRepository,
    required this.activityRepository,
    required this.exportRepository,
    required this.workoutRepository,
    required this.memoryRepository,
    required this.aiLogRepository,
    required this.nutritionRepository,
    required this.progressRepository,
    required this.alertRepository,
    required this.healthRepository,
    required this.planRepository,
    required this.reviewRepository,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppSection _section = AppSection.quests;

  /// Guards against pushing a second reward overlay while one is up.
  ///
  /// The player stream re-emits on every write, and acknowledging a reward is
  /// itself a write — without this the modal would re-enter itself.
  bool _showingRewards = false;

  // Owned by the shell so the header keeps its value across section changes.
  late final Stream<PlayerSnapshot> _playerStream =
      widget.playerRepository.watch();

  /// Shows anything earned but not yet celebrated, then records it as seen.
  ///
  /// Driven off the player stream rather than from the places that grant XP:
  /// a level-up can arrive from a quest, a training session or a backfill, and
  /// one place that notices is better than three that might not.
  Future<void> _showPendingRewards(PlayerSnapshot player) async {
    if (_showingRewards) return;
    final events = player.pending;
    if (events.isEmpty) return;

    _showingRewards = true;
    try {
      await Navigator.of(context).push(hudRoute(RewardOverlay(events: events)));
      await widget.playerRepository.acknowledgeRewards();
    } finally {
      _showingRewards = false;
    }
  }

  Future<void> _openHub() async {
    final chosen = await Navigator.of(context).push<AppSection>(
      hudRoute(NavHub(current: _section)),
    );
    if (chosen != null && chosen != _section) {
      setState(() => _section = chosen);
    }
  }

  Widget _buildSection(PlayerSnapshot? player) {
    return switch (_section) {
      AppSection.quests => TodayScreen(
        key: const ValueKey('quests'),
        questRepository: widget.questRepository,
        onOpenReport: () => setState(() => _section = AppSection.weeklyReport),
        onOpenTraining: () => setState(() => _section = AppSection.training),
        onDayOpened: widget.alertRepository.reschedule,
      ),
      AppSection.training => TrainingScreen(
        key: const ValueKey('training'),
        workoutRepository: widget.workoutRepository,
        player: player,
        // Finishing the session clears the routine's workout step, so the same
        // commitment is never ticked twice. Async and awaited by the screen:
        // this is the call that awards the XP.
        onSessionCompleted: () async => widget.questRepository.completeTemplate(
          'workout_of_the_day',
          widget.workoutRepository.clock.now(),
        ),
      ),
      AppSection.nutrition => NutritionScreen(
        key: const ValueKey('nutrition'),
        nutritionRepository: widget.nutritionRepository,
      ),
      AppSection.status => StatusScreen(
        key: const ValueKey('status'),
        playerRepository: widget.playerRepository,
      ),
      AppSection.alerts => AlertsScreen(
        key: const ValueKey('alerts'),
        alertRepository: widget.alertRepository,
      ),
      AppSection.progress => ProgressScreen(
        key: const ValueKey('progress'),
        progressRepository: widget.progressRepository,
        healthRepository: widget.healthRepository,
      ),
      AppSection.weeklyReport => WeeklyReportScreen(
        key: const ValueKey('report'),
        reviewRepository: widget.reviewRepository,
        playerRepository: widget.playerRepository,
      ),
      AppSection.activityLog => ActivityLogScreen(
        key: const ValueKey('log'),
        activityRepository: widget.activityRepository,
      ),
      AppSection.memory => MemoryScreen(
        key: const ValueKey('memory'),
        memoryRepository: widget.memoryRepository,
        aiLogRepository: widget.aiLogRepository,
      ),
      AppSection.plan => PlanScreen(
        key: const ValueKey('plan'),
        planRepository: widget.planRepository,
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
    // Listening to the palette is what makes a theme flip reach this screen at
    // all. MaterialApp's `home` is captured by the Navigator when the first
    // route is pushed, so rebuilding MaterialApp with a new ThemeData does NOT
    // rebuild anything below it — and every widget here reads the AppColors
    // globals rather than Theme.of(context), so nothing else would notice.
    return ValueListenableBuilder<AppPalette>(
      valueListenable: AppColors.listenable,
      builder: (context, _, _) => _buildShell(context),
    );
  }

  Widget _buildShell(BuildContext context) {
    return Scaffold(
      body: HudBackdrop(
        child: SafeArea(
          child: StreamBuilder<PlayerSnapshot>(
            stream: _playerStream,
            builder: (context, snapshot) {
              final player = snapshot.data;

              // After the frame, not during it: pushing a route from inside
              // build() throws.
              if (player != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _showPendingRewards(player);
                });
              }

              return Column(
                children: [
                  RankHeader(
                    player: player,
                    // Top-right of every screen: the header is the only strip
                    // that is always on screen.
                    trailing: ThemeToggleButton(
                      mode: widget.themeMode,
                      onChanged: widget.onThemeModeChanged,
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
child: _buildSection(player),
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
      decoration: BoxDecoration(
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
          child: Icon(Icons.blur_circular, color: AppColors.primary, size: 24),
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
