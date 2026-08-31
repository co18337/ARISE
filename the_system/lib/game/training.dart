/// The training engine: which phase you are in, and what today's session
/// should ask of you.
///
/// Pure, like the rest of lib/game — no database, no Flutter, no clock of its
/// own. The programme itself (which exercises on which weekday) is DATA and
/// lives in lib/data/training_plan.dart; what lives here are the rules that
/// turn the plan plus your history into a concrete prescription.
library;

import '../models/models.dart';

/// The stages of the programme.
///
/// Built around one specific goal: a body-composition scan showing fat carried
/// around the trunk, and a jawline to bring out. So it starts cardio-only,
/// stays fat-loss dominant for three months, and only then begins loading the
/// lifts — rather than starting with a generic full-body split.
enum TrainingPhase {
  /// Month one. Running and walking, nothing else. The point is to build the
  /// habit of turning up daily before anything technical is asked.
  ignite(
    label: 'IGNITE',
    startWeek: 1,
    endWeek: 4,
    focus: 'Cardio only — build the habit',
  ),

  /// Months two and three. Cardio still leads; core and bodyweight pushing
  /// join it.
  reduce(
    label: 'REDUCE',
    startWeek: 5,
    endWeek: 12,
    focus: 'Fat loss, with core and push',
  ),

  /// Months four to six. Pulling and legs arrive; the lifts get real.
  build(
    label: 'BUILD',
    startWeek: 13,
    endWeek: 24,
    focus: 'Compound strength enters',
  ),

  /// Everything after. The full programme, driven by progressive overload.
  forge(
    label: 'FORGE',
    startWeek: 25,
    endWeek: null,
    focus: 'Full programme, progressive overload',
  );

  final String label;
  final int startWeek;

  /// Last week of the phase, or null for the final open-ended one.
  final int? endWeek;

  final String focus;

  const TrainingPhase({
    required this.label,
    required this.startWeek,
    required this.endWeek,
    required this.focus,
  });

  /// The phase for a given programme week, counting from week 1.
  static TrainingPhase forWeek(int week) {
    final w = week < 1 ? 1 : week;
    for (final phase in TrainingPhase.values.reversed) {
      if (w >= phase.startWeek) return phase;
    }
    return TrainingPhase.ignite;
  }

  TrainingPhase? get next {
    final i = index + 1;
    return i < TrainingPhase.values.length ? TrainingPhase.values[i] : null;
  }
}

/// The programme week a given day falls in, counting from [startDay].
///
/// Both are integer day numbers (see lib/data/day_key.dart). Week 1 is the
/// first seven days, so day zero of the programme is already week 1 — nobody
/// thinks of their first session as "week zero".
int programmeWeek({required int startDay, required int day}) {
  final elapsed = day - startDay;
  if (elapsed < 0) return 1;
  return (elapsed ~/ 7) + 1;
}

/// What one exercise is asking of you today.
class SetPrescription {
  final Exercise exercise;

  /// How many sets.
  final int sets;

  /// Reps, seconds, minutes or metres per set — see [Exercise.unit].
  final int target;

  const SetPrescription({
    required this.exercise,
    required this.sets,
    required this.target,
  });

  /// "3 × 12 reps"
  String get summary => '$sets × $target ${exercise.unit.label}';

  /// Total work in the session, for a completion bar.
  int get totalUnits => sets * target;
}

/// Progressive overload, as a rule.
///
/// [clearedSessions] is how many past sessions of this exercise were completed
/// in full. The target grows by one step per clear until it hits the ceiling,
/// and only then do sets get added — the standard double-progression pattern.
/// Growing both at once compounds far too fast and buries you inside a month.
///
/// Sets stop at two above the starting count. Past that the answer is a harder
/// exercise, not a longer session, and the phase plan is what supplies one.
SetPrescription prescribeFor(Exercise exercise, {required int clearedSessions}) {
  final cleared = clearedSessions < 0 ? 0 : clearedSessions;

  final span = exercise.targetCeiling - exercise.startTarget;
  final maxTargetSteps = exercise.step <= 0 ? 0 : span ~/ exercise.step;

  final targetSteps = cleared < maxTargetSteps ? cleared : maxTargetSteps;
  final extraSets = cleared - maxTargetSteps;

  return SetPrescription(
    exercise: exercise,
    sets: exercise.startSets + (extraSets <= 0 ? 0 : (extraSets > 2 ? 2 : extraSets)),
    target: exercise.startTarget + targetSteps * exercise.step,
  );
}

/// A whole session: what today is, and everything it asks for.
class SessionPlan {
  final TrainingPhase phase;
  final int week;

  /// Short name for today, e.g. "INTERVALS" or "PUSH & CORE".
  final String focus;

  final List<SetPrescription> items;

  /// Short lines from the trainer — what it noticed in your history.
  ///
  /// Empty for the rule-based advisor, which has no memory. Filled by the
  /// memory-backed one, and later by the LLM. Kept on the plan rather than
  /// fetched by the screen so every advisor answers the same question.
  final List<String> notes;

  const SessionPlan({
    required this.phase,
    required this.week,
    required this.focus,
    required this.items,
    this.notes = const [],
  });

  bool get isRestDay => items.isEmpty;

  /// Which stats this session feeds, for the XP preview.
  Set<StatType> get stats => {for (final i in items) i.exercise.stat};
}

/// The seam the LLM trainer will slot into.
///
/// Everything the app uses goes through this interface, and the rule-based
/// implementation below is the one that ships. A future Gemini-backed advisor
/// implements the same method and can adjust the prescription using history it
/// has embedded — but the app has to keep working with the network switched
/// off (see CLAUDE.md), so the rule-based version is the floor, never a stub.
abstract class TrainerAdvisor {
  /// Asynchronous even though the rule-based implementation needs no await:
  /// retrieval hits the database and the LLM hits the network, and changing
  /// the signature later would ripple through every caller.
  Future<SessionPlan> planSession({
    required int weekday,
    required int week,
    required Map<String, int> clearedByExercise,
  });
}
