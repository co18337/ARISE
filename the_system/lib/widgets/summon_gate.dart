import 'package:flutter/material.dart';

import '../data/repositories/player_repository.dart';
import '../theme/theme.dart';
import 'gradient_button.dart';
import 'system_panel.dart';

/// The System window: status, then ARISE.
///
/// The day's session already exists behind this — the rule engine built it the
/// moment the day opened. This does not create anything; it is the moment you
/// ACCEPT it, and it is where the trainer gets its one chance to speak.
///
/// That ordering is deliberate. A ceremony that creates the work is a ceremony
/// that can lose you the work; this one can fail completely and you still have
/// a session waiting underneath.
class SummonGate extends StatefulWidget {
  final PlayerSnapshot? player;

  /// Sessions finished, ever. Says plainly how much the trainer has to go on.
  final int sessionsRecorded;

  /// What today asks for, in one line.
  final String focus;
  final int week;

  /// Runs the summoning. Returns when the session is accepted.
  final Future<void> Function() onArise;

  const SummonGate({
    super.key,
    required this.player,
    required this.sessionsRecorded,
    required this.focus,
    required this.week,
    required this.onArise,
  });

  /// Filename of the summoning animation, if it has been placed in assets.
  ///
  /// Gitignored — anime footage, local use only. The gate works without it.
  static const String animation = 'assets/solo-leveling-arise.gif';

  @override
  State<SummonGate> createState() => _SummonGateState();
}

class _SummonGateState extends State<SummonGate> {
  bool _summoning = false;

  /// The animation runs for at least this long once tapped, so a fast call
  /// does not make the whole thing flash past unseen.
  /// The floor, not the length.
  ///
  /// It was a flat 2.2 seconds, which made every summoning take 2.2 seconds
  /// even when there was nothing to wait for. Now the WORK sets the pace and
  /// this only stops it flashing past: a first summon with a live trainer call
  /// naturally lands around three or four seconds, and a cached or rule-based
  /// one finishes in under one. That is the behaviour without special-casing
  /// either — the ceremony is exactly as long as the System is actually
  /// thinking.
  static const Duration _minimumCeremony = Duration(milliseconds: 900);

  Future<void> _arise() async {
    if (_summoning) return;
    setState(() => _summoning = true);

    // The call and the animation run together: the ceremony IS the loading
    // state, which is why a pause here reads as the System thinking rather
    // than as a screen that has stopped working.
    await Future.wait([
      widget.onArise(),
      Future<void>.delayed(_minimumCeremony),
    ]);

    if (mounted) setState(() => _summoning = false);
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;

    return SystemPanel(
      accent: AppColors.accentMagenta,
      glow: 0.5,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _summoning ? 'SUMMONING' : 'THE SYSTEM',
            textAlign: TextAlign.center,
            style: AppTextStyles.hudLabel.copyWith(
              color: AppColors.accentMagenta,
              letterSpacing: 5,
            ),
          ),
          const SizedBox(height: 16),
          // Given the width of the panel rather than a fixed 190dp, so the
          // summoning fills the screen it is supposed to command instead of
          // sitting in it as a stamp.
          LayoutBuilder(
            builder: (context, constraints) => _Sigil(
              playing: _summoning,
              size: constraints.maxWidth.clamp(220.0, 420.0),
            ),
          ),
          const SizedBox(height: 18),
          if (player != null) ...[
            _StatusLine('HUNTER', player.hunterName),
            _StatusLine('RANK', '${player.rank.label}  ·  LEVEL ${player.level}'),
            _StatusLine(
              'STREAK',
              player.currentStreak == 1
                  ? '1 day'
                  : '${player.currentStreak} days',
            ),
          ],
          _StatusLine('TODAY', '${widget.focus}  ·  WEEK ${widget.week}'),
          _StatusLine(
            'RECORD',
            widget.sessionsRecorded == 0
                ? 'no sessions yet'
                : '${widget.sessionsRecorded} sessions',
          ),
          const SizedBox(height: 16),
          if (widget.sessionsRecorded < 3)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                'The System is still learning you. Until there is a record to '
                'read, today comes from the programme alone.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(fontSize: 11),
              ),
            ),
          GradientButton(
            label: _summoning ? 'Summoning…' : 'Arise',
            icon: _summoning ? null : Icons.bolt,
            colors: [AppColors.accentMagenta, AppColors.accentGold],
            onPressed: _summoning ? null : _arise,
          ),
        ],
      ),
    );
  }
}

/// The summoning animation, framed rather than stretched.
///
/// Deliberately NOT full-screen. The source is 498x498 and square; filling a
/// 9:20 phone would crop away more than half the width and upscale more than
/// five times on a high-density screen, which looks exactly as bad as it
/// sounds. Framed at this size it is a sigil in a window — which is what it is
/// meant to be — and stays sharp.
class _Sigil extends StatelessWidget {
  final bool playing;

  final double size;

  const _Sigil({required this.playing, this.size = 260});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: size,
        height: size,
        decoration: ShapeDecoration(
          color: AppColors.surfaceRaised.withValues(alpha: 0.5),
          shape: CircleBorder(
            side: BorderSide(
              color: AppColors.accentMagenta.withValues(
                alpha: playing ? 0.95 : 0.45,
              ),
              width: playing ? 2 : 1,
            ),
          ),
          shadows: [
            BoxShadow(
              color: AppColors.accentMagenta.withValues(
                alpha: playing ? 0.55 : 0.2,
              ),
              blurRadius: playing ? 40 : 18,
              spreadRadius: playing ? 2 : -4,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            SummonGate.animation,
            fit: BoxFit.cover,
            // Decoded at display size rather than at source size: 117 frames
            // at 498px would otherwise be decoded in full, several times a
            // second, for a picture drawn at 190dp.
            cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
            gaplessPlayback: true,
            // The gate works without the animation — it is gitignored, so a
            // fresh clone simply has no file. A rank crest stands in.
            errorBuilder: (context, _, _) => Center(
              child: Icon(
                Icons.auto_awesome,
                size: 64,
                color: AppColors.accentMagenta.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  final String label;
  final String value;

  const _StatusLine(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 74,
            child: Text(
              label,
              style: AppTextStyles.hudLabel.copyWith(fontSize: 9),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.readout.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
