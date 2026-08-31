import 'package:drift/drift.dart';

import '../../game/game.dart';
import '../../models/models.dart';
import '../day_key.dart';
import '../db/database.dart';
import '../exercise_catalog.dart';
import '../memory/memory_repository.dart';
import '../training_plan.dart';

/// One prescribed set, as the UI sees it.
class WorkoutSetView {
  final int id;
  final int setIndex;
  final int target;
  final int? actual;
  final bool done;

  const WorkoutSetView({
    required this.id,
    required this.setIndex,
    required this.target,
    required this.actual,
    required this.done,
  });
}

/// One exercise within a session, with all of its sets.
class WorkoutExerciseView {
  final Exercise exercise;
  final List<WorkoutSetView> sets;

  const WorkoutExerciseView({required this.exercise, required this.sets});

  int get setsDone => sets.where((s) => s.done).length;
  bool get complete => sets.isNotEmpty && setsDone == sets.length;

  /// The prescription line, e.g. "3 × 12 reps".
  String get summary =>
      '${sets.length} × ${sets.isEmpty ? 0 : sets.first.target} '
      '${exercise.unit.label}';
}

/// A whole training session as the screen renders it.
class WorkoutSessionView {
  final int id;
  final DateTime date;
  final TrainingPhase phase;
  final int week;
  final String focus;
  final DateTime? completedAt;
  final List<WorkoutExerciseView> exercises;

  /// What the trainer recalled when this session was issued.
  final List<String> notes;

  const WorkoutSessionView({
    required this.id,
    required this.date,
    required this.phase,
    required this.week,
    required this.focus,
    required this.completedAt,
    required this.exercises,
    this.notes = const [],
  });

  bool get isRestDay => exercises.isEmpty;
  bool get isComplete => completedAt != null;

  int get totalSets => exercises.fold(0, (n, e) => n + e.sets.length);
  int get setsDone => exercises.fold(0, (n, e) => n + e.setsDone);

  /// Every set answered — which is what makes the session finishable.
  bool get allSetsDone => totalSets > 0 && setsDone == totalSets;

  double get fraction => totalSets == 0 ? 0 : setsDone / totalSets;
}

/// The only thing the UI talks to for training data.
///
/// Owns the same job QuestRepository does for quests: materialise the day
/// lazily, stream it, and record what happened. The decision of WHAT to
/// prescribe is not here — that is [TrainerAdvisor], so it can be swapped for
/// an LLM-backed one without touching storage or widgets.
class WorkoutRepository {
  final AppDatabase db;
  final Clock clock;
  final TrainerAdvisor advisor;

  /// Where a finished session is written down so the trainer can remember it.
  ///
  /// Optional, and nullable rather than a no-op default, so tests that care
  /// only about sets do not have to build a corpus. When it IS supplied this
  /// closes the loop: prescribe, train, remember, prescribe better.
  final MemoryRepository? memory;

  WorkoutRepository(
    this.db, {
    this.clock = const Clock(),
    this.advisor = const RuleBasedTrainer(),
    this.memory,
  });

  /// Streams the session for [date], re-emitting on every set ticked.
  ///
  /// A JOIN rather than a query on workout_sessions that then reads its sets:
  /// drift re-emits a watched query when a table THAT QUERY READS changes, and
  /// ticking a set touches workout_sets only. Watching the session row alone
  /// meant the screen never updated when you logged anything.
  Stream<WorkoutSessionView?> watchSession(DateTime date) {
    final key = dayKeyOf(date);

    final query = db.select(db.workoutSessions).join([
      leftOuterJoin(
        db.workoutSets,
        db.workoutSets.sessionId.equalsExp(db.workoutSessions.id),
      ),
    ])
      ..where(db.workoutSessions.day.equals(key))
      ..orderBy([
        OrderingTerm.asc(db.workoutSets.orderIndex),
        OrderingTerm.asc(db.workoutSets.setIndex),
      ]);

    return query.watch().map((rows) {
      if (rows.isEmpty) return null;
      final session = rows.first.readTable(db.workoutSessions);
      // leftOuterJoin: a session with no sets yields one row with a null set.
      final sets = [
        for (final row in rows)
          if (row.readTableOrNull(db.workoutSets) != null)
            row.readTable(db.workoutSets),
      ];
      return _toView(session, sets);
    });
  }

  /// Creates today's session from the plan if it does not exist yet.
  ///
  /// Returns null on a rest day — the plan genuinely asks for nothing, which
  /// is different from an empty session.
  Future<WorkoutSessionView?> openSession(DateTime date) async {
    final key = dayKeyOf(date);

    final existing = await _readSession(key);
    if (existing != null) return existing;

    final startDay = await _programmeStartDay(key);
    final week = programmeWeek(startDay: startDay, day: key);
    final plan = await advisor.planSession(
      weekday: date.weekday,
      week: week,
      clearedByExercise: await clearedByExercise(before: key),
    );

    if (plan.isRestDay) return null;

    await db.transaction(() async {
      final sessionId = await db.into(db.workoutSessions).insert(
            WorkoutSessionsCompanion.insert(
              day: key,
              phase: plan.phase,
              week: plan.week,
              focus: plan.focus,
              notes: Value(
                plan.notes.isEmpty ? null : plan.notes.join('\n'),
              ),
            ),
          );

      await db.batch((b) {
        for (final (order, item) in plan.items.indexed) {
          for (var setIndex = 1; setIndex <= item.sets; setIndex++) {
            b.insert(
              db.workoutSets,
              WorkoutSetsCompanion.insert(
                sessionId: sessionId,
                exerciseId: item.exercise.id,
                orderIndex: order,
                setIndex: setIndex,
                target: item.target,
              ),
            );
          }
        }
      });
    });

    // Read the rows back directly rather than awaiting the first value from
    // watchSession: a stream's first event does not arrive promptly inside
    // flutter_test's fake-async zone, and the screen would sit on its loading
    // state forever.
    return _readSession(key);
  }

  /// One-shot read of a day's session, or null if there isn't one.
  Future<WorkoutSessionView?> _readSession(int day) async {
    final session = await (db.select(db.workoutSessions)
          ..where((s) => s.day.equals(day)))
        .getSingleOrNull();
    if (session == null) return null;

    final sets = await (db.select(db.workoutSets)
          ..where((s) => s.sessionId.equals(session.id))
          ..orderBy([
            (s) => OrderingTerm.asc(s.orderIndex),
            (s) => OrderingTerm.asc(s.setIndex),
          ]))
        .get();

    return _toView(session, sets);
  }

  /// Ticks or un-ticks one set. [actual] defaults to the target, because the
  /// overwhelmingly common case is doing exactly what was asked.
  Future<void> setDone(int setId, bool done, {int? actual}) async {
    final row = await (db.select(db.workoutSets)
          ..where((s) => s.id.equals(setId)))
        .getSingle();

    await (db.update(db.workoutSets)..where((s) => s.id.equals(setId))).write(
      WorkoutSetsCompanion(
        done: Value(done),
        actual: Value(done ? (actual ?? row.target) : null),
        completedAt: Value(done ? clock.now() : null),
      ),
    );
  }

  /// Marks the session finished, and remembers it.
  Future<void> completeSession(int sessionId) async {
    await (db.update(db.workoutSessions)..where((s) => s.id.equals(sessionId)))
        .write(WorkoutSessionsCompanion(completedAt: Value(clock.now())));

    final store = memory;
    if (store == null) return;

    final session = await (db.select(db.workoutSessions)
          ..where((s) => s.id.equals(sessionId)))
        .getSingleOrNull();
    if (session == null) return;

    final view = await _readSession(session.day);
    if (view == null) return;

    // Written as prose rather than as numbers, because what reads it next is
    // a language model, and "3 of 3 sets at 30 sec — completed" retrieves far
    // better than a row of integers.
    await store.rememberSession(
      day: session.day,
      phase: session.phase.label,
      week: session.week,
      focus: session.focus,
      lines: [
        for (final exercise in view.exercises)
          '${exercise.exercise.name}: ${exercise.setsDone} of '
              '${exercise.sets.length} sets at '
              '${exercise.sets.isEmpty ? 0 : exercise.sets.first.target} '
              '${exercise.exercise.unit.label}'
              '${exercise.complete ? ' — completed' : ' — cut short'}.',
      ],
    );
  }

  /// How many past sessions completed each exercise in FULL.
  ///
  /// This is the entire input to progressive overload: an exercise you
  /// finished every set of is one you have earned the right to be asked more
  /// of. A partly-finished exercise counts for nothing, deliberately — a
  /// prescription that grows on half-done work grows past you.
  Future<Map<String, int>> clearedByExercise({required int before}) async {
    final rows = await (db.select(db.workoutSets).join([
      innerJoin(
        db.workoutSessions,
        db.workoutSessions.id.equalsExp(db.workoutSets.sessionId),
      ),
    ])..where(db.workoutSessions.day.isSmallerThanValue(before)))
        .get();

    // (day, exerciseId) -> [total, done]
    final tally = <String, List<int>>{};
    for (final row in rows) {
      final set = row.readTable(db.workoutSets);
      final session = row.readTable(db.workoutSessions);
      final key = '${session.day}|${set.exerciseId}';
      final entry = tally.putIfAbsent(key, () => [0, 0]);
      entry[0]++;
      if (set.done) entry[1]++;
    }

    final cleared = <String, int>{};
    tally.forEach((key, counts) {
      if (counts[0] > 0 && counts[0] == counts[1]) {
        final exerciseId = key.split('|')[1];
        cleared[exerciseId] = (cleared[exerciseId] ?? 0) + 1;
      }
    });
    return cleared;
  }

  /// The day the programme started, recorded on first use so phase and week
  /// are counted from a fixed point rather than drifting with the clock.
  Future<int> _programmeStartDay(int today) async {
    final player = await (db.select(db.playerStates)
          ..where((p) => p.id.equals(0)))
        .getSingle();
    final existing = player.programmeStartDay;
    if (existing != null) return existing;

    await (db.update(db.playerStates)..where((p) => p.id.equals(0)))
        .write(PlayerStatesCompanion(programmeStartDay: Value(today)));
    return today;
  }

  WorkoutSessionView _toView(
    WorkoutSessionRow session,
    List<WorkoutSetRow> sets,
  ) {
    final byExercise = <String, List<WorkoutSetRow>>{};
    final order = <String, int>{};
    for (final s in sets) {
      byExercise.putIfAbsent(s.exerciseId, () => []).add(s);
      order.putIfAbsent(s.exerciseId, () => s.orderIndex);
    }

    final ids = byExercise.keys.toList()
      ..sort((a, b) => order[a]!.compareTo(order[b]!));

    return WorkoutSessionView(
      id: session.id,
      date: dateOfDayKey(session.day),
      phase: session.phase,
      week: session.week,
      focus: session.focus,
      completedAt: session.completedAt,
      notes: (session.notes ?? '')
          .split('\n')
          .where((n) => n.trim().isNotEmpty)
          .toList(),
      exercises: [
        for (final id in ids)
          if (ExerciseCatalog.byId(id) != null)
            WorkoutExerciseView(
              exercise: ExerciseCatalog.byId(id)!,
              sets: [
                for (final s in byExercise[id]!..sort(
                      (a, b) => a.setIndex.compareTo(b.setIndex),
                    ))
                  WorkoutSetView(
                    id: s.id,
                    setIndex: s.setIndex,
                    target: s.target,
                    actual: s.actual,
                    done: s.done,
                  ),
              ],
            ),
      ],
    );
  }
}
