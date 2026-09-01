import 'package:flutter/material.dart';

import '../data/repositories/player_repository.dart';
import '../data/repositories/review_repository.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../game/game.dart';
import '../widgets/achievement_badge.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hud_entrance.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/stat_bar.dart';
import '../widgets/stat_list_panel.dart';
import '../widgets/system_panel.dart';

/// The weekly report: how the last seven days actually went.
///
/// Built on the existing rollup queries rather than a placeholder, because the
/// data already exists — there was no reason to stub a screen we can fill.
///
/// The medal case at the bottom is LIFETIME, not weekly, and says so: medals
/// measure the whole journey, and resetting them every Monday would make them
/// worthless.
class WeeklyReportScreen extends StatefulWidget {
  final PlayerRepository playerRepository;

  /// The Sunday review. Written once a week and kept; generated on the first
  /// opening at or after Sunday evening.
  final ReviewRepository reviewRepository;

  const WeeklyReportScreen({
    super.key,
    required this.playerRepository,
    required this.reviewRepository,
  });

  @override
  State<WeeklyReportScreen> createState() => _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends State<WeeklyReportScreen> {
  late final Stream<ScopedStats> _weekStream =
      widget.playerRepository.watchScopedStats(StatScope.week);
  late final Stream<PlayerSnapshot> _playerStream =
      widget.playerRepository.watch();

  /// Generated on open if Sunday evening has passed and it has not been
  /// written yet — the automatic path, since a notification cannot run Dart.
  late Future<WeekReview?> _review = _loadReview();
  bool _writing = false;

  Future<WeekReview?> _loadReview() async {
    final now = widget.reviewRepository.clock.now();
    final thisWeek = await widget.reviewRepository.generateIfDue(now) ??
        await widget.reviewRepository.read(now);
    if (thisWeek != null) return thisWeek;

    // Falls back to the most recent. From Monday morning the current week is
    // a new, empty one that is not due until its own Sunday — and showing
    // nothing for six days because a fresh week has started would throw away
    // the review the moment it became useful to act on.
    final all = await widget.reviewRepository.readAll();
    return all.isEmpty ? null : all.first;
  }

  Future<void> _writeNow() async {
    setState(() => _writing = true);
    try {
      await widget.reviewRepository.generate(
        widget.reviewRepository.clock.now(),
      );
    } finally {
      if (mounted) {
        setState(() {
          _writing = false;
          _review = _loadReview();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ScopedStats>(
      stream: _weekStream,
      builder: (context, weekSnapshot) {
        final week = weekSnapshot.data ?? ScopedStats.empty;

        return StreamBuilder<PlayerSnapshot>(
          stream: _playerStream,
          builder: (context, playerSnapshot) {
            final player = playerSnapshot.data;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                HudSectionTitle('WEEKLY REPORT', accent: AppColors.accentGold),
                const SizedBox(height: 18),
                FutureBuilder<WeekReview?>(
                  future: _review,
                  builder: (context, snapshot) => _ReviewPanel(
                    review: snapshot.data,
                    writing: _writing,
                    onWrite: _writeNow,
                  ),
                ),
                const SizedBox(height: 14),
                HudEntrance(index: 0, child: _AdherencePanel(week: week)),
                const SizedBox(height: 14),
                HudEntrance(
                  index: 1,
                  child: StatListPanel(
                    title: 'This week',
                    accent: AppColors.accentGold,
                    rows: [
                      StatRow('Quests cleared', '${week.questsCleared}'),
                      StatRow(
                        'Quests missed',
                        '${week.questsMissed}',
                        valueColor: week.questsMissed > 0
                            ? AppColors.danger
                            : null,
                      ),
                      StatRow('Quests issued', '${week.questsIssued}'),
                      StatRow('XP earned', '${week.xpEarned}'),
                      StatRow('Perfect days', '${week.perfectDays}'),
                      StatRow(
                        'Current streak',
                        '${player?.currentStreak ?? 0} days',
                        valueColor: (player?.currentStreak ?? 0) > 0
                            ? AppColors.accentGold
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                HudEntrance(index: 2, child: _StatBreakdown(week: week)),
                const SizedBox(height: 22),
                HudSectionTitle('ACHIEVEMENTS'),
                const SizedBox(height: 14),
                HudEntrance(
                  index: 3,
                  child: _AchievementGrid(
                    // Empty metrics until the stream lands, so the case still
                    // renders its locked medals on the very first frame.
                    achievements: evaluateAchievements(
                      player?.metrics ?? AchievementMetrics.empty,
                    ),
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

/// Weekly adherence against tiered targets.
class _AdherencePanel extends StatelessWidget {
  final ScopedStats week;

  const _AdherencePanel({required this.week});

  @override
  Widget build(BuildContext context) {
    final pct = (week.completionRate * 100).round();

    return SystemPanel(
      title: 'Adherence',
      accent: AppColors.accentGold,
      glow: 0.35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$pct',
                style: AppTextStyles.counter.copyWith(fontSize: 42),
              ),
              Text('%', style: AppTextStyles.counter.copyWith(fontSize: 20)),
              const Spacer(),
              Text(
                '${week.questsCleared} / ${week.questsIssued}',
                style: AppTextStyles.readout,
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Tiered bar: gold for what's earned, green for what's left, with
          // ticks at the thresholds that actually matter.
          StatBar(
            label: 'Quests cleared this week',
            value: week.questsCleared,
            max: week.questsIssued > 0 ? week.questsIssued : 1,
            tiers: _tiersFor(week.questsIssued),
            showEarnedRemaining: true,
            height: 12,
          ),
        ],
      ),
    );
  }

  /// 60% is the streak bar, 80% a strong week, 100% perfect.
  static List<int> _tiersFor(int issued) {
    if (issued <= 0) return const [];
    return [
      (issued * 0.6).round(),
      (issued * 0.8).round(),
      issued,
    ];
  }
}

class _StatBreakdown extends StatelessWidget {
  final ScopedStats week;

  const _StatBreakdown({required this.week});

  @override
  Widget build(BuildContext context) {
    final total = week.statXp.values.fold(0, (a, b) => a + b);

    return SystemPanel(
      title: 'XP by stat',
      child: Column(
        children: [
          for (final stat in StatType.values) ...[
            StatBar(
              label: stat.label,
              value: week.statXp[stat] ?? 0,
              max: total > 0 ? total : 1,
              color: stat.color,
              trailingText: '${week.statXp[stat] ?? 0}',
              height: 7,
            ),
            if (stat != StatType.values.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

/// Placeholder achievement grid — the badges are real widgets, the unlock
/// logic lands in Phase 7.
class _AchievementGrid extends StatelessWidget {
  final List<AchievementProgress> achievements;

  const _AchievementGrid({required this.achievements});

  @override
  Widget build(BuildContext context) {
    final earned = achievements.where((a) => a.earned).length;

    return SystemPanel(
      title: 'Medals · lifetime',
      glow: 0.18,
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 16,
            children: [
              for (final a in achievements) AchievementBadge(progress: a),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '$earned OF ${achievements.length} MEDALS STARTED',
            textAlign: TextAlign.center,
            style: AppTextStyles.hudLabel.copyWith(fontSize: 9),
          ),
        ],
      ),
    );
  }
}

/// The Sunday review, or an honest note that it is not due yet.
class _ReviewPanel extends StatelessWidget {
  final WeekReview? review;
  final bool writing;
  final VoidCallback onWrite;

  const _ReviewPanel({
    required this.review,
    required this.writing,
    required this.onWrite,
  });

  @override
  Widget build(BuildContext context) {
    final r = review;
    if (r == null) {
      return SystemPanel(
        title: 'THE WEEK IN REVIEW',
        glow: 0.14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Written on Sunday evening, once a week. Open the app after 8pm '
              'on Sunday and it appears here.',
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            GradientButton(
              label: writing ? 'Writing…' : 'Write it now',
              icon: writing ? null : Icons.auto_stories_outlined,
              onPressed: writing ? null : onWrite,
            ),
          ],
        ),
      );
    }

    return SystemPanel(
      title: 'THE WEEK IN REVIEW',
      accent: AppColors.accentGold,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(r.summary, style: AppTextStyles.body.copyWith(height: 1.5)),
          const SizedBox(height: 14),
          _ReviewLine('KEPT', r.kept, AppColors.primary),
          const SizedBox(height: 8),
          _ReviewLine('CHANGE', r.change, AppColors.accentGold),
          const SizedBox(height: 12),
          // Which it is, said plainly. A sentence a model wrote and one
          // assembled from the figures deserve different trust — the same rule
          // the trainer note follows.
          Text(
            r.fromModel
                ? 'Written from your record.'
                : 'Assembled from the figures — no model answered.',
            style: AppTextStyles.hudLabel.copyWith(
              fontSize: 9,
              color: AppColors.textDim,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewLine extends StatelessWidget {
  final String label;
  final String text;
  final Color accent;

  const _ReviewLine(this.label, this.text, this.accent);

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 64,
        child: Text(
          label,
          style: AppTextStyles.hudLabel.copyWith(fontSize: 9, color: accent),
        ),
      ),
      // Expanded, or a long sentence overflows the row on a narrow phone.
      Expanded(
        child: Text(
          text,
          style: AppTextStyles.body.copyWith(fontSize: 12, height: 1.4),
        ),
      ),
    ],
  );
}
