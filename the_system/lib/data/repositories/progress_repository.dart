import 'package:drift/drift.dart';

import '../../game/game.dart';
import '../../models/models.dart';
import '../day_key.dart';
import '../db/database.dart';
import 'health_repository.dart';

/// How far back a chart looks.
///
/// A month by default, because that is the window where a daily habit is
/// legible: seven days is noise and a year is a smear. The longer ranges exist
/// for later, when there is a year to look at.
enum ChartRange {
  week('7D', 7),
  month('1M', 30),
  quarter('3M', 90),
  all('ALL', 0);

  final String label;

  /// Days back from today. Zero means everything ever recorded.
  final int days;

  const ChartRange(this.label, this.days);

  bool get isAll => days == 0;
}

/// One region of one scan.
class SegmentReading {
  final BodySegment segment;
  final double? fatPercent;
  final double? fatKg;
  final double? muscleKg;
  final double? fatFreeMassKg;
  final double? otherMassKg;
  final int? fatRating;
  final int? muscleRating;

  const SegmentReading({
    required this.segment,
    this.fatPercent,
    this.fatKg,
    this.muscleKg,
    this.fatFreeMassKg,
    this.otherMassKg,
    this.fatRating,
    this.muscleRating,
  });
}

/// One body-composition scan, the whole panel.
class BodyScan {
  final DateTime date;
  final int? atMinutes;
  final double weightKg;
  final double? heightCm;
  final double? bmi;
  final double? bodyFatPercent;

  /// Measured, not derived. The MC-780 prints it, so it is stored rather than
  /// recomputed from weight × percent — those disagree in the last decimal and
  /// the report is the record.
  final double? fatMassKg;
  final double? fatFreeMassKg;
  final double? muscleMassKg;
  final double? skeletalMuscleKg;
  final double? skeletalMusclePercent;
  final double? boneMassKg;
  final double? proteinKg;
  final int? visceralFat;
  final double? totalBodyWaterKg;
  final double? totalBodyWaterPercent;
  final double? extracellularWaterKg;
  final double? intracellularWaterKg;
  final double? ecwOverTbwPercent;
  final int? bmrKcal;
  final int? bmrKj;
  final int? metabolicAge;
  final double? sarcopenicIndex;
  final double? phaseAngleDeg;
  final int? impedanceOhm;
  final String source;
  final String? note;

  /// Oldest-to-newest order as printed on the report.
  final List<SegmentReading> segments;

  const BodyScan({
    required this.date,
    required this.weightKg,
    this.atMinutes,
    this.heightCm,
    this.bmi,
    this.bodyFatPercent,
    this.fatMassKg,
    this.fatFreeMassKg,
    this.muscleMassKg,
    this.skeletalMuscleKg,
    this.skeletalMusclePercent,
    this.boneMassKg,
    this.proteinKg,
    this.visceralFat,
    this.totalBodyWaterKg,
    this.totalBodyWaterPercent,
    this.extracellularWaterKg,
    this.intracellularWaterKg,
    this.ecwOverTbwPercent,
    this.bmrKcal,
    this.bmrKj,
    this.metabolicAge,
    this.sarcopenicIndex,
    this.phaseAngleDeg,
    this.impedanceOhm,
    this.source = '',
    this.note,
    this.segments = const [],
  });

  bool get hasSegments => segments.isNotEmpty;
}

/// One line from a lab report, with the range it was printed against.
class LabResult {
  final DateTime date;
  final String panel;
  final String name;
  final double? value;
  final String? textValue;
  final String unit;
  final String refText;

  /// As flagged on the report: '', 'high', 'low'. Copied, never decided here.
  final String flag;
  final String source;

  const LabResult({
    required this.date,
    required this.panel,
    required this.name,
    this.value,
    this.textValue,
    this.unit = '',
    this.refText = '',
    this.flag = '',
    this.source = '',
  });

  bool get isFlagged => flag.isNotEmpty;

  String get reading {
    final v = textValue ?? _trim(value);
    return unit.isEmpty ? v : '$v $unit';
  }

  static String _trim(double? v) {
    if (v == null) return '—';
    return v == v.roundToDouble() ? v.toStringAsFixed(0) : '$v';
  }
}

/// A single day on a chart.
class DayPoint {
  final DateTime date;
  final int xpEarned;
  final int xpAvailable;
  final int questsCleared;
  final int questsMissed;
  final int questsTotal;
  final bool isPerfect;
  final int strXp;
  final int staXp;
  final int disXp;
  final int recXp;

  const DayPoint({
    required this.date,
    required this.xpEarned,
    required this.xpAvailable,
    required this.questsCleared,
    required this.questsMissed,
    required this.questsTotal,
    required this.isPerfect,
    required this.strXp,
    required this.staXp,
    required this.disXp,
    required this.recXp,
  });

  /// What share of the day's available XP was actually earned. The honest
  /// adherence number: 40 XP out of 40 is a full day whether the plan asked
  /// for four steps or fourteen.
  double get adherence => xpAvailable <= 0 ? 0 : xpEarned / xpAvailable;
}

/// Everything the PROGRESS screen draws, read in one pass.
class ProgressView {
  final ChartRange range;

  /// Oldest first. Only days the app actually recorded — a gap is a day the
  /// app was never opened, and drawing a zero there would be a lie.
  final List<DayPoint> days;

  /// Oldest first, every scan ever, regardless of [range]: two points three
  /// months apart are the whole chart, and filtering them to "last 7 days"
  /// would empty it.
  final List<BodyScan> scans;

  /// Every lab line ever recorded, newest report first. Not range-filtered,
  /// for the same reason the scans are not: a panel is run twice a year.
  final List<LabResult> labs;

  /// Synced health days, oldest first, RANGE-FILTERED.
  ///
  /// Unlike the scans and the labs, this is daily data over months — which is
  /// precisely what the range filter was built for and, until Health Connect
  /// arrived, had nothing to filter but the XP bars.
  final List<HealthDayView> health;

  const ProgressView({
    required this.range,
    required this.days,
    required this.scans,
    this.labs = const [],
    this.health = const [],
  });

  bool get hasHealth => health.isNotEmpty;

  /// Days in the window that actually reported steps.
  List<HealthDayView> get stepDays => [
    for (final d in health)
      if (d.steps != null) d,
  ];

  List<HealthDayView> get sleepDays => [
    for (final d in health)
      if (d.sleepMinutes != null) d,
  ];

  List<HealthDayView> get heartDays => [
    for (final d in health)
      if (d.restingHeartRate != null) d,
  ];

  int get totalSteps =>
      stepDays.fold(0, (sum, d) => sum + (d.steps ?? 0));

  /// Mean over the days that REPORTED, not over the window. A phone left at
  /// home does not lower your average; it simply says nothing about that day.
  int get averageSteps =>
      stepDays.isEmpty ? 0 : totalSteps ~/ stepDays.length;

  String? get averageSleepLabel {
    if (sleepDays.isEmpty) return null;
    final mins =
        sleepDays.fold(0, (sum, d) => sum + (d.sleepMinutes ?? 0)) ~/
        sleepDays.length;
    return '${mins ~/ 60}h ${(mins % 60).toString().padLeft(2, '0')}m';
  }

  int? get averageRestingHeartRate {
    if (heartDays.isEmpty) return null;
    return heartDays.fold(0, (sum, d) => sum + (d.restingHeartRate ?? 0)) ~/
        heartDays.length;
  }

  double get totalDistanceKm =>
      health.fold(0.0, (sum, d) => sum + (d.distanceM ?? 0) / 1000);

  /// Lab lines grouped by the panel they were printed under, in report order.
  Map<String, List<LabResult>> get labsByPanel {
    final grouped = <String, List<LabResult>>{};
    for (final lab in labs) {
      grouped.putIfAbsent(lab.panel, () => []).add(lab);
    }
    return grouped;
  }

  /// The lines the REPORT flagged. Not a diagnosis and not computed here —
  /// this is the report's own "outside reference range" page.
  List<LabResult> get flaggedLabs => [
    for (final lab in labs)
      if (lab.isFlagged) lab,
  ];

  DateTime? get lastLabDate => labs.isEmpty ? null : labs.first.date;

  bool get hasDays => days.isNotEmpty;

  /// A trend needs two points. One scan is a reading, not a direction.
  bool get hasTrend => scans.length >= 2;

  BodyScan? get baseline => scans.isEmpty ? null : scans.first;

  BodyScan? get latest => scans.isEmpty ? null : scans.last;

  int get xpInRange =>
      days.fold(0, (sum, d) => sum + d.xpEarned);

  int get clearedInRange =>
      days.fold(0, (sum, d) => sum + d.questsCleared);

  int get missedInRange =>
      days.fold(0, (sum, d) => sum + d.questsMissed);

  int get perfectInRange => days.where((d) => d.isPerfect).length;

  /// Mean adherence across the days that had anything scheduled.
  double get adherenceInRange {
    final counted = days.where((d) => d.xpAvailable > 0).toList();
    if (counted.isEmpty) return 0;
    return counted.map((d) => d.adherence).reduce((a, b) => a + b) /
        counted.length;
  }

  /// Lifetime XP by stat over the range, for the split donut.
  Map<StatType, int> get xpByStat => {
    StatType.str: days.fold(0, (s, d) => s + d.strXp),
    StatType.sta: days.fold(0, (s, d) => s + d.staXp),
    StatType.dis: days.fold(0, (s, d) => s + d.disXp),
    StatType.rec: days.fold(0, (s, d) => s + d.recXp),
  };
}

/// Reads the history behind the charts.
///
/// Everything here is a READ. The rollups are written by QuestRepository as the
/// day is answered; body scans are entered by hand after a real measurement.
/// This class does not compute progress, it reports what happened.
class ProgressRepository {
  final AppDatabase db;
  final Clock clock;

  ProgressRepository(this.db, {this.clock = const Clock()});

  /// Live for the whole screen: a quest answered while PROGRESS is open moves
  /// today's bar.
  Stream<ProgressView> watch(ChartRange range) {
    final from = range.isAll
        ? null
        : dayKeyOf(clock.now()) - (range.days - 1);

    final rollups = db.select(db.dayRollups)
      ..orderBy([(r) => OrderingTerm.asc(r.day)]);
    if (from != null) rollups.where((r) => r.day.isBiggerOrEqualValue(from));

    final scans = db.select(db.bodyMeasurements)
      ..orderBy([(m) => OrderingTerm.asc(m.day)]);

    // Two tables, one view: combineLatest so either one changing redraws the
    // screen. Watching only the rollups is the bug that made a logged set fail
    // to move the training session.
    return rollups.watch().asyncMap((rows) async {
      final measurements = await scans.get();
      // One query for every segment rather than one per scan: two scans of
      // five segments is ten round trips through the executor for no reason.
      final segments = await (db.select(db.bodySegments)
            ..orderBy([(seg) => OrderingTerm.asc(seg.day)]))
          .get();
      final labs = await (db.select(db.labResults)
            ..orderBy([(l) => OrderingTerm.desc(l.day)]))
          .get();

      final healthQuery = db.select(db.healthDays)
        ..orderBy([(h) => OrderingTerm.asc(h.day)]);
      if (from != null) {
        healthQuery.where((h) => h.day.isBiggerOrEqualValue(from));
      }
      final healthRows = await healthQuery.get();

      final byDay = <int, List<SegmentReading>>{};
      for (final seg in segments) {
        byDay.putIfAbsent(seg.day, () => []).add(_toSegment(seg));
      }

      return ProgressView(
        range: range,
        days: [for (final r in rows) _toPoint(r)],
        scans: [
          for (final m in measurements) _toScan(m, byDay[m.day] ?? const []),
        ],
        labs: [for (final l in labs) _toLab(l)],
        health: [for (final h in healthRows) _toHealth(h)],
      );
    });
  }

  Future<ProgressView> read(ChartRange range) => watch(range).first;

  /// Records a scan. Same day twice replaces it — correcting a typo should not
  /// leave two contradictory readings on one date.
  Future<void> recordScan({
    required DateTime date,
    required double weightKg,
    int? atMinutes,
    double? heightCm,
    double? bmi,
    double? bodyFatPercent,
    double? fatMassKg,
    double? fatFreeMassKg,
    double? muscleMassKg,
    double? skeletalMuscleKg,
    double? skeletalMusclePercent,
    double? boneMassKg,
    double? proteinKg,
    int? visceralFat,
    double? totalBodyWaterKg,
    double? totalBodyWaterPercent,
    double? extracellularWaterKg,
    double? intracellularWaterKg,
    double? ecwOverTbwPercent,
    int? bmrKcal,
    int? bmrKj,
    int? metabolicAge,
    double? sarcopenicIndex,
    double? phaseAngleDeg,
    int? impedanceOhm,
    String source = '',
    String? note,
    List<SegmentReading> segments = const [],
  }) async {
    final key = dayKeyOf(date);
    await db.into(db.bodyMeasurements).insertOnConflictUpdate(
      BodyMeasurementsCompanion.insert(
        day: Value(key),
        atMinutes: Value(atMinutes),
        weightKg: weightKg,
        heightCm: Value(heightCm),
        bmi: Value(bmi),
        bodyFatPercent: Value(bodyFatPercent),
        fatMassKg: Value(fatMassKg),
        fatFreeMassKg: Value(fatFreeMassKg),
        muscleMassKg: Value(muscleMassKg),
        skeletalMuscleKg: Value(skeletalMuscleKg),
        skeletalMusclePercent: Value(skeletalMusclePercent),
        boneMassKg: Value(boneMassKg),
        proteinKg: Value(proteinKg),
        visceralFat: Value(visceralFat),
        totalBodyWaterKg: Value(totalBodyWaterKg),
        totalBodyWaterPercent: Value(totalBodyWaterPercent),
        extracellularWaterKg: Value(extracellularWaterKg),
        intracellularWaterKg: Value(intracellularWaterKg),
        ecwOverTbwPercent: Value(ecwOverTbwPercent),
        bmrKcal: Value(bmrKcal),
        bmrKj: Value(bmrKj),
        metabolicAge: Value(metabolicAge),
        sarcopenicIndex: Value(sarcopenicIndex),
        phaseAngleDeg: Value(phaseAngleDeg),
        impedanceOhm: Value(impedanceOhm),
        source: Value(source),
        note: Value(note),
      ),
    );

    if (segments.isEmpty) return;
    await db.batch((b) {
      b.insertAllOnConflictUpdate(db.bodySegments, [
        for (final seg in segments)
          BodySegmentsCompanion.insert(
            day: key,
            segment: seg.segment,
            fatPercent: Value(seg.fatPercent),
            fatKg: Value(seg.fatKg),
            muscleKg: Value(seg.muscleKg),
            fatFreeMassKg: Value(seg.fatFreeMassKg),
            otherMassKg: Value(seg.otherMassKg),
            fatRating: Value(seg.fatRating),
            muscleRating: Value(seg.muscleRating),
          ),
      ]);
    });
  }

  /// Records one line of a lab report, exactly as printed.
  Future<void> recordLab({
    required DateTime date,
    required String panel,
    required String name,
    double? value,
    String? textValue,
    String unit = '',
    double? refLow,
    double? refHigh,
    String refText = '',
    String flag = '',
    String source = '',
  }) => db.into(db.labResults).insertOnConflictUpdate(
    LabResultsCompanion.insert(
      day: dayKeyOf(date),
      panel: panel,
      name: name,
      value: Value(value),
      textValue: Value(textValue),
      unit: Value(unit),
      refLow: Value(refLow),
      refHigh: Value(refHigh),
      refText: Value(refText),
      flag: Value(flag),
      source: Value(source),
    ),
  );

  DayPoint _toPoint(DayRollupRow r) => DayPoint(
    date: dateOfDayKey(r.day),
    xpEarned: r.xpEarned,
    xpAvailable: r.xpAvailable,
    questsCleared: r.questsCleared,
    questsMissed: r.questsMissed,
    questsTotal: r.questsTotal,
    isPerfect: r.isPerfect,
    strXp: r.strXp,
    staXp: r.staXp,
    disXp: r.disXp,
    recXp: r.recXp,
  );

  BodyScan _toScan(BodyMeasurementRow m, List<SegmentReading> segments) =>
      BodyScan(
        date: dateOfDayKey(m.day),
        atMinutes: m.atMinutes,
        weightKg: m.weightKg,
        heightCm: m.heightCm,
        bmi: m.bmi,
        bodyFatPercent: m.bodyFatPercent,
        fatMassKg: m.fatMassKg,
        fatFreeMassKg: m.fatFreeMassKg,
        muscleMassKg: m.muscleMassKg,
        skeletalMuscleKg: m.skeletalMuscleKg,
        skeletalMusclePercent: m.skeletalMusclePercent,
        boneMassKg: m.boneMassKg,
        proteinKg: m.proteinKg,
        visceralFat: m.visceralFat,
        totalBodyWaterKg: m.totalBodyWaterKg,
        totalBodyWaterPercent: m.totalBodyWaterPercent,
        extracellularWaterKg: m.extracellularWaterKg,
        intracellularWaterKg: m.intracellularWaterKg,
        ecwOverTbwPercent: m.ecwOverTbwPercent,
        bmrKcal: m.bmrKcal,
        bmrKj: m.bmrKj,
        metabolicAge: m.metabolicAge,
        sarcopenicIndex: m.sarcopenicIndex,
        phaseAngleDeg: m.phaseAngleDeg,
        impedanceOhm: m.impedanceOhm,
        source: m.source,
        note: m.note,
        segments: segments,
      );

  SegmentReading _toSegment(BodySegmentRow r) => SegmentReading(
    segment: r.segment,
    fatPercent: r.fatPercent,
    fatKg: r.fatKg,
    muscleKg: r.muscleKg,
    fatFreeMassKg: r.fatFreeMassKg,
    otherMassKg: r.otherMassKg,
    fatRating: r.fatRating,
    muscleRating: r.muscleRating,
  );

  HealthDayView _toHealth(HealthDayRow r) => HealthDayView(
    date: dateOfDayKey(r.day),
    steps: r.steps,
    sleepMinutes: r.sleepMinutes,
    restingHeartRate: r.restingHeartRate,
    activeKcal: r.activeKcal,
    distanceM: r.distanceM,
    workoutMinutes: r.workoutMinutes,
  );

  LabResult _toLab(LabResultRow r) => LabResult(
    date: dateOfDayKey(r.day),
    panel: r.panel,
    name: r.name,
    value: r.value,
    textValue: r.textValue,
    unit: r.unit,
    refText: r.refText,
    flag: r.flag,
    source: r.source,
  );
}
