import 'package:flutter/material.dart';

import '../data/repositories/player_repository.dart';
import '../game/game.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/hud_tab_bar.dart';
import '../widgets/stat_bar.dart';
import '../widgets/stat_list_panel.dart';
import '../widgets/system_panel.dart';

/// The character sheet: who you are, how far you've come, and the four stats.
///
/// Level and rank are always lifetime figures — they measure the whole
/// journey. Everything below the header respects the selected time window, so
/// "how am I doing lately" and "how far have I come" are answerable on the
/// same screen without confusing the two.
class StatusScreen extends StatefulWidget {
  final PlayerRepository playerRepository;

  const StatusScreen({super.key, required this.playerRepository});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StatScope _scope = StatScope.allTime;

  // Created once, never inside build() — see the note in TodayScreen.
  late final Stream<PlayerSnapshot> _playerStream =
      widget.playerRepository.watch();

  /// Rebuilt when the tab changes, which is the one time a new stream is
  /// correct: the query itself is different.
  late Stream<ScopedStats> _statsStream =
      widget.playerRepository.watchScopedStats(_scope);

  void _selectScope(StatScope scope) {
    if (scope == _scope) return;
    setState(() {
      _scope = scope;
      _statsStream = widget.playerRepository.watchScopedStats(scope);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Content only — AppShell provides the backdrop, RankHeader and bottom bar.
    return StreamBuilder<PlayerSnapshot>(
      stream: _playerStream,
      builder: (context, playerSnapshot) {
        final player = playerSnapshot.data;
        if (player == null) {
          return const Center(child: CircularProgressIndicator());
        }

          return StreamBuilder<ScopedStats>(
            stream: _statsStream,
            builder: (context, statsSnapshot) {
              final stats = statsSnapshot.data ?? ScopedStats.empty;

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: [
                  const HudSectionTitle('STATUS'),
                  const SizedBox(height: 18),
                  _ProfileHeader(player: player),
                  const SizedBox(height: 20),
                  HudTabBar(
                    labels: [for (final s in StatScope.values) s.label],
                    selectedIndex: StatScope.values.indexOf(_scope),
                    onSelected: (i) => _selectScope(StatScope.values[i]),
                  ),
                  const SizedBox(height: 18),
                  // Keyed by scope so switching tabs crossfades the figures
                  // rather than having them jump to new values in one frame.
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    child: Column(
                      key: ValueKey(_scope),
                      children: [
                        _StatBars(player: player, stats: stats),
                        const SizedBox(height: 16),
                        _ScopedPanels(player: player, stats: stats),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
      },
    );
  }
}

/// The three stat blocks whose figures depend on the selected time window.
class _ScopedPanels extends StatelessWidget {
  final PlayerSnapshot player;
  final ScopedStats stats;

  const _ScopedPanels({required this.player, required this.stats});

  static String _days(int n) => n == 1 ? '1 day' : '$n days';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatListPanel(
          title: 'Consistency',
          accent: AppColors.accentGold,
          rows: [
            StatRow(
              'Current streak',
              _days(player.currentStreak),
              valueColor: player.currentStreak > 0 ? AppColors.accentGold : null,
            ),
            StatRow('Longest streak', _days(player.longestStreak)),
            StatRow('Perfect days', '${stats.perfectDays}'),
            StatRow('Days recorded', '${stats.daysRecorded}'),
          ],
        ),
        const SizedBox(height: 12),
        StatListPanel(
          title: 'Quests',
          rows: [
            StatRow('Cleared', '${stats.questsCleared}'),
            StatRow('Issued', '${stats.questsIssued}'),
            StatRow(
              'Completion rate',
              '${(stats.completionRate * 100).round()}%',
            ),
          ],
        ),
        const SizedBox(height: 12),
        StatListPanel(
          title: 'Experience',
          accent: AppColors.accentPurple,
          rows: [
            StatRow('XP earned', '${stats.xpEarned}'),
            StatRow('XP available', '${stats.xpAvailable}'),
            StatRow('Lifetime XP', '${player.totalXp}'),
            StatRow('To next level', '${player.progress.xpRemaining}'),
          ],
        ),
      ],
    );
  }
}

/// Name, rank badge, big level number and the bar to the next level.
class _ProfileHeader extends StatelessWidget {
  final PlayerSnapshot player;

  const _ProfileHeader({required this.player});

  @override
  Widget build(BuildContext context) {
    final rank = player.rank;

    return SystemPanel(
      glow: 0.45,
      accent: rank.color,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // The Hunter's name is deliberately absent: RankHeader shows it
              // on every screen, so repeating it here would be noise. This
              // panel is about rank progression instead.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${rank.label} RANK',
                      style: AppTextStyles.display.copyWith(
                        fontSize: 20,
                        color: rank.color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      rank.next == null
                          ? 'MAXIMUM RANK'
                          : 'NEXT: ${rank.next!.label} AT LEVEL ${rank.next!.minLevel}',
                      style: AppTextStyles.hudLabel,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text('LEVEL', style: AppTextStyles.hudLabel),
                  Text(
                    '${player.level}',
                    style: AppTextStyles.display.copyWith(
                      fontSize: 40,
                      color: rank.color,
                      shadows: [
                        BoxShadow(
                          color: rank.color.withValues(alpha: 0.55),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          StatBar(
            label: 'To level ${player.level + 1}',
            value: player.progress.xpIntoLevel,
            max: player.progress.xpForLevel,
            color: AppColors.accentPurple,
            height: 10,
          ),
        ],
      ),
    );
  }
}

/// The four stat bars, each on its own level curve.
class _StatBars extends StatelessWidget {
  final PlayerSnapshot player;
  final ScopedStats stats;

  const _StatBars({required this.player, required this.stats});

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      title: 'Stats',
      glow: 0.25,
      child: Column(
        children: [
          for (final stat in StatType.values) ...[
            _StatRowBar(
              stat: stat,
              lifetimeXp: player.statXp[stat] ?? 0,
              scopedXp: stats.statXp[stat] ?? 0,
              progress: player.statProgress(stat),
            ),
            if (stat != StatType.values.last) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _StatRowBar extends StatelessWidget {
  final StatType stat;
  final int lifetimeXp;
  final int scopedXp;
  final LevelProgress progress;

  const _StatRowBar({
    required this.stat,
    required this.lifetimeXp,
    required this.scopedXp,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              stat.label,
              style: AppTextStyles.readout.copyWith(color: stat.color),
            ),
            const SizedBox(width: 8),
            Text(
              'LV ${progress.level}',
              style: AppTextStyles.hudLabel.copyWith(color: stat.color),
            ),
            const Spacer(),
            // Both figures matter: what this stat earned in the selected
            // window, and where its level sits overall.
            Text(
              '+$scopedXp',
              style: AppTextStyles.hudLabel.copyWith(
                color: scopedXp > 0 ? AppColors.textPrimary : AppColors.textDim,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${progress.xpIntoLevel} / ${progress.xpForLevel}',
              style: AppTextStyles.readout.copyWith(fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        StatBar(
          label: stat.label,
          value: progress.xpIntoLevel,
          max: progress.xpForLevel,
          color: stat.color,
          height: 7,
          showHeader: false,
        ),
      ],
    );
  }
}
