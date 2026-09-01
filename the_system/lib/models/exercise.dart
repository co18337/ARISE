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

/// Where a movement happens.
///
/// On the session card so the day tells you where to go before you leave the
/// house. Gym access arrived in September 2026 — the plan document predates
/// it and its home-equipment shopping list is obsolete.
enum Venue {
  gym('GYM'),

  /// A floor and nothing else. Planks, dead bugs, push-ups, the warm-up and
  /// the cool-down.
  ///
  /// This exists because tagging them `gym` was wrong and had a real
  /// consequence: week one looked like it needed a membership when every
  /// movement in it needs a patch of carpet.
  home('HOME'),

  /// The park's pull-up bar, and the ground under it.
  park('PARK'),

  /// Roads and the park loop. Running and sprinting.
  outdoor('OUTDOOR');

  final String label;

  const Venue(this.label);
}

/// Which part of the body a movement loads, in the terms the body-composition
/// scan reports.
///
/// Deliberately the SCAN's vocabulary rather than an anatomy chart's: the
/// whole point is that a segment rated below average can be given more volume,
/// and that only works if the exercise library and the report agree on what a
/// "trunk" is.
enum BodyRegion {
  trunk('TRUNK'),
  upperBody('UPPER BODY'),
  lowerBody('LOWER BODY'),
  wholeBody('WHOLE BODY');

  final String label;

  const BodyRegion(this.label);
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

  /// Where to do it. Gym, park bar, or out on the road.
  final Venue venue;

  /// Which segment of the scan it loads, so a trunk rated below average can be
  /// given more of the session. See BodyEmphasis.
  final BodyRegion region;

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
    required this.venue,
    required this.region,
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
