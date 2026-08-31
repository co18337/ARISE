import 'package:flutter/material.dart';

import '../game/game.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import 'countdown_timer.dart';
import 'stat_chip.dart';

/// One line of the day's routine, in whichever state the engine gave it.
///
/// Each step is its OWN card rather than a row inside one big panel. A single
/// panel full of rows reads as a table; separate cards read as a sequence of
/// things, which is what a routine is — and it gives the active step somewhere
/// to stand out from without redrawing the whole list.
///
/// Resolved and locked steps are deliberately quiet. Only the active step gets
/// a full card ([ActiveStepCard]), because the entire point of the guided
/// routine is that at any moment there is exactly one thing being asked of you.
class RoutineStepTile extends StatelessWidget {
  final RoutineStep step;

  /// Reopens a resolved step. Null once its window has shut.
  final VoidCallback? onReopen;

  const RoutineStepTile({super.key, required this.step, this.onReopen});

  @override
  Widget build(BuildContext context) {
    final task = step.task;
    final (IconData icon, Color color) = switch (step.state) {
      RoutineState.done => (Icons.check, AppColors.remaining),
      RoutineState.missed => (Icons.close, AppColors.danger),
      RoutineState.locked => (Icons.lock_outline, AppColors.textDim),
      // Never rendered here — the screen swaps in an ActiveStepCard instead.
      RoutineState.active => (Icons.play_arrow, AppColors.accentMagenta),
    };

    final bool resolved = step.isResolved;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: AppColors.surface.withValues(alpha: 0.55),
          shape: AppShapes.row(
            side: BorderSide(
              color: step.state == RoutineState.missed
                  ? AppColors.danger.withValues(alpha: 0.22)
                  : AppColors.primaryDim.withValues(alpha: 0.35),
            ),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          shape: AppShapes.row(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            // Only a resolved step can be undone; a locked one has nothing
            // to say yet.
            onTap: resolved ? onReopen : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              child: Row(
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 10),
                  SizedBox(
                    // Fixed width so every time in the column lines up, which
                    // is what makes the list read as a schedule.
                    width: 62,
                    child: Text(
                      task.scheduledLabel,
                      style: AppTextStyles.hudLabel.copyWith(
                        fontSize: 10,
                        letterSpacing: 0.6,
                        color: step.state == RoutineState.missed
                            ? AppColors.danger.withValues(alpha: 0.75)
                            : AppColors.textDim,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      task.template.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.questTitle.copyWith(
                        fontSize: 14,
                        color: step.state == RoutineState.locked
                            ? AppColors.textDim
                            : AppColors.textSecondary,
                        decoration: step.state == RoutineState.done
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: AppColors.textDim,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatChip(stat: task.stat, dimmed: true),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 30,
                    child: Text(
                      step.state == RoutineState.done
                          ? '+${task.xpAwarded}'
                          : '—',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.xpBadge.copyWith(
                        fontSize: 12,
                        color: step.state == RoutineState.done
                            ? AppColors.accentGold
                            : AppColors.textDim,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The step you're on: the only thing on the screen that can be acted on.
///
/// Magenta rather than cyan, because in this palette magenta means "live /
/// urgent" and this is the one card that is genuinely both.
class ActiveStepCard extends StatelessWidget {
  final DailyTask task;
  final VoidCallback onDone;
  final VoidCallback onMissed;

  /// When this step's window shuts, for the countdown. Null hides the timer.
  final DateTime? closesAt;

  /// Opens whatever sits behind this step — for the workout, the full training
  /// session. Null for steps that are just a yes or no.
  final VoidCallback? onOpenDetail;
  final String detailLabel;

  const ActiveStepCard({
    super.key,
    required this.task,
    required this.onDone,
    required this.onMissed,
    this.closesAt,
    this.onOpenDetail,
    this.detailLabel = 'OPEN',
  });

  @override
  Widget build(BuildContext context) {
    return _Breathing(
      child: Container(
        decoration: ShapeDecoration(
          color: AppColors.accentMagenta.withValues(alpha: 0.07),
          shape: AppShapes.panel(
            side: BorderSide(
              color: AppColors.accentMagenta.withValues(alpha: 0.7),
              width: 1.2,
            ),
          ),
          shadows: [
            BoxShadow(
              color: AppColors.accentMagenta.withValues(alpha: 0.26),
              blurRadius: 24,
              spreadRadius: -6,
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                // Expanded (not Spacer) so a long time label ellipsises
                // instead of overflowing the card at 360dp phone width.
                Expanded(
                  child: Text(
                    'NOW · ${task.scheduledLabel}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.hudLabel.copyWith(
                      color: AppColors.accentMagenta,
                    ),
                  ),
                ),
                if (closesAt != null)
                  CountdownTimer(
                    target: closesAt!,
                    label: 'CLOSES',
                    style: AppTextStyles.counter.copyWith(fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              task.template.title,
              style: AppTextStyles.questTitle.copyWith(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(task.template.category.label, style: AppTextStyles.body),
            const SizedBox(height: 14),
            Row(
              children: [
                StatChip(stat: task.stat),
                const SizedBox(width: 10),
                Text(
                  '+${task.xpAwarded} XP',
                  style: AppTextStyles.xpBadge.copyWith(
                    color: AppColors.accentGold,
                  ),
                ),
              ],
            ),
            if (onOpenDetail != null) ...[
              const SizedBox(height: 12),
              _DetailLink(label: detailLabel, onTap: onOpenDetail!),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                // DONE is the wider, brighter half on purpose: the two
                // outcomes are equally valid answers, but only one of them is
                // the one you came here to give.
                Expanded(
                  flex: 3,
                  child: _AnswerButton(
                    label: 'DONE',
                    icon: Icons.check,
                    color: AppColors.accentGold,
                    filled: true,
                    onPressed: onDone,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: _AnswerButton(
                    label: 'MISSED',
                    icon: Icons.close,
                    color: AppColors.danger,
                    filled: false,
                    onPressed: onMissed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The link into whatever sits behind a step. Deliberately quieter than the
/// two answers: it is a detour, not the decision the card is asking for.
class _DetailLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DetailLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: AppShapes.control(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: ShapeDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            shape: AppShapes.control(
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.45),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fitness_center, size: 15, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.panelTitle.copyWith(
                  fontSize: 11,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One of the two answers. Filled = the reward path, outlined = the honest
/// admission; both are one tap, because making "missed" harder to press would
/// just teach you to lie to the app.
class _AnswerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool filled;
  final VoidCallback onPressed;

  const _AnswerButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.filled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final shape = AppShapes.control(
      side: BorderSide(color: color.withValues(alpha: filled ? 1 : 0.55)),
    );

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: filled ? 0.92 : 0.08),
        shape: shape,
        shadows: [
          if (filled)
            BoxShadow(
              color: color.withValues(alpha: 0.32),
              blurRadius: 16,
              spreadRadius: -4,
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: filled ? AppColors.background : color,
                ),
                const SizedBox(width: 6),
                // Flexible + ellipsis: these two buttons sit side by side in a
                // fixed-width card, and a wide letter-spaced label is the
                // classic thing that overflows by a pixel or two at 360dp.
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.panelTitle.copyWith(
                      fontSize: 12,
                      letterSpacing: 1.5,
                      color: filled ? AppColors.background : color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A slow glow pulse on the active card.
///
/// Two seconds per cycle and only a few percent of opacity — enough that the
/// eye lands on it first, not so much that it nags. Reversing the controller
/// forever costs nothing while the widget is on screen and stops automatically
/// when it isn't.
class _Breathing extends StatefulWidget {
  final Widget child;

  const _Breathing({required this.child});

  @override
  State<_Breathing> createState() => _BreathingState();
}

class _BreathingState extends State<_Breathing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.88, end: 1.0).animate(_controller),
      child: widget.child,
    );
  }
}
