import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Step-by-step instructions for a movement.
class ExerciseGuide {
  final String sourceName;
  final String equipment;
  final String bodyPart;
  final String target;
  final List<String> secondaryMuscles;
  final List<String> steps;

  /// The Gym visual media id this movement corresponds to.
  ///
  /// Recorded, not downloaded. The animation media in the source repository is
  /// © Gym visual and explicitly NOT licensed by cloning it — see
  /// assets/exercises/README.md. If a licence is ever obtained, this is the
  /// file to drop in, and nothing else has to change.
  final String gymVisualMedia;

  /// The exercises-dataset id for this movement (e.g. `0652` for a pull-up).
  /// The same id in both source repositories, and what the on-demand fetcher
  /// asks for.
  String get datasetId => gymVisualMedia;

  const ExerciseGuide({
    required this.sourceName,
    required this.equipment,
    required this.bodyPart,
    required this.target,
    required this.secondaryMuscles,
    required this.steps,
    required this.gymVisualMedia,
  });
}

/// Instructions for the movements in our catalog, from the MIT-licensed half
/// of the exercises-dataset project.
///
/// Only confident matches were taken. An exercise with no clean equivalent in
/// that dataset keeps its hand-written cue and has no guide here — a wrong set
/// of instructions is worse than none, especially for a bench press.
class ExerciseGuides {
  ExerciseGuides._();

  static const String assetPath = 'assets/exercises/guides.json';

  static Map<String, ExerciseGuide>? _cache;

  /// Loaded once from the asset bundle. Called at startup so the first
  /// TRAINING screen does not have to wait on I/O.
  static Future<void> load() async {
    if (_cache != null) return;
    try {
      final raw = await rootBundle.loadString(assetPath);
      final decoded = jsonDecode(raw) as Map<String, Object?>;
      final guides = decoded['guides'] as Map<String, Object?>? ?? {};

      _cache = {
        for (final entry in guides.entries)
          entry.key: _parse(entry.value as Map<String, Object?>),
      };
    } catch (_) {
      // A missing or malformed guide file must never stop the app: every
      // exercise still has its own cue.
      _cache = const {};
    }
  }

  static ExerciseGuide _parse(Map<String, Object?> json) => ExerciseGuide(
    sourceName: json['sourceName'] as String? ?? '',
    equipment: json['equipment'] as String? ?? '',
    bodyPart: json['bodyPart'] as String? ?? '',
    target: json['target'] as String? ?? '',
    secondaryMuscles: [
      for (final m in (json['secondaryMuscles'] as List? ?? [])) m as String,
    ],
    steps: [for (final s in (json['steps'] as List? ?? [])) s as String],
    gymVisualMedia: json['gymVisualMedia'] as String? ?? '',
  );

  /// The guide for an exercise id, or null if there isn't a trustworthy one.
  static ExerciseGuide? forExercise(String exerciseId) => _cache?[exerciseId];

  static bool get isLoaded => _cache != null;

  static int get count => _cache?.length ?? 0;

  /// Test seam.
  static void overrideForTest(Map<String, ExerciseGuide> guides) =>
      _cache = guides;
}
