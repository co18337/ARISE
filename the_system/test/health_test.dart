import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/health/health_source.dart';
import 'package:the_system/data/repositories/health_repository.dart';
import 'package:the_system/data/repositories/progress_repository.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';

/// Phase 11 — everything about Health Connect except Health Connect.
///
/// NoopHealthSource hands the repository a scripted set of days, so the
/// folding, the storing, the auto-verification and the refusal to invent data
/// are all provable here. What is left for the device is only whether Android
/// hands over the real numbers.
void main() {
  late AppDatabase db;
  late QuestRepository quests;
  final clock = FixedClock.todayAt(21, 0);

  DateTime dayAgo(int n) {
    final now = clock.now();
    return DateTime(now.year, now.month, now.day).subtract(Duration(days: n));
  }

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    quests = QuestRepository(db, clock: clock);
    await quests.materialiseDay(clock.now());
  });

  tearDown(() async => db.close());

  HealthRepository repoWith(List<HealthDay> days) => HealthRepository(
    db: db,
    source: NoopHealthSource(days: days),
    quests: quests,
    clock: clock,
  );

  test('a sync stores the daily totals it was given', () async {
    final repo = repoWith([
      HealthDay(date: dayAgo(1), steps: 8200, sleepMinutes: 400),
      HealthDay(date: dayAgo(0), steps: 5100, restingHeartRate: 62),
    ]);

    final outcome = await repo.sync();
    expect(outcome.daysStored, 2);

    final stored = await repo.read();
    expect(stored, hasLength(2));
    expect(stored.first.steps, 8200);
    expect(stored.first.sleepLabel, '6h 40m');
    expect(stored.last.restingHeartRate, 62);
  });

  test('re-syncing corrects today rather than duplicating it', () async {
    // Today is not over: the step count is still climbing, so the row has to
    // be rewritten every time rather than appended to.
    await repoWith([HealthDay(date: dayAgo(0), steps: 3000)]).sync();
    await repoWith([HealthDay(date: dayAgo(0), steps: 9400)]).sync();

    final stored = await repoWith(const []).read();
    expect(stored, hasLength(1));
    expect(stored.single.steps, 9400);
  });

  test('a day the phone knew nothing about is never invented', () async {
    // The distinction that keeps the chart honest: an empty day means the
    // phone was off, and writing zeros for it draws a fortnight of lying
    // still that never happened.
    final empty = HealthDay(date: dayAgo(3));
    expect(empty.isEmpty, isTrue);
    expect(HealthDay(date: dayAgo(3), steps: 0).isEmpty, isFalse,
        reason: 'zero steps is a reading; no steps is not');

    final repo = repoWith([HealthDay(date: dayAgo(1), steps: 4000)]);
    await repo.sync();
    expect(await repo.read(), hasLength(1));
  });

  test('twenty minutes of recorded exercise clears the workout quest',
      () async {
    final repo = repoWith([
      HealthDay(date: dayAgo(0), steps: 9000, workoutMinutes: 34),
    ]);

    final outcome = await repo.sync();

    expect(outcome.questsVerified, isNotEmpty);
    final workout = (await quests.readDay(clock.now()))
        .firstWhere((q) => q.template.category == TaskCategory.workout);
    expect(workout.status, QuestStatus.done);
  });

  test('a short walk does not clear it', () async {
    // Otherwise the walk to the shop trips the day's training quest and the
    // streak stops meaning anything.
    final repo = repoWith([
      HealthDay(date: dayAgo(0), steps: 2000, workoutMinutes: 6),
    ]);

    final outcome = await repo.sync();

    expect(outcome.questsVerified, isEmpty);
    final workout = (await quests.readDay(clock.now()))
        .firstWhere((q) => q.template.category == TaskCategory.workout);
    expect(workout.status, QuestStatus.pending);
  });

  test('sync only ever marks DONE, never missed', () async {
    // A phone that failed to record a run you actually did must not be able
    // to fail your day. Absence of evidence is not evidence.
    final repo = repoWith([
      HealthDay(date: dayAgo(0), steps: 200, workoutMinutes: 0),
    ]);
    await repo.sync();

    final statuses =
        (await quests.readDay(clock.now())).map((q) => q.status).toSet();
    expect(statuses, isNot(contains(QuestStatus.missed)));
  });

  test('a source that fails cannot break anything', () async {
    final repo = HealthRepository(
      db: db,
      source: _BrokenSource(),
      quests: quests,
      clock: clock,
    );

    final outcome = await repo.sync();
    expect(outcome.error, isNotNull);
    expect(outcome.didSomething, isFalse);
    // And the routine is untouched.
    expect(await quests.readDay(clock.now()), isNotEmpty);
  });

  test('the dashboard averages over days that REPORTED, not the window',
      () async {
    // A phone left at home does not lower your average; it says nothing
    // about that day at all.
    await repoWith([
      HealthDay(date: dayAgo(2), steps: 10000),
      HealthDay(date: dayAgo(1), steps: 6000),
    ]).sync();

    final view = await ProgressRepository(db, clock: clock).read(
      ChartRange.month,
    );

    expect(view.hasHealth, isTrue);
    expect(view.stepDays, hasLength(2));
    expect(view.averageSteps, 8000);
    expect(view.totalSteps, 16000);
  });

  test('the range filter applies to health, unlike the scans', () async {
    // This is the data the filter was built for — daily, over months.
    await repoWith([
      HealthDay(date: dayAgo(20), steps: 1000),
      HealthDay(date: dayAgo(2), steps: 2000),
    ]).sync();

    final progress = ProgressRepository(db, clock: clock);
    expect((await progress.read(ChartRange.week)).health, hasLength(1));
    expect((await progress.read(ChartRange.month)).health, hasLength(2));
    // Scans stay unfiltered, as before.
    expect((await progress.read(ChartRange.week)).scans, isNotEmpty);
  });
}

class _BrokenSource implements HealthSource {
  @override
  Future<List<HealthDay>> readDays({required int days}) async =>
      throw StateError('no');

  @override
  Future<HealthStatus> requestPermissions() async => throw StateError('no');

  @override
  Future<HealthStatus> status() async => throw StateError('no');
}
