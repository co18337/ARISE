import 'package:flutter/material.dart';

/// A number that counts up to its new value instead of snapping to it.
///
/// Game HUDs animate their numbers, and it costs nothing: seeing XP tick from
/// 30 to 40 registers as "I earned 10" in a way that a value silently
/// changing never does.
///
/// TweenAnimationBuilder handles the hard part — when [value] changes it
/// animates from whatever was on screen, so no controller or state is needed.
class AnimatedCounter extends StatelessWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;

  /// Wraps the number, e.g. `(v) => '$v XP'`.
  final String Function(int)? format;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 550),
    this.format,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, shown, _) =>
          Text(format?.call(shown) ?? '$shown', style: style),
    );
  }
}
