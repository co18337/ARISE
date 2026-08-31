import 'package:flutter/material.dart';

import '../data/exercise_guides.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import 'exercise_demo.dart';

/// "How do I actually do this?" — numbered steps and the muscles worked.
///
/// The answer to having to search the internet mid-session. Text rather than
/// an animation, because the animations for these movements belong to someone
/// else; see assets/exercises/README.md.
class ExerciseGuideSheet extends StatelessWidget {
  final Exercise exercise;

  const ExerciseGuideSheet({super.key, required this.exercise});

  /// Opens the sheet. Returns immediately for an exercise with no guide, so
  /// callers do not have to check first.
  static Future<void> show(BuildContext context, Exercise exercise) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ExerciseGuideSheet(exercise: exercise),
    );
  }

  @override
  Widget build(BuildContext context) {
    final guide = ExerciseGuides.forExercise(exercise.id);

    return DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, controller) => DecoratedBox(
        decoration: ShapeDecoration(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadii.panel),
            ),
            side: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.4),
            ),
          ),
        ),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textDim,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExerciseDemo(exercise: exercise, size: 72),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: AppTextStyles.display.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        exercise.cue,
                        style: AppTextStyles.body.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (guide == null)
              Text(
                'No step-by-step guide for this one. The cue above is the '
                'whole technique — it is a simple movement.',
                style: AppTextStyles.body,
              )
            else ...[
              _Muscles(guide: guide),
              const SizedBox(height: 16),
              Text('HOW TO', style: AppTextStyles.panelTitle),
              const SizedBox(height: 10),
              for (final (i, step) in guide.steps.indexed) ...[
                _Step(number: i + 1, text: step),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 8),
              Text(
                'Instructions from the exercises-dataset project, MIT licensed.',
                style: AppTextStyles.hudLabel.copyWith(fontSize: 8),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Muscles extends StatelessWidget {
  final ExerciseGuide guide;

  const _Muscles({required this.guide});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _Tag(label: guide.target, primary: true),
        for (final muscle in guide.secondaryMuscles) _Tag(label: muscle),
        if (guide.equipment.isNotEmpty) _Tag(label: guide.equipment),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final bool primary;

  const _Tag({required this.label, this.primary = false});

  @override
  Widget build(BuildContext context) {
    final color = primary ? AppColors.accentGold : AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.10),
        shape: AppShapes.pill(
          side: BorderSide(color: color.withValues(alpha: 0.45)),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.hudLabel.copyWith(fontSize: 9, color: color),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final int number;
  final String text;

  const _Step({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            shape: CircleBorder(
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
          ),
          child: Text(
            '$number',
            style: AppTextStyles.counter.copyWith(
              fontSize: 11,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: AppTextStyles.body.copyWith(fontSize: 13)),
        ),
      ],
    );
  }
}
