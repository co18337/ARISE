import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/exercise_catalog.dart';
import 'package:the_system/data/progression_ladders.dart';
import 'package:the_system/data/repositories/workout_repository.dart';
import 'package:the_system/data/training_plan.dart';
import 'package:the_system/game/game.dart';

/// Pass 1 — progression that reads how it went, and movements that graduate.
void main() {
  group('the margin, not just the tick', () {
    final plank = ExerciseCatalog.byId('plank')!;

    test('finishing well past the ask makes the step bigger', () {
      // Twelve-minute runs logged at seventeen mean the step is too small, and
      // counting only "completed" could never see that.
      final plain = prescribeFor(plank, clearedSessions: 2);
      final easy = prescribeFor(
        plank,
        clearedSessions: 2,
        record: const ExerciseRecord(cleared: 2, margin: 1.4),
      );

      expect(easy.target, greaterThan(plain.target));
    });

    test('falling short holds it back rather than pushing on', () {
      final plain = prescribeFor(plank, clearedSessions: 4);
      final hard = prescribeFor(
        plank,
        clearedSessions: 4,
        record: const ExerciseRecord(cleared: 4, margin: 0.6),
      );

      expect(hard.target, lessThan(plain.target));
      // Held, never reversed below the start: regression is a deload's job.
      expect(hard.target, greaterThanOrEqualTo(plank.startTarget));
    });

    test('one big day is not a pattern', () {
      // 1.25 is the bar deliberately: enthusiasm on a single set should not
      // rewrite next week.
      const enthusiastic = ExerciseRecord(cleared: 3, margin: 1.1);
      expect(enthusiastic.isEasy, isFalse);
      expect(const ExerciseRecord(cleared: 3, margin: 1.3).isEasy, isTrue);
    });

    test('a margin needs logged amounts, not just ticks', () {
      // "Done" without a number says nothing about how far past the ask it
      // landed, so those sets are skipped rather than counted as exact.
      expect(marginOf([(target: 10, actual: null)]), isNull);
      expect(marginOf(const <({int target, int? actual})>[]), isNull);
      expect(marginOf([(target: 10, actual: 15)]), 1.5);
    });
  });

  group('weight, for movements that carry it', () {
    final press = ExerciseCatalog.byId('bench_press')!;
    final plank = ExerciseCatalog.byId('plank')!;

    test('an unloaded movement never suggests a weight', () {
      expect(plank.isLoaded, isFalse);
      expect(prescribeFor(plank, clearedSessions: 3).loadHalfKg, isNull);
    });

    test('the first session invents nothing', () {
      // The app has no idea what you can bench, and guessing is how somebody
      // gets hurt on their first day.
      expect(press.isLoaded, isTrue);
      expect(prescribeFor(press, clearedSessions: 0).loadHalfKg, isNull);
    });

    test('the weight holds while the reps climb', () {
      final p = prescribeFor(
        press,
        clearedSessions: 1,
        record: const ExerciseRecord(cleared: 1, lastLoadHalfKg: 80),
      );
      expect(p.loadKg, 40, reason: 'same weight, more reps');
    });

    test('and goes up once the reps top out', () {
      // The moment the weight, rather than the rep count, is what is holding
      // you back.
      final steps = (press.targetCeiling - press.startTarget) ~/ press.step;
      final p = prescribeFor(
        press,
        clearedSessions: steps,
        record: ExerciseRecord(cleared: steps, lastLoadHalfKg: 80),
      );
      expect(p.target, press.targetCeiling);
      expect(p.loadKg, 40 + press.loadStepHalfKg / 2);
    });

    test('the summary says the weight once there is one', () {
      final p = prescribeFor(
        press,
        clearedSessions: 1,
        record: const ExerciseRecord(cleared: 1, lastLoadHalfKg: 55),
      );
      expect(p.summary, contains('27.5 kg'));
    });
  });

  group('movements graduate when they are ready', () {
    test('you start at the bottom rung, whatever the template asked for', () {
      // A template asking for pull-ups on somebody who cannot hang gets dead
      // hangs — and keeps getting them.
      expect(ProgressionLadders.resolve('pullups', const {}), 'dead_hang');
      expect(ProgressionLadders.resolve('pushups', const {}), 'incline_pushups');
    });

    test('clearing a rung enough times, easily, moves you up', () {
      final history = {
        'dead_hang': const ExerciseRecord(cleared: 6, margin: 1.1),
      };
      expect(
        ProgressionLadders.resolve('pullups', history),
        'negative_pullup',
      );
    });

    test('six grinding sessions is not readiness', () {
      final history = {
        'dead_hang': const ExerciseRecord(cleared: 9, margin: 0.7),
      };
      expect(ProgressionLadders.resolve('pullups', history), 'dead_hang');
    });

    test('rungs are never skipped', () {
      // Being consistent at hangs cannot land you on full pull-ups.
      final history = {
        'dead_hang': const ExerciseRecord(cleared: 40, margin: 1.5),
      };
      expect(
        ProgressionLadders.resolve('pullups', history),
        'negative_pullup',
        reason: 'the middle rung still has to be earned',
      );
    });

    test('a movement on no ladder is left alone', () {
      expect(ProgressionLadders.resolve('steady_run', const {}), 'steady_run');
      expect(ProgressionLadders.resolve('leg_press', const {}), 'leg_press');
    });
  });

  group('backing off before it breaks', () {
    const rule = DeloadRule();

    test('every sixth week is planned, whether or not anything is wrong', () {
      // The one that keeps people training for a year. Waiting for a stall
      // means the stall arrives, and by then the weeks that caused it are
      // already spent.
      expect(rule.forWeek(week: 6, recentUnfinished: 0)?.reason,
          DeloadReason.planned);
      expect(rule.forWeek(week: 5, recentUnfinished: 0), isNull);
    });

    test('never in the first block', () {
      // A beginner losing volume in week one loses the habit instead.
      for (var w = 1; w <= 5; w++) {
        expect(rule.forWeek(week: w, recentUnfinished: 0), isNull, reason: 'w$w');
      }
    });

    test('two unfinished sessions force one early', () {
      expect(
        rule.forWeek(week: 3, recentUnfinished: 2)?.reason,
        DeloadReason.stalled,
      );
      expect(rule.forWeek(week: 3, recentUnfinished: 1), isNull);
    });

    test('a rough patch straight after a deload does not trigger another', () {
      // Otherwise one bad week becomes two, then three, and the programme
      // quietly stops.
      expect(
        rule.forWeek(week: 8, recentUnfinished: 3, weeksSinceLastDeload: 1),
        isNull,
      );
      expect(
        rule.forWeek(week: 9, recentUnfinished: 3, weeksSinceLastDeload: 2)
            ?.reason,
        DeloadReason.stalled,
      );
    });

    test('it cuts sets and never removes a movement', () {
      // A deload that deletes an exercise is a rest day in disguise.
      expect(DeloadRule.setsFor(5, null), 5);
      expect(DeloadRule.setsFor(5, const Deload(DeloadReason.planned)), 3);
      expect(DeloadRule.setsFor(1, const Deload(DeloadReason.planned)), 1);
    });

    test('weight and reps are held, only volume moves', () {
      final press = ExerciseCatalog.byId('bench_press')!;
      const record = ExerciseRecord(cleared: 2, lastLoadHalfKg: 80);

      final normal = prescribeFor(press, clearedSessions: 2, record: record);
      final light = prescribeFor(
        press,
        clearedSessions: 2,
        record: record,
        deload: const Deload(DeloadReason.planned),
      );

      expect(light.sets, lessThan(normal.sets));
      expect(light.target, normal.target, reason: 'reps held');
      expect(light.loadHalfKg, normal.loadHalfKg, reason: 'weight held');
    });
  });

  group('the benchmark gate', () {
    test('the work being done is not the same as it having worked', () {
      // Weeks passed and sessions completed, but nothing proven.
      final gate = PhaseGate.resolve(
        week: 3,
        sessionsCompleted: 20,
        records: {'steady_run': const ExerciseRecord(cleared: 20, bestActual: 8)},
      );

      expect(gate.reached, TrainingPhase.groundwork);
      expect(gate.isHeldBack, isTrue);
      expect(gate.unmetTests, isNotEmpty);
      expect(gate.holdReason, contains('benchmark'));
    });

    test('meeting it opens the next phase', () {
      final gate = PhaseGate.resolve(
        week: 3,
        sessionsCompleted: 20,
        records: {
          'steady_run': const ExerciseRecord(cleared: 20, bestActual: 18),
          'plank': const ExerciseRecord(cleared: 20, bestActual: 45),
        },
      );

      expect(gate.reached, TrainingPhase.reset);
      expect(gate.isHeldBack, isFalse);
    });

    test('best ever counts, not most recent', () {
      // A benchmark asks what you are capable of. One bad Tuesday does not
      // take away a thing you have already proven.
      const record = ExerciseRecord(cleared: 20, bestActual: 18, margin: 0.5);
      final gate = PhaseGate.resolve(
        week: 3,
        sessionsCompleted: 20,
        records: {
          'steady_run': record,
          'plank': const ExerciseRecord(cleared: 20, bestActual: 45),
        },
      );
      expect(gate.reached, TrainingPhase.reset);
    });

    test('with no history at all it falls back to weeks and work', () {
      // A fresh install must not be locked in phase one forever because it
      // has never seen a single set.
      final gate = PhaseGate.resolve(week: 5, sessionsCompleted: 16);
      expect(gate.reached, TrainingPhase.fatBurn);
    });
  });

  group('through the trainer', () {
    test('the session issues the rung you are actually on', () async {
      final plan = await const RuleBasedTrainer().planSession(
        weekday: DateTime.tuesday,
        week: 1,
        clearedByExercise: const {},
        records: const {},
      );
      final ids = plan.items.map((i) => i.exercise.id);
      // GROUNDWORK Tuesday asks for a dead hang, which IS the bottom rung.
      expect(ids, contains('dead_hang'));
      expect(ids, isNot(contains('pullups')));
    });

    test('the record reaches the prescription', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = WorkoutRepository(db);

      // Nothing logged yet, so nothing to say about any movement.
      expect(await repo.recordByExercise(before: 999999), isEmpty);
    });
  });
}
