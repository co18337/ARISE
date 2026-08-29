import 'package:flutter/material.dart';

/// Fades and lifts a widget into place, staggered by its position in a list.
///
/// Panels arriving one after another reads as the System *drawing* the window,
/// which is the whole feeling being aimed at. Everything appearing at once in
/// a single frame reads as a page load.
///
/// No AnimationController: a shared duration with a per-index [Interval] curve
/// produces the stagger, and because the tween's end never changes after the
/// first build it plays exactly once rather than replaying on every rebuild.
class HudEntrance extends StatelessWidget {
  final int index;
  final Widget child;

  /// How far up the child travels as it fades in.
  final double offset;

  const HudEntrance({
    super.key,
    required this.index,
    required this.child,
    this.offset = 14,
  });

  @override
  Widget build(BuildContext context) {
    // Cap the delay so a long list doesn't leave the last panel waiting.
    final double start = (index * 0.07).clamp(0.0, 0.55);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 620),
      curve: Interval(start, 1, curve: Curves.easeOutCubic),
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * offset),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
