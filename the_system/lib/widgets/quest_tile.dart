import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/theme.dart';

/// One quest row: a chamfered checkbox, the title, and its XP value.
///
/// Completing it fires a short burst: the row flashes cyan and a "+10 XP"
/// floats upward and fades. That half-second of feedback is the entire point
/// of Phase 2 — it's what makes ticking a box feel like a reward.
class QuestTile extends StatefulWidget {
  final DailyTask task;
  final ValueChanged<bool> onChanged;
  final Color accent;

  const QuestTile({
    super.key,
    required this.task,
    required this.onChanged,
    this.accent = AppColors.primary,
  });

  @override
  State<QuestTile> createState() => _QuestTileState();
}

// SingleTickerProviderStateMixin supplies the `vsync` an AnimationController
// needs — it ties the animation to the screen's refresh rate so it pauses
// when this widget is off-screen instead of burning battery.
class _QuestTileState extends State<QuestTile> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  /// Glow strength: snaps up fast, then decays slowly — the shape of a real
  /// flash. A plain 0->1 tween would look like a slow fade-in instead.
  late final Animation<double> _pulse = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
      weight: 20,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
      weight: 80,
    ),
  ]).animate(_controller);

  /// Drives the "+XP" text's upward travel and fade.
  late final Animation<double> _rise = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  @override
  void dispose() {
    _controller.dispose(); // controllers hold a ticker; leaking one leaks frames
    super.dispose();
  }

  void _handleTap() {
    final bool next = !widget.task.done;
    widget.onChanged(next);
    if (next) {
      _controller.forward(from: 0);
    } else {
      _controller.reset(); // un-checking shouldn't leave a glow behind
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final bool done = widget.task.done;
        final double pulse = _pulse.value;

        return Stack(
          // Clip.none lets the "+XP" text float up outside the row's bounds.
          clipBehavior: Clip.none,
          children: [
            _buildRow(done, pulse),
            if (_controller.isAnimating) _buildFloatingXp(),
          ],
        );
      },
    );
  }

  Widget _buildRow(bool done, double pulse) {
    final Color accent = widget.accent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
          decoration: BoxDecoration(
            // Completed rows keep a faint tint; the pulse adds a brighter
            // wash on top that fades out.
            color: Color.lerp(
              done ? accent.withValues(alpha: 0.06) : Colors.transparent,
              accent.withValues(alpha: 0.20),
              pulse,
            ),
            border: Border(
              left: BorderSide(
                color: done ? accent.withValues(alpha: 0.5 + 0.5 * pulse) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              _CheckBox(done: done, pulse: pulse, accent: accent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.task.template.title,
                  style: AppTextStyles.questTitle.copyWith(
                    color: done ? AppColors.textDim : AppColors.textPrimary,
                    decoration: done ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.textDim,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '+${widget.task.template.xp} XP',
                style: AppTextStyles.xpBadge.copyWith(
                  color: done ? accent : AppColors.textDim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The "+10 XP" that floats up and fades after completing a quest.
  Widget _buildFloatingXp() {
    final double t = _rise.value;
    return Positioned(
      right: 10,
      top: 6 - (28 * t), // travels upward as t goes 0 -> 1
      child: IgnorePointer(
        child: Opacity(
          opacity: (1.0 - t).clamp(0.0, 1.0),
          child: Text(
            '+${widget.task.template.xp} XP',
            style: AppTextStyles.xpBadge.copyWith(
              color: widget.accent,
              fontSize: 15,
              shadows: [BoxShadow(color: widget.accent, blurRadius: 12)],
            ),
          ),
        ),
      ),
    );
  }
}

/// A small chamfered checkbox that glows when ticked.
class _CheckBox extends StatelessWidget {
  final bool done;
  final double pulse;
  final Color accent;

  const _CheckBox({required this.done, required this.pulse, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: ShapeDecoration(
        color: done ? accent.withValues(alpha: 0.22) : Colors.transparent,
        shape: ChamferBorder(
          cut: 6,
          side: BorderSide(
            color: done ? accent : AppColors.primaryDim,
            width: 1.5,
          ),
        ),
        shadows: [
          if (done)
            BoxShadow(
              color: accent.withValues(alpha: 0.4 + 0.6 * pulse),
              blurRadius: 6 + 10 * pulse,
            ),
        ],
      ),
      child: done
          ? Icon(Icons.check, size: 15, color: accent)
          : const SizedBox.shrink(),
    );
  }
}
