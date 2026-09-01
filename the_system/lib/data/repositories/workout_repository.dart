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

  /// Weight in half-kilos: suggested when the set is issued, corrected to
  /// whatever you actually loaded. Null for a movement that carries none.
  final int? loadHalfKg;

  /// Beyond the prescription — logged and rewarded, but never counted toward
  /// progressive overload.
  final bool isExtra;

  const WorkoutSetView({
    required this.id,
    required this.setIndex,
    required this.target,
    required this.actual,
    required this.done,
    this.isExtra = false,
    this.loadHalfKg,
  });

  /// Did more than was asked for.
  bool get exceeded => done && actual != null && actual! > target;
}

/// One exercise within a session, with all of its sets.
class WorkoutExerciseView {
  final Exercise exercise;
  final List<WorkoutSetView> sets;

  const WorkoutExerciseView({required this.exercise, required this.sets});

  List<WorkoutSetView> get prescribed =>
      [for (final s in sets) if (!s.isExtra) s];
  List<WorkoutSetView> get extra => [for (final s in sets) if (s.isExtra) s];

  int get setsDone => sets.where((s) => s.done).length;

  /// Complete means the PRESCRIPTION is complete. Extra sets are a bonus, not
  /// part of the bar.
  bool get complete =>
      prescribed.isNotEmpty && prescribed.every((s) => s.done);

  int get extraDone => extra.where((s) => s.done).length;

  /// How much more than asked was actually done, in the exercise's own unit.
  int get overshoot {
    var beyond = 0;
    for (final set in sets) {
      if (set.actual == null) continue;
      beyond += set.isExtra ? set.actual! : (set.actual! - set.target);
    }
    return beyond < 0 ? 0 : beyond;
  }

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

  /// What the trainer said when this session was issued.
  final List<String> notes;

  /// Whether those notes were written by the model or quoted from the record.
  final TrainerNoteSource noteSource;

  /// When ARISE was tapped. Null means the session is waiting to be summoned —
  /// it exists and is visible, but is not yours to start yet.
  final DateTime? summonedAt;

  const WorkoutSessionView({
    required this.id,
    required this.date,
    required this.phase,
    required this.week,
    required this.focus,
    required this.completedAt,
    required this.exercises,
    this.notes = const [],
    this.noteSource = TrainerNoteSource.none,
    this.summonedAt,
  });

  bool get isSummoned => summonedAt != null;

  bool get isRestDay => exercises.isEmpty;
  bool get isComplete => completedAt != null;

  int get totalSets => exercises.fold(0, (n, e) => n + e.prescribed.length);
  int get setsDone =>
      exercises.fold(0, (n, e) => n + e.prescribed.where((s) => s.done).length);

  /// Sets done beyond the prescription, across the whole session.
  int get extraSetsDone => exercises.fold(0, (n, e) => n + e.extraDone);

  /// Every PRESCRIBED set answered — which is what makes the session
  /// finishable. Extra work never stands in for work that was asked for.
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

    // The RULE engine builds the session, always. No network, no key, no
    // waiting — so a session exists before anything is summoned and survives
    // every failure the ceremony can have. summon() is what brings in the
    // trainer.
    final plan = await const RuleBasedTrainer().planSession(
      weekday: date.weekday,
      week: week,
      clearedByExercise: await clearedByExercise(before: key),
      // Both read from the record, both local, both cheap. The phase is what
      // has been EARNED rather than what the calendar allows, and the
      // emphasis comes from the last body scan's segment ratings.
      sessionsCompleted: await completedSessionCount(),
      emphasis: await readEmphasis(),
      records: await recordByExercise(before: key),
      deload: await deloadFor(date),
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
              noteSource: Value(plan.noteSource),
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
                // The suggestion travels with the set, so the card can show
                // what to load before you touch anything.
                loadHalfKg: Value(item.loadHalfKg),
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

  /// Accepts the day's session, and lets the trainer speak.
  ///
  /// One summon per day. Re-tapping returns the same session rather than
  /// generating a new one — otherwise you could reroll until you got an easy
  /// day, which would quietly destroy the point of accepting it at all.
  Future<WorkoutSessionView?> summon(DateTime date) async {
    final key = dayKeyOf(date);

    // Opens the day if nothing has yet. Summoning a day that was never opened
    // is a perfectly reasonable thing to do — it is the first thing that
    // happens on a rest-day-then-training-day — and failing on the ordering
    // would be an implementation detail leaking into the ceremony.
    var session = await (db.select(db.workoutSessions)
          ..where((s) => s.day.equals(key)))
        .getSingleOrNull();
    if (session == null) {
      await openSession(date);
      session = await (db.select(db.workoutSessions)
            ..where((s) => s.day.equals(key)))
          .getSingleOrNull();
    }
    final row = session;
    if (row == null) return null; // genuinely a rest day
    if (row.summonedAt != null) return _readSession(key);

    // The trainer runs HERE, not when the screen opens: this is the one moment
    // the user is expecting to wait, and a pause during a summoning reads as
    // the System thinking rather than as a broken list.
    var notes = <String>[];
    var source = TrainerNoteSource.none;
    try {
      final plan = await advisor.planSession(
        weekday: date.weekday,
        week: row.week,
        clearedByExercise: await clearedByExercise(before: key),
        sessionsCompleted: await completedSessionCount(),
        emphasis: await readEmphasis(),
        records: await recordByExercise(before: key),
        deload: await deloadFor(date),
      );
      notes = plan.notes;
      source = plan.noteSource;
    } catch (_) {
      // The session is already built and already yours. A trainer that cannot
      // be reached costs you a sentence, not a workout.
    }

    await (db.update(db.workoutSessions)..where((s) => s.id.equals(row.id)))
        .write(
      WorkoutSessionsCompanion(
        summonedAt: Value(clock.now()),
        notes: Value(notes.isEmpty ? null : notes.join('\n')),
        noteSource: Value(source),
      ),
    );

    return _readSession(key);
  }

  /// What the record says about every movement, for the progression rules.
  ///
  /// One pass over the set history rather than a query per exercise. Three
  /// things come out of it and each answers a different question: how many
  /// sessions were finished (may the prescription grow), what was last
  /// actually lifted (from what weight), and how far past the ask the recent
  /// sets landed (is the step the right size).
  ///
  /// EXTRA SETS ARE EXCLUDED throughout. Doing six sets where three were asked
  /// is not the prescription completed twice, and letting it count that way is
  /// how enthusiasm turns into an injury.
  Future<Map<String, ExerciseRecord>> recordByExercise({
    required int before,
  }) async {
    final rows = await (db.select(db.workoutSets).join([
      innerJoin(
        db.workoutSessions,
        db.workoutSessions.id.equalsExp(db.workoutSets.sessionId),
      ),
    ])..where(
        db.workoutSessions.day.isSmallerThanValue(before) &
            db.workoutSets.isExtra.equals(false),
      ))
        .get();

    final cleared = <String, int>{};
    final lastLoad = <String, int?>{};
    final lastDay = <String, int>{};
    final recent = <String, List<({int target, int? actual})>>{};
    final best = <String, int>{};

    for (final row in rows) {
      final set = row.readTable(db.workoutSets);
      final day = row.readTable(db.workoutSessions).day;
      if (!set.done) continue;

      cleared[set.exerciseId] = (cleared[set.exerciseId] ?? 0) + 1;
      final done = set.actual;
      if (done != null && done > (best[set.exerciseId] ?? 0)) {
        best[set.exerciseId] = done;
      }
      recent
          .putIfAbsent(set.exerciseId, () => [])
          .add((target: set.target, actual: set.actual));

      // The most RECENT weight, not the heaviest — a single heroic day should
      // not become the number every future session starts from.
      if (set.loadHalfKg != null &&
          day >= (lastDay[set.exerciseId] ?? -1 << 30)) {
        lastDay[set.exerciseId] = day;
        lastLoad[set.exerciseId] = set.loadHalfKg;
      }
    }

    return {
      for (final id in cleared.keys)
        id: ExerciseRecord(
          // Sets cleared, divided by the sets a session asks for — so the
          // count means SESSIONS, which is what progression is measured in.
          cleared: cleared[id]!,
          lastLoadHalfKg: lastLoad[id],
          // Only the last handful: a margin averaged over three months is a
          // description of who you used to be.
          margin: marginOf(recent[id]!.reversed.take(6)),
          bestActual: best[id],
        ),
    };
  }

  /// The deload in force this week, or null for a normal week.
  ///
  /// Decided ONCE and then recorded: a deload has to last the week rather
  /// than flickering as sessions are ticked off. Re-reading it later returns
  /// the same answer even if the history that triggered it changes, because
  /// you either had that week or you did not.
  Future<Deload?> deloadFor(DateTime date, {DeloadRule rule = const DeloadRule()}) async {
    final key = dayKeyOf(date);
    final monday = key - (date.weekday - DateTime.monday);

    final existing = await (db.select(db.deloads)
          ..where((d) => d.startDay.equals(monday)))
        .getSingleOrNull();
    if (existing != null) {
      return Deload(
        DeloadReason.values.firstWhere(
          (r) => r.name == existing.reason,
          orElse: () => DeloadReason.planned,
        ),
      );
    }

    final startDay = await _programmeStartDay(key);
    final week = programmeWeek(startDay: startDay, day: key);

    final previous = await (db.select(db.deloads)
          ..orderBy([(d) => OrderingTerm.desc(d.startDay)])
          ..limit(1))
        .getSingleOrNull();

    final decided = rule.forWeek(
      week: week,
      recentUnfinished: await _recentUnfinished(before: monday),
      weeksSinceLastDeload: previous == null
          ? null
          : ((monday - previous.startDay) / 7).floor(),
    );
    if (decided == null) return null;

    await db.into(db.deloads).insertOnConflictUpdate(
      DeloadsCompanion.insert(
        startDay: Value(monday),
        reason: decided.reason.name,
        decidedAt: clock.now(),
      ),
    );
    return decided;
  }

  /// Sessions from most recent backwards that were issued and left unfinished.
  ///
  /// Stops at the first COMPLETED one: the question is how many in a row, and
  /// a bad Tuesday three weeks ago is not part of this week's run.
  Future<int> _recentUnfinished({required int before}) async {
    final sessions = await (db.select(db.workoutSessions)
          ..where((s) => s.day.isSmallerThanValue(before))
          ..orderBy([(s) => OrderingTerm.desc(s.day)])
          ..limit(6))
        .get();

    var run = 0;
    for (final session in sessions) {
      if (session.completedAt != null) break;
      run++;
    }
    return run;
  }

  /// Where the programme stands: the phase earned, and what the next one
  /// still needs.
  ///
  /// Derived on read rather than stored. Both halves — the programme week and
  /// the completed-session count — already live in the database, and a cached
  /// copy of a derived value is one more thing that can disagree with itself.
  Future<PhaseGate> readGate(DateTime date) async {
    final key = dayKeyOf(date);
    return PhaseGate.resolve(
      week: programmeWeek(startDay: await _programmeStartDay(key), day: key),
      sessionsCompleted: await completedSessionCount(),
      records: await recordByExercise(before: key),
    );
  }

  /// Which regions the most recent body scan says to favour.
  ///
  /// Reads the segment ratings off the latest scan and hands them to the pure
  /// engine. Returns [BodyEmphasis.none] when there is no scan or the scan
  /// reported no segments — a bathroom scale gives one number, and the answer
  /// to that is an even programme, not a guess.
  Future<BodyEmphasis> readEmphasis() async {
    final latest =
        await (db.select(db.bodyMeasurements)
              ..orderBy([(m) => OrderingTerm.desc(m.day)])
              ..limit(1))
            .getSingleOrNull();
    if (latest == null) return BodyEmphasis.none;

    final segments = await (db.select(db.bodySegments)
          ..where((s) => s.day.equals(latest.day)))
        .get();
    if (segments.isEmpty) return BodyEmphasis.none;

    return BodyEmphasis.fromRatings(
      muscleRatings: {
        for (final s in segments)
          if (s.muscleRating != null) s.segment: s.muscleRating!,
      },
      fatRatings: {
        for (final s in segments)
          if (s.fatRating != null) s.segment: s.fatRating!,
      },
    );
  }

  /// Adds a set beyond the prescription.
  ///
  /// Deliberately unlimited. If you have another ten minutes in you, the app's
  /// job is to record it, not to argue. What it will NOT do is treat it as
  /// prescription completed — see WorkoutSets.isExtra.
  Future<void> addExtraSet(int sessionId, String exerciseId) async {
    final existing = await (db.select(db.workoutSets)
          ..where(
            (s) => s.sessionId.equals(sessionId) &
                s.exerciseId.equals(exerciseId),
          ))
        .get();
    if (existing.isEmpty) return;

    final template = existing.first;
    final highest =
        existing.map((s) => s.setIndex).reduce((a, b) => a > b ? a : b);

    await db.into(db.workoutSets).insert(
          WorkoutSetsCompanion.insert(
            sessionId: sessionId,
            exerciseId: exerciseId,
            orderIndex: template.orderIndex,
            setIndex: highest + 1,
            target: template.target,
            isExtra: const Value(true),
          ),
        );
  }

  /// Removes an extra set. Prescribed sets are not removable — they are the
  /// plan, and un-asking is not something the app should offer.
  Future<void> removeExtraSet(int setId) => (db.delete(db.workoutSets)
        ..where((s) => s.id.equals(setId) & s.isExtra.equals(true)))
      .go();

  /// Ticks or un-ticks one set. [actual] defaults to the target, because the
  /// overwhelmingly common case is doing exactly what was asked.
  Future<void> setDone(
    int setId,
    bool done, {
    int? actual,

    /// What was actually on the bar, in half-kilos. Null leaves whatever is
    /// already recorded — usually the suggestion — untouched.
    int? loadHalfKg,
  }) async {
    final row = await (db.select(db.workoutSets)
          ..where((s) => s.id.equals(setId)))
        .getSingle();

    await (db.update(db.workoutSets)..where((s) => s.id.equals(setId))).write(
      WorkoutSetsCompanion(
        done: Value(done),
        actual: Value(done ? (actual ?? row.target) : null),
        // The weight SURVIVES un-ticking a set. Unticking says "I had not
        // done this yet", not "I was never going to use that weight", and
        // losing it would mean re-entering it every time.
        loadHalfKg: loadHalfKg == null
            ? const Value.absent()
            : Value(loadHalfKg),
        completedAt: Value(done ? clock.now() : null),
      ),
    );
  }

  /// Records the weight on a set without changing whether it is done.
  Future<void> setLoad(int setId, int? loadHalfKg) =>
      (db.update(db.workoutSets)..where((s) => s.id.equals(setId))).write(
        WorkoutSetsCompanion(loadHalfKg: Value(loadHalfKg)),
      );

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

  /// How many sessions have been finished, ever.
  ///
  /// Shown during the summoning. The trainer is thin until there is material
  /// to reason over, and saying how much there is beats letting it produce
  /// hollow encouragement for a fortnight while you wonder if it is broken.
  Future<int> completedSessionCount() async {
    final rows = await (db.select(db.workoutSessions)
          ..where((s) => s.completedAt.isNotNull()))
        .get();
    return rows.length;
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
    ])..where(
          db.workoutSessions.day.isSmallerThanValue(before) &
              // Extra sets are excluded from overload. Six sets when three were
              // asked for is not "completed the prescription three times over",
              // and treating it that way is how enthusiasm becomes an injury.
              db.workoutSets.isExtra.equals(false),
        ))
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
      noteSource: session.noteSource,
      summonedAt: session.summonedAt,
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
                    loadHalfKg: s.loadHalfKg,
                    isExtra: s.isExtra,
                  ),
              ],
            ),
      ],
    );
  }
}
