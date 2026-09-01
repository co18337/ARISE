import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/day_key.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/repositories/progress_repository.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';

/// Phase 12 — what the charts are drawn from.
///
/// The charts themselves are pixels and are covered by the widget tests. What
/// is worth asserting here is the DATA: that the baseline survives, that a
/// range filter cuts days without cutting scans, and that a day the app never
/// saw stays absent rather than becoming a zero.
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() async => db.close());

  test('the Tanita baseline is there before anything is measured', () async {
    final view = await ProgressRepository(db).read(ChartRange.all);

    final baseline = view.baseline;
    expect(baseline, isNotNull);
    expect(baseline!.date, DateTime(2026, 8, 7));
    expect(baseline.weightKg, 79.5);
    expect(baseline.bodyFatPercent, 25.4);
    expect(baseline.muscleMassKg, 56.2);
    expect(baseline.visceralFat, 9);
    expect(baseline.bmrKcal, 1713);
    expect(baseline.metabolicAge, 37);
    expect(baseline.source, 'Tanita MC-780');

    // One reading is not a trend, and the screen says so rather than drawing
    // a single dot on an axis.
    expect(view.hasTrend, isFalse);
  });

  test('the whole MC-780 panel is stored, not just the headline figures',
      () async {
    final scan = (await ProgressRepository(db).read(ChartRange.all)).baseline!;

    // The figures the report prints and the old six-column table dropped.
    expect(scan.heightCm, 182.5);
    expect(scan.bmi, 23.9);
    expect(scan.fatMassKg, 20.2);
    expect(scan.fatFreeMassKg, 59.3);
    expect(scan.skeletalMuscleKg, 29.1);
    expect(scan.skeletalMusclePercent, 36.6);
    expect(scan.boneMassKg, 3.1);
    expect(scan.proteinKg, 18.9);
    expect(scan.totalBodyWaterKg, 37.3);
    expect(scan.extracellularWaterKg, 15.6);
    expect(scan.intracellularWaterKg, 21.7);
    expect(scan.ecwOverTbwPercent, 41.8);
    expect(scan.bmrKj, 7172);
    expect(scan.sarcopenicIndex, 8.11);
    expect(scan.phaseAngleDeg, 6.3);
    expect(scan.impedanceOhm, 649);
    expect(scan.atMinutes, 12 * 60 + 12);

    // Fat mass is the report's own figure, NOT weight × percent. Those
    // disagree — 79.5 × 25.4% is 20.19 — and the report is the record.
    expect(scan.fatMassKg, isNot(closeTo(79.5 * 0.254, 0.0001)));
  });

  test('all five segments are stored as printed', () async {
    final scan = (await ProgressRepository(db).read(ChartRange.all)).baseline!;

    expect(scan.hasSegments, isTrue);
    expect(scan.segments, hasLength(5));

    final trunk =
        scan.segments.firstWhere((s) => s.segment == BodySegment.trunk);
    expect(trunk.fatKg, 11.2);
    expect(trunk.fatPercent, 26.7);
    expect(trunk.muscleKg, 29.2);
    expect(trunk.muscleRating, -1);

    // The whole point of the segments: 11.2 kg of the 20.2 kg of fat is on
    // the trunk, which is what makes trunk fat the first job.
    final totalSegmentFat = scan.segments
        .map((s) => s.fatKg ?? 0)
        .reduce((a, b) => a + b);
    expect(totalSegmentFat, closeTo(scan.fatMassKg!, 0.15));
  });

  test('lab results carry the range they were measured against', () async {
    final view = await ProgressRepository(db).read(ChartRange.all);

    expect(view.labs, isNotEmpty);
    expect(view.labsByPanel.keys, containsAll(['LIPID', 'LIVER', 'HEMOGRAM']));

    final sgpt = view.labs.firstWhere((l) => l.name == 'SGPT (ALT)');
    expect(sgpt.value, 83.3);
    expect(sgpt.unit, 'U/L');
    // The range travels with the value: a number without it says nothing, and
    // ranges differ by lab and method.
    expect(sgpt.refText, '< 45');
    expect(sgpt.flag, 'high');

    // Exactly the three the REPORT flagged — not a judgement made here.
    expect(
      view.flaggedLabs.map((l) => l.name).toSet(),
      {'SGPT (ALT)', 'HDL cholesterol', 'Haematocrit (PCV)'},
    );
  });

  test('re-transcribing a report corrects it rather than duplicating it',
      () async {
    final repo = ProgressRepository(db);
    final before = (await repo.read(ChartRange.all)).labs.length;

    await repo.recordLab(
      date: DateTime(2026, 8, 7),
      panel: 'LIVER',
      name: 'SGPT (ALT)',
      value: 83.3,
      unit: 'U/L',
      refText: '< 45',
      flag: 'high',
      source: 'Thyrocare',
    );

    final after = await repo.read(ChartRange.all);
    expect(after.labs, hasLength(before), reason: 'day+panel+name is the key');
  });

  test('a re-scan charts against the baseline instead of replacing it',
      () async {
    final repo = ProgressRepository(db);
    await repo.recordScan(
      date: DateTime(2027, 2, 7),
      weightKg: 73.2,
      bodyFatPercent: 18.1,
      fatMassKg: 13.2,
      muscleMassKg: 57.4,
      visceralFat: 6,
      source: 'Tanita MC-780',
    );

    final view = await repo.read(ChartRange.all);

    // Both readings, oldest first. This is the whole point of dated rows: a
    // table holding only the latest scan can say where you are and never how
    // far you have come.
    expect(view.scans, hasLength(2));
    expect(view.hasTrend, isTrue);
    expect(view.baseline!.weightKg, 79.5);
    expect(view.latest!.weightKg, 73.2);

    // Fat mass is STORED, not derived from weight × percent. The MC-780
    // prints it, the two disagree in the last decimal, and the report is the
    // record — so it round-trips exactly as given.
    expect(view.latest!.fatMassKg, 13.2);
  });

  test('correcting a typo replaces that scan rather than adding a second',
      () async {
    final repo = ProgressRepository(db);
    final day = DateTime(2027, 2, 7);
    await repo.recordScan(date: day, weightKg: 372);
    await repo.recordScan(date: day, weightKg: 73.2);

    final view = await repo.read(ChartRange.all);
    expect(view.scans, hasLength(2)); // the baseline plus this one
    expect(view.latest!.weightKg, 73.2);
  });

  test('the range filters days and deliberately does NOT filter scans',
      () async {
    // Two scans six months apart is the normal case, and "last 7 days" would
    // empty the one chart that matters most.
    final repo = ProgressRepository(db, clock: FixedClock(DateTime(2026, 9, 1)));
    await repo.recordScan(date: DateTime(2026, 8, 20), weightKg: 78.0);

    for (final offset in [60, 20, 5, 1]) {
      await db.into(db.dayRollups).insert(
            DayRollupsCompanion.insert(
              day: Value(dayKeyOf(DateTime(2026, 9, 1)) - offset),
              xpEarned: const Value(10),
              xpAvailable: const Value(20),
            ),
          );
    }

    final week = await repo.read(ChartRange.week);
    expect(week.days, hasLength(2), reason: '5 and 1 days ago');
    expect(week.scans, hasLength(2), reason: 'scans are never range-filtered');

    final month = await repo.read(ChartRange.month);
    expect(month.days, hasLength(3), reason: '60 days ago is outside a month');

    final all = await repo.read(ChartRange.all);
    expect(all.days, hasLength(4));
  });

  test('a day with no record stays absent rather than becoming a zero',
      () async {
    final clock = FixedClock(DateTime(2026, 9, 1));
    final repo = ProgressRepository(db, clock: clock);
    await db.into(db.dayRollups).insert(
          DayRollupsCompanion.insert(
            day: Value(dayKeyOf(DateTime(2026, 9, 1))),
            xpEarned: const Value(30),
            xpAvailable: const Value(40),
          ),
        );

    final view = await repo.read(ChartRange.month);

    // One bar, not thirty. Drawing zeros for the twenty-nine days before the
    // app was installed would read as a month of total failure.
    expect(view.days, hasLength(1));
    expect(view.xpInRange, 30);
    expect(view.adherenceInRange, closeTo(0.75, 0.001));
  });

  test('answering a quest moves the numbers the charts read', () async {
    final clock = FixedClock.todayAt(21, 30);
    final quests = QuestRepository(db, clock: clock);
    await quests.materialiseDay(clock.now());
    final today = await quests.watchDay(clock.now()).first;
    await quests.setStatus(today.first, QuestStatus.done);

    final view = await ProgressRepository(db, clock: clock).read(
      ChartRange.week,
    );

    expect(view.hasDays, isTrue);
    expect(view.xpInRange, greaterThan(0));
    expect(view.clearedInRange, 1);
    // The XP landed on a stat, and the donut is drawn from exactly this.
    expect(view.xpByStat.values.fold(0, (a, b) => a + b), view.xpInRange);
  });
}
