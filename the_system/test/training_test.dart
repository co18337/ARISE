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
    test('run to the weeks the plan promises', () {
      // Month one cardio-only, three months of fat loss, then the lifts.
      expect(TrainingPhase.forWeek(1), TrainingPhase.ignite);
      expect(TrainingPhase.forWeek(4), TrainingPhase.ignite);
      expect(TrainingPhase.forWeek(5), TrainingPhase.reduce);
      expect(TrainingPhase.forWeek(12), TrainingPhase.reduce);
      expect(TrainingPhase.forWeek(13), TrainingPhase.build);
      expect(TrainingPhase.forWeek(24), TrainingPhase.build);
      expect(TrainingPhase.forWeek(25), TrainingPhase.forge);
      expect(TrainingPhase.forWeek(500), TrainingPhase.forge);
    });

    test('week zero and negative weeks clamp to the first phase', () {
      expect(TrainingPhase.forWeek(0), TrainingPhase.ignite);
      expect(TrainingPhase.forWeek(-3), TrainingPhase.ignite);
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
    Set<ExerciseKind> kindsIn(TrainingPhase phase) => {
      for (var weekday = 1; weekday <= 7; weekday++)
        ...TrainingPlan.exercisesFor(phase, weekday).map((e) => e.kind),
    };

    test('month one is running and walking, nothing else', () {
      // The plan asked for exactly this: cardio only to start, so the habit
      // is built before anything technical is introduced.
      expect(
        kindsIn(TrainingPhase.ignite),
        {ExerciseKind.cardio, ExerciseKind.neck, ExerciseKind.mobility},
      );
    });

    test('core and pushing arrive in month two', () {
      final kinds = kindsIn(TrainingPhase.reduce);
      expect(kinds, contains(ExerciseKind.core));
      expect(kinds, contains(ExerciseKind.push));
      // Still no pulling or legs — that is a later phase.
      expect(kinds, isNot(contains(ExerciseKind.pull)));
      expect(kinds, isNot(contains(ExerciseKind.legs)));
    });

    test('the named lifts all arrive by the build phase', () {
      final ids = {
        for (var weekday = 1; weekday <= 7; weekday++)
          ...TrainingPlan.exercisesFor(TrainingPhase.build, weekday)
              .map((e) => e.id),
      };
      for (final lift in [
        'bench_press',
        'situps',
        'pullups',
        'pushups',
        'bicep_curls',
        'bodyweight_squats',
      ]) {
        expect(ids, contains(lift), reason: lift);
      }
    });

    test('neck work and the cool-down are in every session', () {
      for (final phase in TrainingPhase.values) {
        for (var weekday = 1; weekday <= 7; weekday++) {
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

  group('progressive overload', () {
    final plank = ExerciseCatalog.byId('plank')!;

    test('a beginner gets the starting prescription', () {
      final p = prescribeFor(plank, clearedSessions: 0);
      expect(p.sets, plank.startSets);
      expect(p.target, plank.startTarget);
      expect(p.summary, '3 × 30 sec');
    });

    test('the target grows one step per completed session', () {
      expect(prescribeFor(plank, clearedSessions: 1).target, 40);
      expect(prescribeFor(plank, clearedSessions: 3).target, 60);
    });

    test('the target stops at the ceiling, then sets are added', () {
      // Double progression: reps first, sets only once reps are maxed. Growing
      // both at once buries you inside a month.
      final atCeiling = prescribeFor(plank, clearedSessions: 6);
      expect(atCeiling.target, plank.targetCeiling);
      expect(atCeiling.sets, plank.startSets);

      final beyond = prescribeFor(plank, clearedSessions: 7);
      expect(beyond.target, plank.targetCeiling);
      expect(beyond.sets, plank.startSets + 1);
    });

    test('sets stop at two above the start', () {
      // Past that the answer is a harder exercise, not a longer session.
      for (final cleared in [9, 20, 500]) {
        expect(
          prescribeFor(plank, clearedSessions: cleared).sets,
          plank.startSets + 2,
          reason: 'cleared $cleared',
        );
      }
    });

    test('a negative history is treated as none', () {
      expect(prescribeFor(plank, clearedSessions: -5).target, 30);
    });
  });

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
      expect(session.phase, TrainingPhase.ignite);
      expect(session.focus, 'ENDURANCE');
      // Week 1 Monday: a run, plus the neck work and cool-down.
      expect(
        session.exercises.map((e) => e.exercise.id),
        ['steady_run', 'chin_tucks', 'cooldown_stretch'],
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
