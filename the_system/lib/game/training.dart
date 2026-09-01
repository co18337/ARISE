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
import 'deload.dart';
import 'progression.dart';

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
  /// Stated because a phase you cannot see the end of is one you stop
  /// believing in. [tests] is the machine-checkable version of this sentence,
  /// and PhaseGate enforces THAT — the two must be kept saying the same thing.
  final String benchmark;

  /// What must actually have been done to leave: movement id, and the amount
  /// achieved in a single set.
  ///
  /// Checked against BEST EVER, not most recent. A benchmark asks what you are
  /// capable of, and one bad Tuesday does not take away a thing you have
  /// already proven.
  List<({String exerciseId, int atLeast})> get tests => switch (this) {
    TrainingPhase.groundwork => const [
      (exerciseId: 'steady_run', atLeast: 15),
      (exerciseId: 'plank', atLeast: 30),
    ],
    TrainingPhase.reset => const [
      (exerciseId: 'steady_run', atLeast: 20),
      (exerciseId: 'dead_hang', atLeast: 30),
    ],
    TrainingPhase.fatBurn => const [
      (exerciseId: 'steady_run', atLeast: 30),
      (exerciseId: 'pushups', atLeast: 15),
    ],
    TrainingPhase.buildSculpt => const [
      (exerciseId: 'pullups', atLeast: 1),
      (exerciseId: 'pushups', atLeast: 30),
    ],
    // Nothing to prove to leave the last phase; there is nowhere to go.
    TrainingPhase.sharpen => const [],
  };

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
    this.unmetTests = const [],
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
  ///
  /// Names the binding reason rather than listing every unmet condition — a
  /// hold you cannot act on is just a complaint.
  String? get holdReason {
    if (!isHeldBack) return null;
    final missing = sessionsRemaining;
    if (missing > 0) {
      return 'Still on ${reached.label}: $missing more completed '
          '${missing == 1 ? 'session' : 'sessions'} to earn '
          '${reached.next?.label ?? ''}.';
    }
    if (unmetTests.isNotEmpty) {
      return 'Still on ${reached.label}: the work is done, the benchmark is '
          'not — ${reached.benchmark}.';
    }
    return null;
  }

  /// Benchmarks of the phase you are on that are still unmet.
  final List<String> unmetTests;

  /// Resolves the phase from the calendar, the record and the benchmarks.
  ///
  /// THREE conditions now, all of them necessary. The weeks say enough time
  /// has passed for the adaptation to happen; the sessions say the work was
  /// actually done; the benchmark says it worked. Any two without the third
  /// promotes somebody who is not ready — which for a beginner is the
  /// difference between December 2027 and stopping in March.
  static PhaseGate resolve({
    required int week,
    required int sessionsCompleted,
    Map<String, ExerciseRecord> records = const {},
  }) {
    final byCalendar = TrainingPhase.forWeek(week);

    List<String> unmet(TrainingPhase phase) => [
      for (final test in phase.tests)
        if ((records[test.exerciseId]?.bestActual ?? 0) < test.atLeast)
          '${test.exerciseId} ${test.atLeast}',
    ];

    var reached = TrainingPhase.groundwork;
    for (final phase in TrainingPhase.values) {
      // To be IN a phase you must have cleared the one before it, benchmark
      // included. The first phase has nothing before it.
      final previous = phase.index == 0
          ? null
          : TrainingPhase.values[phase.index - 1];
      final earned =
          week >= phase.startWeek &&
          sessionsCompleted >= phase.sessionsRequired &&
          (previous == null ||
              (records.isEmpty ? true : unmet(previous).isEmpty));
      if (earned) reached = phase;
    }

    return PhaseGate(
      byCalendar: byCalendar,
      reached: reached,
      sessionsDone: sessionsCompleted,
      unmetTests: unmet(reached),
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
  /// Suggested weight in half-kilos, or null when the movement carries none
  /// or has never been performed. A suggestion, never an instruction — the
  /// number you actually lift is what gets recorded.
  final int? loadHalfKg;

  double? get loadKg => loadHalfKg == null ? null : loadHalfKg! / 2;

  final Exercise exercise;

  /// How many sets.
  final int sets;

  /// Reps, seconds, minutes or metres per set — see [Exercise.unit].
  final int target;

  const SetPrescription({
    required this.exercise,
    required this.sets,
    required this.target,
    this.loadHalfKg,
  });

  /// "3 × 12 reps", or "3 × 12 reps @ 27.5 kg" once there is a weight.
  String get summary {
    final base = '$sets × $target ${exercise.unit.label}';
    final kg = loadKg;
    if (kg == null) return base;
    return '$base @ ${kg == kg.roundToDouble() ? kg.toStringAsFixed(0) : kg} kg';
  }

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

  /// What the record says about this movement. Optional so a caller with no
  /// history still gets a sensible beginner's prescription.
  ExerciseRecord record = ExerciseRecord.none,

  /// The week's back-off. Cuts SETS only — reps and weight are held, so the
  /// week recovers without detraining what the block built.
  Deload? deload,
}) {
  final cleared = clearedSessions < 0 ? 0 : clearedSessions;

  final span = exercise.targetCeiling - exercise.startTarget;
  final maxTargetSteps = exercise.step <= 0 ? 0 : span ~/ exercise.step;

  // THE MARGIN, not just the tick. Finishing is binary; how far past the
  // prescription you finished is the thing that says whether the step is the
  // right size. Twelve-minute runs logged at seventeen mean the step is too
  // small, and counting only "completed" could never see that.
  //
  // Doubled or held, never more and never reversed: an accelerated step that
  // turns out to be wrong costs one hard session, and a halved one costs
  // nothing at all. Regression is a deload's job, not a step size's.
  final earned = record.isEasy
      ? cleared * 2
      : record.isHard
      ? cleared ~/ 2
      : cleared;

  final targetSteps = earned < maxTargetSteps ? earned : maxTargetSteps;

  final earnedSets = earned - maxTargetSteps;
  final progressionSets = earnedSets <= 0 ? 0 : (earnedSets > 2 ? 2 : earnedSets);

  return SetPrescription(
    exercise: exercise,
    sets: DeloadRule.setsFor(
      exercise.startSets +
          progressionSets +
          (extraSets < 0 ? 0 : (extraSets > 1 ? 1 : extraSets)),
      deload,
    ),
    target: exercise.startTarget + targetSteps * exercise.step,
    loadHalfKg: _loadFor(exercise, record, targetSteps, maxTargetSteps),
  );
}

/// The weight to suggest, in half-kilos, or null for an unloaded movement.
///
/// Taken from what was LAST ACTUALLY LIFTED rather than from a formula: the
/// app has no idea what you can bench, and inventing a number is how somebody
/// gets hurt on their first session. The first time, it says nothing and the
/// screen asks you to pick something you can control.
///
/// After that it is classic double progression: hold the weight while the reps
/// climb, and add one step once the reps top out — which is the moment the
/// weight, not the rep count, has become the thing holding you back.
int? _loadFor(
  Exercise exercise,
  ExerciseRecord record,
  int targetSteps,
  int maxTargetSteps,
) {
  if (!exercise.isLoaded) return null;
  final last = record.lastLoadHalfKg;
  if (last == null) return null;

  final atCeiling = maxTargetSteps > 0 && targetSteps >= maxTargetSteps;
  return atCeiling ? last + exercise.loadStepHalfKg : last;
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

  /// The week's back-off, if there is one.
  final Deload? deload;

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
    this.deload,
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

    /// What the record says about each movement: sessions cleared, weight last
    /// lifted, and how far past the ask recent sets landed. Optional, so a
    /// caller with no history still gets a beginner's session.
    Map<String, ExerciseRecord> records = const {},

    /// The week's back-off, if there is one. Null is a normal week.
    Deload? deload,
  });
}
