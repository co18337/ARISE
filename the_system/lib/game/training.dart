/// The training engine: which phase you are in, and what today's session
/// should ask of you.
///
/// Pure, like the rest of lib/game — no database, no Flutter, no clock of its
/// own. The programme itself (which exercises on which weekday) is DATA and
/// lives in lib/data/training_plan.dart; what lives here are the rules that
/// turn the plan plus your history into a concrete prescription.
library;

import '../models/models.dart';
import 'body_emphasis.dart';

/// Who wrote the note above today's session.
enum TrainerNoteSource {
  /// No note at all.
  none('', ''),

  /// Passages lifted straight out of the corpus. True, but not written.
  history('THE SYSTEM REMEMBERS', 'from your own record'),

  /// Written by the model from those same passages.
  model('YOUR TRAINER SAYS', 'written from your record');

  final String heading;
  final String caption;

  const TrainerNoteSource(this.heading, this.caption);
}

/// The stages of the programme.
///
/// Built around one specific goal: a body-composition scan showing fat carried
/// around the trunk, and a jawline to bring out. So it starts cardio-only,
/// stays fat-loss dominant for three months, and only then begins loading the
/// lifts — rather than starting with a generic full-body split.
enum TrainingPhase {
  /// Weeks 1-2. Running, stretching and a floor. NO GYM.
  ///
  /// Split out of RESET on the athlete's own instruction: turning up is the
  /// only objective of a first fortnight, and a body that has not run in years
  /// has no business under a barbell in week one. It also matches the plan
  /// document, which asks for "basic movement" — the previous version had a
  /// gym session on the Wednesday of week one, which was mine, not the plan's.
  groundwork(
    label: 'GROUNDWORK',
    startWeek: 1,
    endWeek: 2,
    focus: 'Running and stretching. Nothing else.',
    benchmark: 'Run 15 minutes without stopping · hold a 30-second plank',
  ),

  /// Weeks 3-4. The gym enters, on two days, light.
  reset(
    label: 'RESET',
    startWeek: 3,
    endWeek: 4,
    focus: 'The lifts are introduced, lightly',
    benchmark: 'Run 20 minutes without stopping · hang 30 seconds',
  ),

  /// Weeks 5-16. The five-day split, sprints, and the lifts get real.
  fatBurn(
    label: 'FAT BURN',
    startWeek: 5,
    endWeek: 16,
    focus: 'Fat loss leads, strength enters',
    benchmark: 'Run 5 km · 15 push-ups · 3 negative pull-ups',
  ),

  /// Weeks 17-36. Muscle and recomposition. The first pull-up lands here.
  buildSculpt(
    label: 'BUILD & SCULPT',
    startWeek: 17,
    endWeek: 36,
    focus: 'Muscle, trunk, recomposition',
    benchmark: 'First full pull-up · 30 push-ups',
  ),

  /// Week 37 on. The full programme, driven by overload.
  sharpen(
    label: 'SHARPEN',
    startWeek: 37,
    endWeek: null,
    focus: 'Advanced physique, maintenance',
    benchmark: '5 km under 30 minutes · 50 push-ups · 12 pull-ups',
  );

  final String label;
  final int startWeek;

  /// Last week of the phase, or null for the final open-ended one.
  final int? endWeek;

  final String focus;

  /// What leaving this phase is supposed to look like, in plain words.
  ///
  /// Shown, not enforced by itself — [PhaseGate] is what enforces it. Stated
  /// because a phase you cannot see the end of is one you stop believing in.
  final String benchmark;

  const TrainingPhase({
    required this.label,
    required this.startWeek,
    required this.endWeek,
    required this.focus,
    required this.benchmark,
  });

  /// The phase a given programme WEEK allows, counting from week 1.
  ///
  /// The week is a FLOOR, not a promotion. What you actually train is decided
  /// by [PhaseGate.reached], which also requires the work to have been done —
  /// see the note there for why the calendar alone is the wrong trigger.
  static TrainingPhase forWeek(int week) {
    final w = week < 1 ? 1 : week;
    for (final phase in TrainingPhase.values.reversed) {
      if (w >= phase.startWeek) return phase;
    }
    return TrainingPhase.groundwork;
  }

  TrainingPhase? get next {
    final i = index + 1;
    return i < TrainingPhase.values.length ? TrainingPhase.values[i] : null;
  }

  /// Sessions that must be completed IN FULL before this phase is earned.
  ///
  /// Roughly two-thirds of the sessions the phase before it offers — six
  /// training days a week, minus the ones real life takes. Missing a third of
  /// your sessions and still advancing is how week 5 becomes an injury.
  int get sessionsRequired => switch (this) {
    TrainingPhase.groundwork => 0,
    // Roughly two-thirds of what the phase before it offers, at six training
    // days a week. Two weeks of groundwork offers twelve; eight of them earns
    // the gym.
    TrainingPhase.reset => 8,
    TrainingPhase.fatBurn => 16,
    TrainingPhase.buildSculpt => 64,
    TrainingPhase.sharpen => 160,
  };
}

/// Whether a phase has actually been earned, and what is still missing.
///
/// The engine used to advance on the calendar alone: week 5 arrived and the
/// programme handed over a five-day split whether or not you could jog for
/// twenty minutes. For somebody starting at three push-ups that is precisely
/// how week five becomes an injury or a quit.
///
/// So a phase now needs BOTH — the weeks to have passed AND the sessions to
/// have been done. Time alone cannot promote you, and neither can volume: a
/// fortnight of heroics does not compress a four-week base.
class PhaseGate {
  /// The phase the calendar would allow on its own.
  final TrainingPhase byCalendar;

  /// The phase actually earned.
  final TrainingPhase reached;

  /// Sessions completed in full, ever.
  final int sessionsDone;

  const PhaseGate({
    required this.byCalendar,
    required this.reached,
    required this.sessionsDone,
  });

  /// True when the weeks have passed but the work has not been done.
  bool get isHeldBack => byCalendar.index > reached.index;

  /// How many more full sessions the next phase needs, or zero.
  int get sessionsRemaining {
    final next = reached.next;
    if (next == null) return 0;
    final short = next.sessionsRequired - sessionsDone;
    return short < 0 ? 0 : short;
  }

  /// One line for the session card, or null when nothing is being held back.
  String? get holdReason {
    if (!isHeldBack) return null;
    final missing = sessionsRemaining;
    return missing <= 0
        ? null
        : 'Still on ${reached.label}: $missing more completed '
              '${missing == 1 ? 'session' : 'sessions'} to earn '
              '${reached.next?.label ?? ''}.';
  }

  /// Resolves the phase from the calendar and the record together.
  static PhaseGate resolve({
    required int week,
    required int sessionsCompleted,
  }) {
    final byCalendar = TrainingPhase.forWeek(week);

    var reached = TrainingPhase.groundwork;
    for (final phase in TrainingPhase.values) {
      final earned =
          week >= phase.startWeek &&
          sessionsCompleted >= phase.sessionsRequired;
      if (earned) reached = phase;
    }

    return PhaseGate(
      byCalendar: byCalendar,
      reached: reached,
      sessionsDone: sessionsCompleted,
    );
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
SetPrescription prescribeFor(
  Exercise exercise, {
  required int clearedSessions,
  /// Extra sets earned by [BodyEmphasis] — 0 or 1. Applied on top of the
  /// double-progression result rather than folded into it, so the emphasis
  /// can change between scans without disturbing the overload history.
  int extraSets = 0,
}) {
  final cleared = clearedSessions < 0 ? 0 : clearedSessions;

  final span = exercise.targetCeiling - exercise.startTarget;
  final maxTargetSteps = exercise.step <= 0 ? 0 : span ~/ exercise.step;

  final targetSteps = cleared < maxTargetSteps ? cleared : maxTargetSteps;

  final earnedSets = cleared - maxTargetSteps;
  final progressionSets = earnedSets <= 0 ? 0 : (earnedSets > 2 ? 2 : earnedSets);

  return SetPrescription(
    exercise: exercise,
    sets: exercise.startSets +
        progressionSets +
        (extraSets < 0 ? 0 : (extraSets > 1 ? 1 : extraSets)),
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

  /// Where [notes] came from. Shown on screen, because a note the model wrote
  /// and a passage copied out of your history deserve different trust.
  final TrainerNoteSource noteSource;

  /// Why this phase and not the next one. Null when nothing is being held
  /// back, which is the normal case.
  final PhaseGate? gate;

  /// One line saying which regions the last scan put the extra work into.
  final String? emphasisReason;

  const SessionPlan({
    required this.phase,
    required this.week,
    required this.focus,
    required this.items,
    this.notes = const [],
    this.noteSource = TrainerNoteSource.none,
    this.gate,
    this.emphasisReason,
  });

  /// A plain-language description of today, for the trainer to comment on.
  String get summary => [
    '$focus session, ${phase.label} phase, week $week.',
    for (final item in items)
      '${item.exercise.name}: ${item.summary}.',
  ].join('\n');

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

    /// Sessions completed in full, ever. Half of what decides the phase — see
    /// [PhaseGate]. Optional so a caller that does not track it still gets a
    /// working session rather than a compile error.
    int sessionsCompleted = 0,

    /// Which regions the last body scan says to favour.
    BodyEmphasis emphasis = BodyEmphasis.none,
  });
}
