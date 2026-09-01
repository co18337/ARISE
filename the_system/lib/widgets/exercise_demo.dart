import 'package:flutter/material.dart';

import '../data/media/exercise_media.dart';
import '../data/media/media_store.dart';
import '../models/models.dart';
import '../theme/theme.dart';

/// Shows how a movement is actually performed.
///
/// Three sources, in order: the animation bundled with the app, one downloaded
/// earlier and kept on disk, or — when there is neither — the movement pattern
/// and its written cue. Flutter animates GIF and WebP natively, so no package
/// is involved.
class ExerciseDemo extends StatefulWidget {
  final Exercise exercise;
  final double size;

  /// Whether the animation runs.
  ///
  /// FALSE FOR EVERY CARD BUT THE ONE IN FRONT OF YOU, and that is a battery
  /// decision rather than an aesthetic one. Flutter animates a GIF for as long
  /// as its Image is mounted — there is no pause, only mount or do not. Five
  /// visible demonstrations at 25fps is 125 frame decodes a second for as long
  /// as the screen is open, and it measured 16% of a Motorola G34's battery.
  ///
  /// The 25fps is mine: re-timing the source from 4fps so the movements read
  /// as video multiplied that decode work sixfold. Right call for the look,
  /// wrong one to apply to every card at once.
  ///
  /// A still card falls back to the written cue, which is what every card
  /// showed before there was any artwork at all.
  final bool animate;

  const ExerciseDemo({
    super.key,
    required this.exercise,
    this.size = 96,
    this.animate = true,
  });

  @override
  State<ExerciseDemo> createState() => _ExerciseDemoState();
}

class _ExerciseDemoState extends State<ExerciseDemo> {
  /// Resolved once per card, and only for movements that are NOT bundled.
  /// A bundled one is known at build time and renders with no async hop, so
  /// the common case has no loading flicker.
  late final Future<DemoSource>? _resolving = widget.exercise.demoAsset != null
      ? null
      : ExerciseMedia.resolve(exerciseId: widget.exercise.id);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: AppColors.surfaceRaised.withValues(alpha: 0.6),
          shape: AppShapes.row(
            side: BorderSide(
              color: AppColors.primaryDim.withValues(alpha: 0.45),
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: AppRadii.rowRadius,
          child: _buildSource(),
        ),
      ),
    );
  }

  Widget _buildSource() {
    final bundled = ExerciseMedia.bundledAsset(widget.exercise.demoAsset);
    if (bundled != null) return _image(AssetImage(bundled));

    return FutureBuilder<DemoSource>(
      future: _resolving,
      builder: (context, snapshot) {
        final source = snapshot.data;
        if (source is CachedDemo && widget.animate) {
          // Null on web, where there is no file to show.
          final provider = fileImageProvider(source.filePath);
          if (provider != null) return _image(provider);
        }
        return _Placeholder(exercise: widget.exercise);
      },
    );
  }

  Widget _image(ImageProvider provider) {
    // Decode at the size it is actually drawn at. The source frames are
    // 360x360 and the card shows them at 78dp; without this, EVERY frame of
    // every animation is decoded full-size and then scaled down, which is real
    // work repeated eleven times a second per visible card.
    final pixels = (widget.size * MediaQuery.devicePixelRatioOf(context)).round();

    return RepaintBoundary(
      // The animation repaints constantly. Without a boundary it drags the
      // whole exercise card — title, cue, stat chip, set chips — into every
      // one of those repaints.
      child: Image(
        image: ResizeImage(
          provider,
          width: pixels,
          height: pixels,
          policy: ResizeImagePolicy.fit,
          allowUpscaling: false,
        ),
        fit: BoxFit.cover,
        width: widget.size,
        height: widget.size,
        // Holds the last frame while the next decodes, instead of blinking
        // back to empty between them.
        gaplessPlayback: true,
        filterQuality: FilterQuality.low,
        // A demo that fails to decode must not take the card with it — the cue
        // is still there underneath.
        errorBuilder: (context, _, _) => _Placeholder(exercise: widget.exercise),
      ),
    );
  }
}

/// What stands in until there is artwork: the movement pattern, which is most
/// of what the picture would carry anyway.
class _Placeholder extends StatelessWidget {
  final Exercise exercise;

  const _Placeholder({required this.exercise});

  static const Map<ExerciseKind, IconData> _icons = {
    ExerciseKind.cardio: Icons.directions_run,
    ExerciseKind.core: Icons.self_improvement,
    ExerciseKind.push: Icons.arrow_upward,
    ExerciseKind.pull: Icons.arrow_downward,
    ExerciseKind.legs: Icons.accessibility_new,
    ExerciseKind.neck: Icons.face_retouching_natural,
    ExerciseKind.mobility: Icons.spa_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icons[exercise.kind] ?? Icons.fitness_center,
            size: 26,
            color: AppColors.primary.withValues(alpha: 0.75),
          ),
          const SizedBox(height: 6),
          Text(
            exercise.kind.label,
            style: AppTextStyles.hudLabel.copyWith(fontSize: 8),
          ),
        ],
      ),
    );
  }
}
