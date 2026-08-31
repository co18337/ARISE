import 'stat_type.dart';

/// What part of the programme an exercise belongs to.
///
/// Split by MOVEMENT rather than by muscle, because that is how a weekly plan
/// is actually built: a day is "push and core", not "pectorals and rectus
/// abdominis".
enum ExerciseKind {
  cardio('CARDIO'),
  core('CORE'),
  push('PUSH'),
  pull('PULL'),
  legs('LEGS'),

  /// Neck and jaw work. In the plan because of the specific goal of a defined
  /// jawline — it is posture and neck strength, not a fat-loss mechanism.
  neck('NECK'),

  mobility('MOBILITY');

  final String label;

  const ExerciseKind(this.label);
}

/// How one set of an exercise is measured.
enum LoadUnit {
  reps('reps'),
  seconds('sec'),
  minutes('min'),
  metres('m');

  final String label;

  const LoadUnit(this.label);
}

/// One movement in the exercise library.
///
/// Immutable reference data. What you actually DO on a given day is a
/// [SetPrescription] built from this plus your history — the exercise itself
/// carries no notion of "today".
class Exercise {
  final String id;
  final String name;
  final ExerciseKind kind;

  /// Which stat completing it feeds. Cardio builds STA, lifting builds STR.
  final StatType stat;

  final LoadUnit unit;

  /// One line on how to do it properly. Shown on the set card, because a cue
  /// you read while resting is worth more than an instruction page you never
  /// open.
  final String cue;

  /// Starting prescription for someone who has never done it here.
  final int startSets;
  final int startTarget;

  /// How much one step of progression adds to the target.
  final int step;

  /// Where the target stops growing and sets are added instead.
  final int targetCeiling;

  /// Filename of a demonstration animation in assets/exercises, without the
  /// extension — e.g. `pullups`. Null until artwork exists for it.
  ///
  /// A slot rather than a requirement: the app has to be usable before every
  /// movement has a picture, and the written cue is the fallback. See
  /// assets/exercises/README.md for what a file needs to be.
  final String? demoAsset;

  const Exercise({
    required this.id,
    required this.name,
    required this.kind,
    required this.stat,
    required this.unit,
    required this.cue,
    required this.startSets,
    required this.startTarget,
    required this.step,
    required this.targetCeiling,
    this.demoAsset,
  });
}
