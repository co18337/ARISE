import 'dart:math';

import '../../models/models.dart';
import '../day_key.dart';
import '../exercise_catalog.dart';
import 'memory_repository.dart';

/// Fills the corpus with plausible SAMPLE data.
///
/// The vector store and the retrieval path cannot be judged — by me or by
/// anyone — against an empty table. This generates a realistic corpus so the
/// whole pipeline can be exercised now, months before there is real history.
///
/// Everything it writes carries the `sample:` externalId prefix, so
/// [MemoryRepository.clear] can remove exactly this and nothing else. Titles
/// say SAMPLE too, because sample data that looks real is how you end up
/// trusting a number that was invented.
class MemorySeeder {
  final MemoryRepository memory;

  /// Seeded so a given seed always produces the same corpus — a random corpus
  /// makes a failing test unreproducible.
  final Random random;

  MemorySeeder(this.memory, {int seed = 20260830}) : random = Random(seed);

  static const String prefix = 'sample:';

  /// Writes [days] days of history ending yesterday.
  Future<int> seed({int days = 45, DateTime? endingOn}) async {
    final lastDay = dayKeyOf(endingOn ?? DateTime.now()) - 1;
    var written = 0;

    await _seedBodyScan(lastDay - days);
    await _seedPlan();
    written += 2;

    for (var offset = days; offset >= 1; offset--) {
      final day = lastDay - offset + 1;
      await _seedSession(day);
      await _seedHealth(day);
      await _seedDailyLog(day);
      written += 3;
    }

    return written;
  }

  Future<void> _seedBodyScan(int day) => memory.ingest(
    kind: MemoryKind.bodyScan,
    title: 'SAMPLE body composition scan',
    day: day,
    externalId: '${prefix}scan:$day',
    body: '''
SAMPLE DATA — invented figures, not a real measurement.
Body composition scan. Weight 78.4 kg, body fat 24.1 percent, muscle mass
55.6 kg, visceral fat rating 11, basal metabolic rate 1713 kcal.
Fat is carried mainly around the trunk: chest and abdomen segmental readings
are well above the limb readings. Neck and jawline definition is limited by
subcutaneous fat rather than by muscle.
Priority from this scan: reduce trunk fat first, preserve muscle mass, build
neck and postural strength alongside.
''',
  );

  Future<void> _seedPlan() => memory.ingest(
    kind: MemoryKind.transformationPlan,
    title: 'SAMPLE transformation plan',
    externalId: '${prefix}plan',
    body: '''
SAMPLE DATA — a stand-in for the real written plan.
Goal: reduce trunk and chest fat, bring out the jawline, build a base of
strength without losing muscle.
Month one is cardio only — running and brisk walking — to build the habit of
turning up daily before anything technical is introduced.
Months two and three add core work and bodyweight pushing while cardio still
leads. Months four to six introduce pulling, bench pressing and legs.
Sleep by 11pm, dinner finished by 9pm, three litres of water daily, morning
and night skincare, sunscreen every morning.
''',
  );

  static const List<String> _focusByWeekday = [
    'ENDURANCE',
    'EASY MILES',
    'INTERVALS',
    'EASY MILES',
    'ENDURANCE',
    'INTERVALS',
    'RECOVERY',
  ];

  Future<void> _seedSession(int day) {
    final date = dateOfDayKey(day);
    final focus = _focusByWeekday[(date.weekday - 1) % 7];
    final pool = ExerciseCatalog.all
        .where((e) => e.kind == ExerciseKind.cardio || e.kind == ExerciseKind.neck)
        .toList();

    final lines = <String>[];
    for (final exercise in pool.take(3)) {
      final sets = exercise.startSets;
      // Most sessions are completed; some are not, so the corpus contains
      // both and retrieval has something to distinguish.
      final completed = random.nextDouble() < 0.78 ? sets : random.nextInt(sets);
      lines.add(
        '${exercise.name}: $completed of $sets sets at '
        '${exercise.startTarget} ${exercise.unit.label}'
        '${completed == sets ? ' — completed' : ' — cut short'}.',
      );
    }
    if (random.nextDouble() < 0.25) {
      lines.add(_flavour[random.nextInt(_flavour.length)]);
    }

    final week = random.nextInt(4) + 1;
    // Written through ingest rather than rememberSession so it carries the
    // `sample:` prefix. rememberSession uses `session:<day>`, which would
    // survive "clear sample data" and leave invented sessions in the corpus
    // looking exactly like real ones.
    return memory.ingest(
      kind: MemoryKind.workoutSession,
      title: 'SAMPLE $focus · week $week',
      day: day,
      externalId: '${prefix}session:$day',
      body: [
        'SAMPLE DATA. Training session on ${date.year}-'
            '${date.month.toString().padLeft(2, '0')}-'
            '${date.day.toString().padLeft(2, '0')}.',
        'Phase IGNITE, week $week, focus $focus.',
        ...lines,
      ].join('\n'),
    );
  }

  static const List<String> _flavour = [
    'Legs felt heavy from the day before; pace was slower than usual.',
    'Breathing settled after the first ten minutes and the run felt easy.',
    'Right knee was slightly sore on the intervals, so the last set was cut.',
    'Woke up late and trained in the evening instead of the morning.',
    'Best session so far — held the target pace the whole way.',
  ];

  Future<void> _seedHealth(int day) {
    final steps = 4000 + random.nextInt(9000);
    final sleep = 5.5 + random.nextDouble() * 3;
    final restingHr = 58 + random.nextInt(14);

    return memory.ingest(
      kind: MemoryKind.healthSync,
      title: 'SAMPLE health sync',
      day: day,
      externalId: '${prefix}health:$day',
      body: 'SAMPLE DATA. Steps $steps. Sleep ${sleep.toStringAsFixed(1)} '
          'hours. Resting heart rate $restingHr bpm. '
          '${steps > 10000 ? 'An active day.' : 'A quiet day on foot.'} '
          '${sleep < 6.5 ? 'Short night.' : 'Slept well.'}',
    );
  }

  Future<void> _seedDailyLog(int day) {
    final total = 9;
    final cleared = random.nextInt(total + 1);

    return memory.ingest(
      kind: MemoryKind.dailyLog,
      title: 'SAMPLE day record',
      day: day,
      externalId: '${prefix}day:$day',
      body: 'SAMPLE DATA. Cleared $cleared of $total quests. '
          '${cleared == total ? 'A perfect day.' : '${total - cleared} missed.'} '
          '${cleared >= 6 ? 'The day met the streak bar.' : 'The day failed the streak bar.'}',
    );
  }
}
