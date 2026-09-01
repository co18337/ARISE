import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/exercise_catalog.dart';
import 'package:the_system/data/repositories/workout_repository.dart';
import 'package:the_system/data/training_plan.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';

void main() {
  group('phases', () {
    test('run to the weeks the transformation plan promises', () {
      // The plan's own phases and boundaries, with RESET split in two: the
      // first fortnight is running and stretching, and the gym enters at
      // week 3. That split is the athlete's own call about his body.
      expect(TrainingPhase.forWeek(1), TrainingPhase.groundwork);
      expect(TrainingPhase.forWeek(2), TrainingPhase.groundwork);
      expect(TrainingPhase.forWeek(3), TrainingPhase.reset);
      expect(TrainingPhase.forWeek(4), TrainingPhase.reset);
      expect(TrainingPhase.forWeek(5), TrainingPhase.fatBurn);
      expect(TrainingPhase.forWeek(16), TrainingPhase.fatBurn);
      expect(TrainingPhase.forWeek(17), TrainingPhase.buildSculpt);
      expect(TrainingPhase.forWeek(36), TrainingPhase.buildSculpt);
      expect(TrainingPhase.forWeek(37), TrainingPhase.sharpen);
      expect(TrainingPhase.forWeek(500), TrainingPhase.sharpen);
    });

    test('week zero and negative weeks clamp to the first phase', () {
      expect(TrainingPhase.forWeek(0), TrainingPhase.groundwork);
      expect(TrainingPhase.forWeek(-3), TrainingPhase.groundwork);
    });

    test('the programme week counts from day one, not day zero', () {
      expect(programmeWeek(startDay: 100, day: 100), 1);
      expect(programmeWeek(startDay: 100, day: 106), 1);
      expect(programmeWeek(startDay: 100, day: 107), 2);
      expect(programmeWeek(startDay: 100, day: 113), 2);
      // A day before the programme started is still week 1, not week -4.
      expect(programmeWeek(startDay: 100, day: 90), 1);
    });
  });

  group('what each phase issues', () {
    Set<String> idsIn(TrainingPhase phase) => {
      for (var weekday = 1; weekday <= 7; weekday++)
        ...TrainingPlan.exercisesFor(phase, weekday).map((e) => e.id),
    };

    test('GROUNDWORK is running and stretching, with NO gym at all', () {
      // The athlete's own instruction, and the thing the previous version got
      // wrong: it put a gym session on the Wednesday of week one.
      final venues = {
        for (var weekday = 1; weekday <= 7; weekday++)
          ...TrainingPlan.exercisesFor(
            TrainingPhase.groundwork,
            weekday,
          ).map((e) => e.venue),
      };
      expect(venues, isNot(contains(Venue.gym)),
          reason: 'week one needs no membership');

      final ids = idsIn(TrainingPhase.groundwork);
      expect(ids, contains('steady_run'));
      expect(ids, contains('long_run'));

      // Strides, NOT sprints. The on-ramp: short, uphill, full recovery.
      // Somebody starting at three push-ups has no sprint base to draw on.
      expect(ids, contains('hill_strides'));
      expect(ids, isNot(contains('sprint_interval')));
    });

    test('RESET introduces the gym on two days, not five', () {
      final gymDays = [
        for (var weekday = 1; weekday <= 7; weekday++)
          if (TrainingPlan.exercisesFor(TrainingPhase.reset, weekday)
              .any((e) => e.venue == Venue.gym))
            weekday,
      ];
      expect(gymDays, hasLength(2));

      // And running is untouched — it is still what the fat loss turns on.
      final ids = idsIn(TrainingPhase.reset);
      expect(ids, contains('steady_run'));
      expect(ids, contains('long_run'));
      // Still no barbell in month one.
      expect(ids, isNot(contains('bench_press')));
      expect(ids, isNot(contains('romanian_deadlift')));
    });

    test('sprints replace walking entirely, in every phase', () {
      // Walking is not a session anywhere. It survives only as the recovery
      // inside an interval, which is a cue rather than a prescription.
      for (final phase in TrainingPhase.values) {
        expect(idsIn(phase), isNot(contains('brisk_walk')),
            reason: phase.label);
      }
      expect(ExerciseCatalog.byId('brisk_walk'), isNull);

      // And sprints are in from FAT BURN onward.
      for (final phase in [
        TrainingPhase.fatBurn,
        TrainingPhase.buildSculpt,
        TrainingPhase.sharpen,
      ]) {
        expect(idsIn(phase), contains('sprint_interval'), reason: phase.label);
      }
    });

    test('nothing needs equipment that is not owned', () {
      // Gym access arrived in September 2026 and no home equipment was ever
      // bought. Anything band- or home-kit-shaped is a bug.
      for (final exercise in ExerciseCatalog.all) {
        expect(
          exercise.venue,
          isIn(const [Venue.gym, Venue.home, Venue.park, Venue.outdoor]),
          reason: exercise.id,
        );
        expect(exercise.id.contains('band'), isFalse, reason: exercise.id);
      }
    });

    test('the trunk gets worked in every phase — it is the scan\'s one weak '
        'segment', () {
      // Muscle rating -1 on the trunk, 0 on all four limbs. It is the single
      // most actionable line in the body-composition report.
      for (final phase in TrainingPhase.values) {
        final regions = {
          for (var weekday = 1; weekday <= 7; weekday++)
            ...TrainingPlan.exercisesFor(phase, weekday).map((e) => e.region),
        };
        expect(regions, contains(BodyRegion.trunk), reason: phase.label);
      }
    });

    test('trunk work starts as bracing, not sit-up volume', () {
      // 11.2 kg of the 20.2 kg of fat is on the trunk. Sit-ups neither build
      // the segment nor uncover it; bracing builds it and running uncovers it.
      final early = idsIn(TrainingPhase.reset);
      expect(early, contains('plank'));
      expect(early, contains('dead_bug'));
      expect(early, isNot(contains('situps')));
    });

    test('every phase has one true rest day', () {
      // The plan says Sunday full rest and means it — no recovery walk, no
      // neck work. Rest is a session the body does.
      for (final phase in TrainingPhase.values) {
        expect(TrainingPlan.exercisesFor(phase, 7), isEmpty,
            reason: phase.label);
      }
    });

    test('neck work and the cool-down are in every TRAINING session', () {
      for (final phase in TrainingPhase.values) {
        for (var weekday = 1; weekday <= 6; weekday++) {
          final ids =
              TrainingPlan.exercisesFor(phase, weekday).map((e) => e.id);
          expect(ids, contains('chin_tucks'),
              reason: '${phase.label} day $weekday');
          expect(ids, contains('cooldown_stretch'),
              reason: '${phase.label} day $weekday');
        }
      }
    });

    test('every template names an exercise that actually exists', () {
      // A typo in an id would silently drop the movement from the session.
      for (final phase in TrainingPhase.values) {
        for (var weekday = 1; weekday <= 7; weekday++) {
          for (final id in TrainingPlan.templateFor(phase, weekday).exerciseIds) {
            expect(ExerciseCatalog.byId(id), isNotNull, reason: id);
          }
        }
      }
    });
  });

  group('earning the next phase', () {
    test('the calendar alone cannot promote you', () {
      // Week 5 arriving is not the same as being ready for week 5. Somebody
      // who has done four sessions in five weeks is still in RESET.
      final gate = PhaseGate.resolve(week: 5, sessionsCompleted: 4);

      expect(gate.byCalendar, TrainingPhase.fatBurn);
      expect(gate.reached, TrainingPhase.groundwork);
      expect(gate.isHeldBack, isTrue);
      expect(gate.holdReason, contains('GROUNDWORK'));
      // Eight full sessions earn RESET; four have been done.
      expect(gate.sessionsRemaining, 4);
    });

    test('the work alone cannot promote you either', () {
      // A fortnight of heroics does not compress a four-week base.
      final gate = PhaseGate.resolve(week: 2, sessionsCompleted: 200);

      expect(gate.reached, TrainingPhase.groundwork);
      expect(gate.isHeldBack, isFalse, reason: 'the calendar agrees');
    });

    test('weeks and work together open the next phase', () {
      final gate = PhaseGate.resolve(week: 5, sessionsCompleted: 16);

      expect(gate.reached, TrainingPhase.fatBurn);
      expect(gate.isHeldBack, isFalse);
      expect(gate.holdReason, isNull);
    });

    test('a held-back session is issued from the phase actually earned',
        () async {
      // The point of the gate: it changes what you are handed, not just a
      // label. Five weeks in with four sessions done still gets RESET's
      // Monday, which is a run — not FAT BURN's bench press.
      final plan = await const RuleBasedTrainer().planSession(
        weekday: DateTime.monday,
        week: 5,
        clearedByExercise: const {},
        sessionsCompleted: 4,
      );

      expect(plan.phase, TrainingPhase.groundwork);
      expect(plan.items.map((i) => i.exercise.id), contains('steady_run'));
      expect(plan.items.map((i) => i.exercise.id), isNot(contains('bench_press')));
      expect(plan.gate?.isHeldBack, isTrue);
    });
  });

  group('the scan decides where the extra work goes', () {
    test('a segment below average for muscle earns the priority', () {
      // The 7 Aug 2026 reading: trunk -1, every limb 0.
      final emphasis = BodyEmphasis.fromRatings(
        muscleRatings: const {
          BodySegment.trunk: -1,
          BodySegment.rightArm: 0,
          BodySegment.leftArm: 0,
          BodySegment.rightLeg: 0,
          BodySegment.leftLeg: 0,
        },
      );

      expect(emphasis.priority, [BodyRegion.trunk]);
      expect(emphasis.isPriority(BodyRegion.trunk), isTrue);
      expect(emphasis.isPriority(BodyRegion.lowerBody), isFalse);
      expect(emphasis.reason, contains('trunk'));
    });

    test('it adds one set, never doubles the work', () {
      // Doubling the volume of a weak area is how a weak area becomes an
      // injured one. The emphasis nudges the session; the phase decides it.
      final plank = ExerciseCatalog.byId('plank')!;
      final plain = prescribeFor(plank, clearedSessions: 0);
      final favoured = prescribeFor(plank, clearedSessions: 0, extraSets: 1);

      expect(favoured.sets, plain.sets + 1);
      expect(favoured.target, plain.target, reason: 'reps are untouched');

      // And it cannot be stacked into something silly.
      expect(prescribeFor(plank, clearedSessions: 0, extraSets: 9).sets,
          plain.sets + 1);
    });

    test('no scan means an even programme, not a guess', () {
      expect(BodyEmphasis.fromRatings(muscleRatings: const {}),
          BodyEmphasis.none);
      expect(BodyEmphasis.none.hasPriority, isFalse);
      expect(BodyEmphasis.none.extraSetsFor(BodyRegion.trunk), 0);
    });

    test('all-average ratings hold rather than inventing a weak spot', () {
      final emphasis = BodyEmphasis.fromRatings(
        muscleRatings: const {BodySegment.trunk: 0, BodySegment.leftLeg: 1},
      );

      expect(emphasis.hasPriority, isFalse);
      expect(emphasis.reason, contains('average or better'));
    });

    test('the emphasis reaches the session, and skips the warm-up', () async {
      final plan = await const RuleBasedTrainer().planSession(
        weekday: DateTime.wednesday,
        week: 1,
        clearedByExercise: const {},
        emphasis: BodyEmphasis.fromRatings(
          muscleRatings: const {BodySegment.trunk: -1},
        ),
      );

      final plank = plan.items.firstWhere((i) => i.exercise.id == 'plank');
      final warmup =
          plan.items.firstWhere((i) => i.exercise.id == 'dynamic_warmup');

      expect(plank.sets, ExerciseCatalog.byId('plank')!.startSets + 1);
      // Volume does not belong on the warm-up or the cool-down.
      expect(warmup.sets, ExerciseCatalog.byId('dynamic_warmup')!.startSets);
      expect(plan.emphasisReason, isNotNull);
    });
  });

  group('progressive overload', () {
    final plank = ExerciseCatalog.byId('plank')!;

    test('a beginner gets the starting prescription', () {
      final p = prescribeFor(plank, clearedSessions: 0);
      expect(p.sets, plank.startSets);
      expect(p.target, plank.startTarget);
      expect(p.summary, '${plank.startSets} × ${plank.startTarget} sec');
    });

    test('the target grows one step per completed session', () {
      // Derived from the exercise, not hardcoded: these tests are about the
      // RULE, and pinning them to one movement's numbers meant every catalog
      // edit broke four unrelated tests.
      expect(
        prescribeFor(plank, clearedSessions: 1).target,
        plank.startTarget + plank.step,
      );
      expect(
        prescribeFor(plank, clearedSessions: 3).target,
        plank.startTarget + 3 * plank.step,
      );
    });

    test('the target stops at the ceiling, then sets are added', () {
      // Double progression: reps first, sets only once reps are maxed. Growing
      // both at once buries you inside a month.
      final stepsToCeiling =
          (plank.targetCeiling - plank.startTarget) ~/ plank.step;

      final atCeiling = prescribeFor(plank, clearedSessions: stepsToCeiling);
      expect(atCeiling.target, plank.targetCeiling);
      expect(atCeiling.sets, plank.startSets);

      final beyond = prescribeFor(plank, clearedSessions: stepsToCeiling + 1);
      expect(beyond.target, plank.targetCeiling);
      expect(beyond.sets, plank.startSets + 1);
    });

    test('sets stop at two above the start', () {
      // Past that the answer is a harder exercise, not a longer session.
      for (final cleared in [50, 200, 500]) {
        expect(
          prescribeFor(plank, clearedSessions: cleared).sets,
          plank.startSets + 2,
          reason: 'cleared $cleared',
        );
      }
    });

    test('a negative history is treated as none', () {
      expect(prescribeFor(plank, clearedSessions: -5).target, plank.startTarget);
    });
  });

  group('pushing past the plan', _overshootTests);

  group('sessions in the database', () {
    late AppDatabase db;
    late WorkoutRepository repo;

    // A Monday, so the weekday is fixed rather than whatever today happens to
    // be — every phase issues something different on different days.
    final monday = DateTime(2026, 8, 31);

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = WorkoutRepository(db, clock: FixedClock(monday));
    });

    tearDown(() => db.close());

    test('opening a day builds the session from the plan', () async {
      final session = await repo.openSession(monday);

      expect(session, isNotNull);
      expect(session!.week, 1);
      expect(session.phase, TrainingPhase.groundwork);
      expect(session.focus, 'EASY MILES');
      // Week 1 Monday: warm up, run, then the neck work and cool-down.
      expect(
        session.exercises.map((e) => e.exercise.id),
        ['dynamic_warmup', 'steady_run', 'chin_tucks', 'cooldown_stretch'],
      );
      expect(session.totalSets, greaterThan(0));
      expect(session.setsDone, 0);
    });

    test('opening the same day twice does not duplicate it', () async {
      final first = await repo.openSession(monday);
      final second = await repo.openSession(monday);

      expect(second!.id, first!.id);
      expect(second.totalSets, first.totalSets);
    });

    test('logging a set persists and moves the session on', () async {
      final session = await repo.openSession(monday);
      final firstSet = session!.exercises.first.sets.first;

      await repo.setDone(firstSet.id, true);

      final after = await repo.watchSession(monday).first;
      expect(after!.setsDone, 1);
      // The actual defaults to the target, because doing exactly what was
      // asked is the overwhelmingly common case.
      expect(after.exercises.first.sets.first.actual, firstSet.target);

      await repo.setDone(firstSet.id, false);
      expect((await repo.watchSession(monday).first)!.setsDone, 0);
    });

    test('a session is only finishable once every set is logged', () async {
      final session = await repo.openSession(monday);
      expect(session!.allSetsDone, isFalse);

      for (final exercise in session.exercises) {
        for (final set in exercise.sets) {
          await repo.setDone(set.id, true);
        }
      }

      final full = await repo.watchSession(monday).first;
      expect(full!.allSetsDone, isTrue);
      expect(full.isComplete, isFalse);

      await repo.completeSession(full.id);
      expect((await repo.watchSession(monday).first)!.isComplete, isTrue);
    });

    test('only fully completed exercises count toward overload', () async {
      final session = await repo.openSession(monday);
      final run = session!.exercises.first;

      // Log every set but one.
      for (final set in run.sets.take(run.sets.length - 1)) {
        await repo.setDone(set.id, true);
      }

      final tomorrow = dayKeyOfDate(monday) + 1;
      expect(await repo.clearedByExercise(before: tomorrow), isEmpty);

      await repo.setDone(run.sets.last.id, true);
      expect(
        await repo.clearedByExercise(before: tomorrow),
        containsPair(run.exercise.id, 1),
      );
    });

    test('a cleared session makes next week ask for more', () async {
      final session = await repo.openSession(monday);
      for (final exercise in session!.exercises) {
        for (final set in exercise.sets) {
          await repo.setDone(set.id, true);
        }
      }

      // Same weekday a week later, so the template is identical and only the
      // history has changed.
      final nextMonday = monday.add(const Duration(days: 7));
      final later = WorkoutRepository(db, clock: FixedClock(nextMonday));
      final next = await later.openSession(nextMonday);

      final before = session.exercises.first.sets.first.target;
      final after = next!.exercises.first.sets.first.target;
      expect(after, greaterThan(before));
      expect(next.week, 2);
    });

    test('history from today does not inflate today', () async {
      // clearedByExercise excludes the day being planned, or a session would
      // progressively overload itself while you were doing it.
      final session = await repo.openSession(monday);
      for (final set in session!.exercises.first.sets) {
        await repo.setDone(set.id, true);
      }
      expect(
        await repo.clearedByExercise(before: dayKeyOfDate(monday)),
        isEmpty,
      );
    });
  });
}

/// Local helper so the test does not depend on day_key's import path.
int dayKeyOfDate(DateTime d) =>
    DateTime(d.year, d.month, d.day).difference(DateTime(1970, 1, 1)).inDays;

/// The rules that keep "no limits" from becoming a trap.
void _overshootTests() {
  late AppDatabase db;
  late WorkoutRepository repo;
  final monday = DateTime(2026, 8, 31);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = WorkoutRepository(db, clock: FixedClock(monday));
  });

  tearDown(() => db.close());

  test('a session exists before it is summoned', () async {
    // The ceremony reveals the session; it must never be what creates it, or a
    // dead network costs you the workout.
    final session = await repo.openSession(monday);
    expect(session, isNotNull);
    expect(session!.isSummoned, isFalse);
    expect(session.exercises, isNotEmpty);
  });

  test('summoning is once per day, not once per tap', () async {
    // Otherwise you could reroll until you got an easy day.
    final first = await repo.summon(monday);
    final at = first!.summonedAt;
    expect(at, isNotNull);

    final second = await repo.summon(monday);
    expect(second!.summonedAt, at, reason: 're-summoning re-rolled the day');
    expect(second.id, first.id);
  });

  test('doing more than asked is recorded as what was actually done', () async {
    final session = await repo.summon(monday);
    final set = session!.exercises.first.sets.first;
    // Derived from the prescription rather than a hardcoded number, so a
    // catalog edit does not break a test about overshoot.
    final asked = set.target;

    await repo.setDone(set.id, true, actual: asked + 10);

    final after = await repo.watchSession(monday).first;
    final logged = after!.exercises.first.sets.first;
    expect(logged.actual, asked + 10);
    expect(logged.exceeded, isTrue);
    expect(after.exercises.first.overshoot, 10);
  });

  test('an extra set is added, logged, and removable', () async {
    final session = await repo.summon(monday);
    final exercise = session!.exercises.first;
    final before = exercise.sets.length;

    await repo.addExtraSet(session.id, exercise.exercise.id);
    var after = await repo.watchSession(monday).first;
    var view = after!.exercises.first;

    expect(view.sets, hasLength(before + 1));
    expect(view.extra, hasLength(1));
    expect(view.prescribed, hasLength(before));

    // Prescribed sets are the plan and cannot be removed; extras can.
    await repo.removeExtraSet(view.prescribed.first.id);
    after = await repo.watchSession(monday).first;
    expect(after!.exercises.first.prescribed, hasLength(before));

    await repo.removeExtraSet(view.extra.single.id);
    after = await repo.watchSession(monday).first;
    expect(after!.exercises.first.extra, isEmpty);
  });

  test('extra sets do not stand in for the prescription', () async {
    final session = await repo.summon(monday);
    final exercise = session!.exercises.first;

    // Two extra sets, both logged; the prescribed one untouched.
    await repo.addExtraSet(session.id, exercise.exercise.id);
    await repo.addExtraSet(session.id, exercise.exercise.id);
    for (final set in (await repo.watchSession(monday).first)!
        .exercises
        .first
        .extra) {
      await repo.setDone(set.id, true);
    }

    final after = await repo.watchSession(monday).first;
    expect(after!.exercises.first.complete, isFalse,
        reason: 'extra work completed the prescription');
    expect(after.allSetsDone, isFalse);
    expect(after.extraSetsDone, 2);
  });

  test('extra work never accelerates progressive overload', () async {
    // The safety-critical one. Six sets where three were asked for is not
    // "completed the prescription twice", and treating it that way is how
    // enthusiasm becomes an injury.
    final session = await repo.summon(monday);
    final exercise = session!.exercises.first;

    for (final set in exercise.sets) {
      await repo.setDone(set.id, true);
    }
    await repo.addExtraSet(session.id, exercise.exercise.id);
    for (final set in (await repo.watchSession(monday).first)!
        .exercises
        .first
        .extra) {
      await repo.setDone(set.id, true);
    }
    await repo.completeSession(session.id);

    final cleared = await repo.clearedByExercise(
      before: dayKeyOfDate(monday) + 1,
    );
    expect(
      cleared[exercise.exercise.id],
      1,
      reason: 'extra sets inflated the overload count',
    );

    // And next week asks for exactly one step more, not two.
    final nextMonday = monday.add(const Duration(days: 7));
    final next = await WorkoutRepository(db, clock: FixedClock(nextMonday))
        .openSession(nextMonday);
    expect(
      next!.exercises.first.sets.first.target,
      exercise.sets.first.target + exercise.exercise.step,
    );
  });
}
