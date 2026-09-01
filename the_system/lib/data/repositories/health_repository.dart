import 'package:drift/drift.dart';

import '../../game/game.dart';
import '../../models/models.dart';
import '../day_key.dart';
import '../db/database.dart';
import '../health/health_source.dart';
import 'quest_repository.dart';

/// One day of health figures as the app holds them.
class HealthDayView {
  final DateTime date;
  final int? steps;
  final int? sleepMinutes;
  final int? restingHeartRate;
  final int? activeKcal;
  final int? distanceM;
  final int? workoutMinutes;

  const HealthDayView({
    required this.date,
    this.steps,
    this.sleepMinutes,
    this.restingHeartRate,
    this.activeKcal,
    this.distanceM,
    this.workoutMinutes,
  });

  double? get distanceKm => distanceM == null ? null : distanceM! / 1000;

  /// Sleep as "7h 20m", or null.
  String? get sleepLabel {
    final m = sleepMinutes;
    if (m == null) return null;
    return '${m ~/ 60}h ${(m % 60).toString().padLeft(2, '0')}m';
  }
}

/// What a sync did, so the screen can say something specific.
class SyncOutcome {
  final int daysRead;
  final int daysStored;

  /// Quests completed because the day's recorded exercise proved they were.
  final List<String> questsVerified;

  final String? error;

  const SyncOutcome({
    this.daysRead = 0,
    this.daysStored = 0,
    this.questsVerified = const [],
    this.error,
  });

  bool get didSomething => daysStored > 0 || questsVerified.isNotEmpty;
}

/// Reads Health Connect into the System, and lets what it finds close quests.
///
/// ONE-WAY AND READ-ONLY: the System reads, never writes back. It is also
/// entirely optional — every quest can still be answered by hand, which is how
/// the app has worked from the start and how it keeps working when permission
/// is refused.
///
/// The app TOTALS and CHARTS. It does not interpret: no target heart rate, no
/// sleep score, no verdict on whether you are overtraining. That reading
/// belongs to a doctor, exactly as it does for the body scans and blood work.
class HealthRepository {
  final AppDatabase db;
  final HealthSource source;
  final QuestRepository quests;
  final Clock clock;

  /// How many minutes of recorded exercise count as having done the workout.
  ///
  /// Twenty, matching the running prescription in GROUNDWORK. Deliberately not
  /// "any exercise at all": a two-minute walk to the shop tripping the day's
  /// training quest would make the streak meaningless.
  final int workoutMinutesToVerify;

  HealthRepository({
    required this.db,
    required this.source,
    required this.quests,
    this.clock = const Clock(),
    this.workoutMinutesToVerify = 20,
  });

  Future<HealthStatus> status() => source.status();

  Future<HealthStatus> requestPermissions() => source.requestPermissions();

  /// Pulls the last [days] days in and stores the daily totals.
  ///
  /// Re-syncing is safe and expected: today's row is rewritten every time,
  /// because the day is not over and the step count is still climbing.
  Future<SyncOutcome> sync({int days = 30}) async {
    try {
      final read = await source.readDays(days: days);
      if (read.isEmpty) return const SyncOutcome();

      await db.batch((b) {
        b.insertAllOnConflictUpdate(db.healthDays, [
          for (final day in read)
            HealthDaysCompanion.insert(
              day: Value(dayKeyOf(day.date)),
              steps: Value(day.steps),
              sleepMinutes: Value(day.sleepMinutes),
              restingHeartRate: Value(day.restingHeartRate),
              activeKcal: Value(day.activeKcal),
              distanceM: Value(day.distanceM),
              workoutMinutes: Value(day.workoutMinutes),
              syncedAt: clock.now(),
            ),
        ]);
      });

      return SyncOutcome(
        daysRead: read.length,
        daysStored: read.length,
        questsVerified: await _verifyToday(read),
      );
    } catch (error) {
      // Never fatal. Sync is an enhancement; a refused permission or a missing
      // Health Connect must not stop the routine working.
      return SyncOutcome(error: '$error');
    }
  }

  /// Closes today's workout quest if the day's recorded exercise proves it.
  ///
  /// ONLY EVER MARKS DONE, never missed. A phone that failed to record a run
  /// you actually did must not be able to fail your day — the absence of
  /// evidence is not evidence, and the manual answer stays authoritative.
  Future<List<String>> _verifyToday(List<HealthDay> read) async {
    final today = clock.now();
    final key = dayKeyOf(today);

    final match = read.where((d) => dayKeyOf(d.date) == key).toList();
    if (match.isEmpty) return const [];

    final minutes = match.first.workoutMinutes ?? 0;
    if (minutes < workoutMinutesToVerify) return const [];

    final verified = <String>[];
    for (final task in await quests.readDay(today)) {
      final isTraining =
          task.template.category == TaskCategory.workout;
      if (!isTraining || task.status != QuestStatus.pending) continue;
      await quests.setStatus(task, QuestStatus.done);
      verified.add(task.template.title);
    }
    return verified;
  }

  /// Everything synced, oldest first. Not range-filtered here — the screen
  /// decides the window, the same way it does for the rollups.
  Stream<List<HealthDayView>> watch() =>
      (db.select(db.healthDays)
            ..orderBy([(h) => OrderingTerm.asc(h.day)]))
          .watch()
          .map((rows) => [for (final r in rows) _toView(r)]);

  Future<List<HealthDayView>> read() async => [
    for (final r
        in await (db.select(db.healthDays)
              ..orderBy([(h) => OrderingTerm.asc(h.day)]))
            .get())
      _toView(r),
  ];

  /// When the store was last refreshed, or null if it never has been.
  Future<DateTime?> lastSyncedAt() async {
    final row =
        await (db.select(db.healthDays)
              ..orderBy([(h) => OrderingTerm.desc(h.syncedAt)])
              ..limit(1))
            .getSingleOrNull();
    return row?.syncedAt;
  }

  HealthDayView _toView(HealthDayRow r) => HealthDayView(
    date: dateOfDayKey(r.day),
    steps: r.steps,
    sleepMinutes: r.sleepMinutes,
    restingHeartRate: r.restingHeartRate,
    activeKcal: r.activeKcal,
    distanceM: r.distanceM,
    workoutMinutes: r.workoutMinutes,
  );
}
