import '../game/body_emphasis.dart';
import '../game/training.dart';
import '../models/models.dart';
import 'exercise_catalog.dart';

/// What each day of the week asks for, in each phase. The plan as DATA.
///
/// Explicit per weekday rather than "pick two exercises of kind X": a routine
/// you can predict is a routine you can turn up for, and Wednesday always
/// being intervals is worth more than variety.
class DayTemplate {
  /// Short name shown as today's headline, e.g. "INTERVALS".
  final String focus;

  /// Exercise ids, in the order they should be performed.
  final List<String> exerciseIds;

  const DayTemplate(this.focus, this.exerciseIds);

  static const DayTemplate rest = DayTemplate('REST', []);
}

/// The programme itself.
class TrainingPlan {
  TrainingPlan._();

  /// Neck work and the cool-down are appended to every training day rather
  /// than repeated in each template below.
  static const List<String> _everySession = ['chin_tucks', 'cooldown_stretch'];

  /// Weekday 1 = Monday … 7 = Sunday, matching DateTime.weekday.
  static const Map<TrainingPhase, Map<int, DayTemplate>> _byPhase = {
    // RESET — weeks 1-4. Endurance base and learning the movements.
    //
    // No sprinting yet and no barbell yet. Hill strides are the on-ramp to
    // sprint work: short, uphill, well short of maximum, walk all the way back
    // down. Somebody at three push-ups has no sprint base, and a hamstring
    // torn in week two costs more weeks than the strides do.
    //
    // Walking is NOT a session here or anywhere. It survives only as the
    // recovery inside an interval.
    TrainingPhase.reset: {
      1: DayTemplate('EASY MILES', ['dynamic_warmup', 'steady_run']),
      2: DayTemplate('STRIDES & HANG', [
        'dynamic_warmup',
        'hill_strides',
        'dead_hang',
      ]),
      3: DayTemplate('FULL BODY', [
        'dynamic_warmup',
        'goblet_squat',
        'incline_pushups',
        'lat_pulldown',
        'plank',
      ]),
      4: DayTemplate('EASY MILES', ['dynamic_warmup', 'steady_run', 'plank']),
      5: DayTemplate('STRIDES & TRUNK', [
        'dynamic_warmup',
        'hill_strides',
        'dead_bug',
        'side_plank',
      ]),
      6: DayTemplate('LONG EASY', ['dynamic_warmup', 'long_run']),
      7: DayTemplate.rest,
    },

    // FAT BURN — weeks 5-16. The five-day split, and sprints replace strides.
    TrainingPhase.fatBurn: {
      1: DayTemplate('PUSH', [
        'dynamic_warmup',
        'bench_press',
        'db_shoulder_press',
        'pushups',
        'tricep_pushdown',
      ]),
      2: DayTemplate('SPRINTS & PULL', [
        'dynamic_warmup',
        'sprint_interval',
        'dead_hang',
        'negative_pullup',
        'seated_row',
      ]),
      3: DayTemplate('LEGS & SHOULDERS', [
        'dynamic_warmup',
        'leg_press',
        'goblet_squat',
        'walking_lunge',
        'lat_raise',
      ]),
      4: DayTemplate('RUN & TRUNK', [
        'dynamic_warmup',
        'steady_run',
        'side_plank',
        'dead_bug',
        'hanging_knee_raise',
      ]),
      5: DayTemplate('HIIT & ARMS', [
        'dynamic_warmup',
        'sprint_interval',
        'bicep_curls',
        'tricep_pushdown',
        'jumping_jacks',
      ]),
      6: DayTemplate('LONG RUN', ['dynamic_warmup', 'long_run']),
      7: DayTemplate.rest,
    },

    // BUILD & SCULPT — weeks 17-36. The first full pull-up lands here, and
    // trunk work moves from bracing into loaded rotation and carries.
    TrainingPhase.buildSculpt: {
      1: DayTemplate('PUSH', [
        'dynamic_warmup',
        'bench_press',
        'db_shoulder_press',
        'assisted_dips',
        'lat_raise',
      ]),
      2: DayTemplate('SPRINTS & PULL', [
        'dynamic_warmup',
        'sprint_interval',
        'assisted_pullup',
        'seated_row',
        'face_pull',
      ]),
      3: DayTemplate('LEGS & POSTERIOR', [
        'dynamic_warmup',
        'goblet_squat',
        'romanian_deadlift',
        'hip_thrust',
        'leg_curl',
      ]),
      4: DayTemplate('RUN & TRUNK', [
        'dynamic_warmup',
        'steady_run',
        'cable_woodchop',
        'farmer_carry',
        'hanging_knee_raise',
      ]),
      5: DayTemplate('HIIT & ARMS', [
        'dynamic_warmup',
        'sprint_interval',
        'bicep_curls',
        'tricep_pushdown',
        'calf_raise',
      ]),
      6: DayTemplate('LONG RUN', ['dynamic_warmup', 'long_run']),
      7: DayTemplate.rest,
    },

    // SHARPEN — week 37 on. The full programme, overload-driven.
    TrainingPhase.sharpen: {
      1: DayTemplate('PUSH', [
        'dynamic_warmup',
        'bench_press',
        'db_shoulder_press',
        'assisted_dips',
        'pushups',
      ]),
      2: DayTemplate('PULL', [
        'dynamic_warmup',
        'pullups',
        'seated_row',
        'face_pull',
        'bicep_curls',
      ]),
      3: DayTemplate('LEGS', [
        'dynamic_warmup',
        'goblet_squat',
        'romanian_deadlift',
        'walking_lunge',
        'calf_raise',
      ]),
      4: DayTemplate('SPRINTS & TRUNK', [
        'dynamic_warmup',
        'sprint_interval',
        'cable_woodchop',
        'farmer_carry',
        'hanging_knee_raise',
      ]),
      5: DayTemplate('UPPER & CORE', [
        'dynamic_warmup',
        'pullups',
        'pushups',
        'lat_raise',
        'side_plank',
      ]),
      6: DayTemplate('LONG RUN', ['dynamic_warmup', 'long_run']),
      7: DayTemplate.rest,
    },
  };

  static DayTemplate templateFor(TrainingPhase phase, int weekday) =>
      _byPhase[phase]?[weekday] ?? DayTemplate.rest;

  /// The exercises today asks for, resolved and in order.
  static List<Exercise> exercisesFor(TrainingPhase phase, int weekday) {
    final template = templateFor(phase, weekday);
    if (template.exerciseIds.isEmpty) return const [];

    final ids = [
      ...template.exerciseIds,
      // Appended, and de-duplicated in case a template already names one.
      for (final id in _everySession)
        if (!template.exerciseIds.contains(id)) id,
    ];

    return [
      for (final id in ids)
        if (ExerciseCatalog.byId(id) != null) ExerciseCatalog.byId(id)!,
    ];
  }
}

/// The advisor that ships: the phase plan plus double progression.
///
/// Deliberately has no idea the LLM exists. When the Gemini trainer arrives it
/// implements the same [TrainerAdvisor] interface and can fall back to exactly
/// this when the network is gone.
class RuleBasedTrainer implements TrainerAdvisor {
  const RuleBasedTrainer();

  @override
  Future<SessionPlan> planSession({
    required int weekday,
    required int week,
    required Map<String, int> clearedByExercise,
    int sessionsCompleted = 0,
    BodyEmphasis emphasis = BodyEmphasis.none,
  }) async {
    // The phase is what has been EARNED, not what the calendar allows. Week 5
    // arriving is not the same as being ready for week 5, and for somebody
    // starting at three push-ups the difference is an injury.
    final gate = PhaseGate.resolve(
      week: week,
      sessionsCompleted: sessionsCompleted,
    );
    final phase = gate.reached;

    final template = TrainingPlan.templateFor(phase, weekday);
    final exercises = TrainingPlan.exercisesFor(phase, weekday);

    return SessionPlan(
      phase: phase,
      week: week,
      focus: template.focus,
      items: [
        for (final exercise in exercises)
          prescribeFor(
            exercise,
            clearedSessions: clearedByExercise[exercise.id] ?? 0,
            // The scan's weak segment earns one extra set on the movements
            // that load it — never on the warm-up or the cool-down, which are
            // not where volume belongs.
            extraSets: exercise.kind == ExerciseKind.mobility
                ? 0
                : emphasis.extraSetsFor(exercise.region),
          ),
      ],
      gate: gate.isHeldBack ? gate : null,
      emphasisReason: emphasis.hasPriority ? emphasis.reason : null,
    );
  }
}
