import '../models/models.dart';

/// The exercise library.
///
/// Ordered roughly by when it enters the programme: cardio and core first,
/// then bodyweight pushing, then pulling and loaded lifts. See
/// lib/game/training.dart for which of these a given phase actually issues.
///
/// This is a TRAINING plan, not medical advice. The app schedules and records
/// work; interpreting body-composition or blood results stays with the doctor.
class ExerciseCatalog {
  ExerciseCatalog._();

  static final List<Exercise> all = [
    // --- Phase 1 is cardio-only, so these carry the whole first month.
    const Exercise(
      id: 'brisk_walk',
      name: 'Brisk walk',
      kind: ExerciseKind.cardio,
      stat: StatType.sta,
      unit: LoadUnit.minutes,
      cue: 'Fast enough that talking takes effort. Arms swinging.',
      startSets: 1,
      startTarget: 20,
      step: 5,
      targetCeiling: 45,
    ),
    const Exercise(
      id: 'steady_run',
      name: 'Steady run',
      kind: ExerciseKind.cardio,
      stat: StatType.sta,
      unit: LoadUnit.minutes,
      cue: 'Conversational pace. Land midfoot, under your hips.',
      startSets: 1,
      startTarget: 12,
      step: 3,
      targetCeiling: 40,
      demoAsset: 'steady_run',
    ),
    const Exercise(
      id: 'sprint_interval',
      name: 'Sprint intervals',
      kind: ExerciseKind.cardio,
      stat: StatType.sta,
      unit: LoadUnit.seconds,
      cue: 'Hard 20s, then walk until your breath is back. Never skip that.',
      startSets: 4,
      startTarget: 20,
      step: 5,
      targetCeiling: 40,
      demoAsset: 'sprint_interval',
    ),
    const Exercise(
      id: 'jumping_jacks',
      name: 'Jumping jacks',
      kind: ExerciseKind.cardio,
      stat: StatType.sta,
      unit: LoadUnit.reps,
      cue: 'Light on the feet. Keep a rhythm rather than racing.',
      startSets: 3,
      startTarget: 25,
      step: 5,
      targetCeiling: 60,
      demoAsset: 'jumping_jacks',
    ),

    // --- Core. Trunk is the priority area, so it starts early and stays.
    const Exercise(
      id: 'plank',
      name: 'Plank',
      kind: ExerciseKind.core,
      stat: StatType.str,
      unit: LoadUnit.seconds,
      cue: 'Ribs down, glutes tight. Stop when the hips sag, not when it hurts.',
      startSets: 3,
      startTarget: 30,
      step: 10,
      targetCeiling: 90,
    ),
    const Exercise(
      id: 'situps',
      name: 'Sit-ups',
      kind: ExerciseKind.core,
      stat: StatType.str,
      unit: LoadUnit.reps,
      cue: 'Curl up one vertebra at a time. Do not yank on your neck.',
      startSets: 3,
      startTarget: 12,
      step: 2,
      targetCeiling: 25,
      demoAsset: 'situps',
    ),
    const Exercise(
      id: 'leg_raises',
      name: 'Leg raises',
      kind: ExerciseKind.core,
      stat: StatType.str,
      unit: LoadUnit.reps,
      cue: 'Lower back stays flat on the floor the whole way down.',
      startSets: 3,
      startTarget: 10,
      step: 2,
      targetCeiling: 20,
      demoAsset: 'leg_raises',
    ),

    // --- Neck and jaw. Small, daily, and the reason the jawline goal is in
    // the plan at all rather than being left to fat loss alone.
    const Exercise(
      id: 'chin_tucks',
      name: 'Chin tucks',
      kind: ExerciseKind.neck,
      stat: StatType.rec,
      unit: LoadUnit.reps,
      cue: 'Slide the chin straight back, not down. Hold two seconds.',
      startSets: 2,
      startTarget: 10,
      step: 2,
      targetCeiling: 20,
    ),
    const Exercise(
      id: 'neck_extension',
      name: 'Neck extensions',
      kind: ExerciseKind.neck,
      stat: StatType.rec,
      unit: LoadUnit.reps,
      cue: 'Slow, small range. Never force the end of the movement.',
      startSets: 2,
      startTarget: 10,
      step: 2,
      targetCeiling: 20,
    ),

    // --- Push. Enters in phase 2.
    const Exercise(
      id: 'pushups',
      name: 'Push-ups',
      kind: ExerciseKind.push,
      stat: StatType.str,
      unit: LoadUnit.reps,
      cue: 'Body in one line. Elbows at 45 degrees, not flared out.',
      startSets: 3,
      startTarget: 8,
      step: 2,
      targetCeiling: 20,
      demoAsset: 'pushups',
    ),
    const Exercise(
      id: 'incline_pushups',
      name: 'Incline push-ups',
      kind: ExerciseKind.push,
      stat: StatType.str,
      unit: LoadUnit.reps,
      cue: 'Hands on a bench or table. The easier version — use it and build.',
      startSets: 3,
      startTarget: 10,
      step: 2,
      targetCeiling: 20,
      demoAsset: 'incline_pushups',
    ),
    const Exercise(
      id: 'bench_press',
      name: 'Bench press',
      kind: ExerciseKind.push,
      stat: StatType.str,
      unit: LoadUnit.reps,
      cue: 'Shoulder blades pinned back. Bar to mid-chest, no bounce.',
      startSets: 3,
      startTarget: 8,
      step: 1,
      targetCeiling: 12,
      demoAsset: 'bench_press',
    ),

    // --- Pull. Enters in phase 3.
    const Exercise(
      id: 'pullups',
      name: 'Pull-ups',
      kind: ExerciseKind.pull,
      stat: StatType.str,
      unit: LoadUnit.reps,
      cue: 'Start from a dead hang. Chest to the bar, shoulders down.',
      startSets: 3,
      startTarget: 3,
      step: 1,
      targetCeiling: 10,
      demoAsset: 'pullups',
    ),
    const Exercise(
      id: 'inverted_rows',
      name: 'Inverted rows',
      kind: ExerciseKind.pull,
      stat: StatType.str,
      unit: LoadUnit.reps,
      cue: 'Under a low bar, body straight. The scalable route to pull-ups.',
      startSets: 3,
      startTarget: 8,
      step: 2,
      targetCeiling: 15,
      demoAsset: 'inverted_rows',
    ),
    const Exercise(
      id: 'bicep_curls',
      name: 'Bicep curls',
      kind: ExerciseKind.pull,
      stat: StatType.str,
      unit: LoadUnit.reps,
      cue: 'Elbows pinned to your sides. No swinging from the hips.',
      startSets: 3,
      startTarget: 10,
      step: 2,
      targetCeiling: 15,
      demoAsset: 'bicep_curls',
    ),

    // --- Legs. Enters in phase 3.
    const Exercise(
      id: 'bodyweight_squats',
      name: 'Bodyweight squats',
      kind: ExerciseKind.legs,
      stat: StatType.str,
      unit: LoadUnit.reps,
      cue: 'Knees track over the toes. Sit back, chest up.',
      startSets: 3,
      startTarget: 15,
      step: 3,
      targetCeiling: 30,
    ),
    const Exercise(
      id: 'lunges',
      name: 'Lunges',
      kind: ExerciseKind.legs,
      stat: StatType.str,
      unit: LoadUnit.reps,
      cue: 'Per leg. Back knee toward the floor, front shin vertical.',
      startSets: 3,
      startTarget: 10,
      step: 2,
      targetCeiling: 20,
      demoAsset: 'lunges',
    ),

    // --- Mobility, every session.
    const Exercise(
      id: 'cooldown_stretch',
      name: 'Cool-down stretch',
      kind: ExerciseKind.mobility,
      stat: StatType.rec,
      unit: LoadUnit.minutes,
      cue: 'Hips, hamstrings, chest. Breathe out into each hold.',
      startSets: 1,
      startTarget: 5,
      step: 1,
      targetCeiling: 10,
      demoAsset: 'cooldown_stretch',
    ),
  ];

  static Exercise? byId(String id) {
    for (final e in all) {
      if (e.id == id) return e;
    }
    return null;
  }
}
