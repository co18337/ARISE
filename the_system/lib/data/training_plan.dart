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
    // Month one: running and walking only, exactly as planned. No lifting,
    // nothing technical — turning up daily is the only objective.
    TrainingPhase.ignite: {
      1: DayTemplate('ENDURANCE', ['steady_run']),
      2: DayTemplate('EASY MILES', ['brisk_walk']),
      3: DayTemplate('INTERVALS', ['sprint_interval']),
      4: DayTemplate('EASY MILES', ['brisk_walk']),
      5: DayTemplate('ENDURANCE', ['steady_run']),
      6: DayTemplate('INTERVALS', ['sprint_interval']),
      7: DayTemplate('RECOVERY', ['brisk_walk']),
    },

    // Months two and three: cardio still leads, core and pushing join it.
    TrainingPhase.reduce: {
      1: DayTemplate('RUN & CORE', ['steady_run', 'plank', 'situps']),
      2: DayTemplate('PUSH', ['incline_pushups', 'pushups', 'leg_raises']),
      3: DayTemplate('INTERVALS', ['sprint_interval', 'jumping_jacks']),
      4: DayTemplate('CORE', ['plank', 'situps', 'leg_raises']),
      5: DayTemplate('RUN & PUSH', ['steady_run', 'pushups']),
      6: DayTemplate('INTERVALS', ['sprint_interval', 'plank']),
      7: DayTemplate('RECOVERY', ['brisk_walk']),
    },

    // Months four to six: pulling and legs arrive, cardio drops to three days.
    TrainingPhase.build: {
      1: DayTemplate('PUSH', ['pushups', 'bench_press', 'plank']),
      2: DayTemplate('INTERVALS', ['sprint_interval', 'leg_raises']),
      3: DayTemplate('PULL', ['inverted_rows', 'pullups', 'bicep_curls']),
      4: DayTemplate('RUN & CORE', ['steady_run', 'situps']),
      5: DayTemplate('LEGS', ['bodyweight_squats', 'lunges', 'plank']),
      6: DayTemplate('INTERVALS', ['sprint_interval', 'jumping_jacks']),
      7: DayTemplate('RECOVERY', ['brisk_walk']),
    },

    // Week 25 on: the full split, driven by progressive overload.
    TrainingPhase.forge: {
      1: DayTemplate('PUSH', ['bench_press', 'pushups', 'plank']),
      2: DayTemplate('PULL', ['pullups', 'inverted_rows', 'bicep_curls']),
      3: DayTemplate('INTERVALS', ['sprint_interval', 'leg_raises']),
      4: DayTemplate('LEGS', ['bodyweight_squats', 'lunges']),
      5: DayTemplate('PUSH & CORE', ['bench_press', 'situps', 'plank']),
      6: DayTemplate('ENDURANCE', ['steady_run', 'jumping_jacks']),
      7: DayTemplate('RECOVERY', ['brisk_walk', 'cooldown_stretch']),
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
  }) async {
    final phase = TrainingPhase.forWeek(week);
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
          ),
      ],
    );
  }
}
