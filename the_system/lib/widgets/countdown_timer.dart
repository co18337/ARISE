import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// A live HH:MM:SS countdown to [target].
///
/// Used for "quests refresh in…" — a visible deadline is a far stronger nudge
/// than a static date, which is why it earns its own ticking timer.
class CountdownTimer extends StatefulWidget {
  final DateTime target;
  final String? label;
  final TextStyle? style;

  /// Called once when the countdown reaches zero — the screen usually wants
  /// to reissue the day at that point.
  final VoidCallback? onElapsed;

  const CountdownTimer({
    super.key,
    required this.target,
    this.label,
    this.style,
    this.onElapsed,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  late Duration _remaining;
  bool _fired = false;

  @override
  void initState() {
    super.initState();
    _remaining = _timeLeft();
    // One timer per second is enough; anything faster just burns battery for
    // digits nobody can read.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    // A periodic Timer keeps firing after the widget is gone unless cancelled,
    // which then calls setState on a dead State and throws.
    _timer?.cancel();
    super.dispose();
  }

  Duration _timeLeft() {
    final left = widget.target.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  void _tick() {
    final left = _timeLeft();
    if (!mounted) return;
    setState(() => _remaining = left);

    if (left == Duration.zero && !_fired) {
      _fired = true;
      widget.onElapsed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = _remaining.inHours;
    final m = _remaining.inMinutes.remainder(60);
    final s = _remaining.inSeconds.remainder(60);
    final text =
        '${_pad(h)}:${_pad(m)}:${_pad(s)}';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTextStyles.hudLabel),
          const SizedBox(width: 8),
        ],
        Text(text, style: widget.style ?? AppTextStyles.counter),
      ],
    );
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}

/// Local midnight tonight — when the day's quests roll over.
DateTime nextMidnight() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + 1);
}
