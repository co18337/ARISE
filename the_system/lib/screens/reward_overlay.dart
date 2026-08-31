import 'package:flutter/material.dart';

import '../game/game.dart';
import '../theme/theme.dart';
import '../widgets/achievement_badge.dart';
import '../widgets/badge_image.dart';
import '../widgets/gradient_button.dart';
import '../widgets/rank_emblem.dart';

/// The moments that interrupt: a level, a rank, a medal.
///
/// Deliberately modal and deliberately rare. Everything else in this app
/// reports quietly; these three stop you, because a reward you can scroll past
/// is not a reward. Shown one at a time, smallest first, so a session that
/// levels you up AND promotes you ends on the promotion.
class RewardOverlay extends StatefulWidget {
  final List<RewardEvent> events;

  const RewardOverlay({super.key, required this.events});

  @override
  State<RewardOverlay> createState() => _RewardOverlayState();
}

class _RewardOverlayState extends State<RewardOverlay> {
  int _index = 0;

  void _next() {
    if (_index + 1 < widget.events.length) {
      setState(() => _index++);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.events[_index];
    final remaining = widget.events.length - _index - 1;

    return Scaffold(
      backgroundColor: AppColors.background.withValues(alpha: 0.92),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              child: _RewardCard(
                // Keyed by position so moving to the next reward animates
                // rather than mutating the card in place.
                key: ValueKey(_index),
                event: event,
                remaining: remaining,
                onDismiss: _next,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final RewardEvent event;
  final int remaining;
  final VoidCallback onDismiss;

  const _RewardCard({
    super.key,
    required this.event,
    required this.remaining,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final (String banner, String title, String subtitle, Color accent,
        Widget art) = switch (event) {
      LevelUpReward(:final level) => (
        'LEVEL UP',
        'LEVEL $level',
        'The System recognises your progress.',
        AppColors.accentPurple,
        _LevelArt(level: level),
      ),
      RankUpReward(:final rank) => (
        'RANK UP',
        '${rank.label} RANK',
        'Promoted. The climb continues.',
        rank.color,
        RankEmblem(rank: rank, size: 120),
      ),
      MedalReward(:final id, :final tier) => (
        '${tier.label} MEDAL',
        id.label,
        id.description,
        tier.color,
        BadgeImage(asset: tier.badgeAsset, size: 120, glow: tier.color),
      ),
    };

    return _Entrance(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: AppColors.surface,
            shape: AppShapes.panel(
              side: BorderSide(color: accent.withValues(alpha: 0.9), width: 1.4),
            ),
            shadows: [
              BoxShadow(
                color: accent.withValues(alpha: 0.4),
                blurRadius: 44,
                spreadRadius: -8,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  banner,
                  style: AppTextStyles.hudLabel.copyWith(
                    color: accent,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 18),
                art,
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.display.copyWith(
                    fontSize: 24,
                    color: accent,
                    shadows: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.6),
                        blurRadius: 22,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 22),
                GradientButton(
                  label: remaining > 0 ? 'Next ($remaining more)' : 'Continue',
                  icon: Icons.chevron_right,
                  colors: [accent, AppColors.accentGold],
                  onPressed: onDismiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The big level number, on the crest it belongs to.
class _LevelArt extends StatelessWidget {
  final int level;

  const _LevelArt({required this.level});

  @override
  Widget build(BuildContext context) {
    final rank = Rank.forLevel(level);

    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(opacity: 0.35, child: RankEmblem(rank: rank, size: 110)),
          Text(
            '$level',
            style: AppTextStyles.display.copyWith(
              fontSize: 56,
              color: AppColors.accentPurple,
              shadows: [
                BoxShadow(
                  color: AppColors.accentPurple.withValues(alpha: 0.8),
                  blurRadius: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Scale-and-fade in. The overshoot is what makes it land rather than appear.
class _Entrance extends StatelessWidget {
  final Widget child;

  const _Entrance({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutBack,
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.scale(scale: 0.85 + 0.15 * t, child: child),
      ),
      child: child,
    );
  }
}
