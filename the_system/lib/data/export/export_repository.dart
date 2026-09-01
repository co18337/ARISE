import 'dart:convert';

import 'package:drift/drift.dart';

import '../day_key.dart';
import '../db/database.dart';
import 'backup_file.dart';

/// What a backup contains, for the screen to show before writing one.
class BackupSummary {
  final int templates;
  final int quests;
  final int days;
  final int logEntries;

  /// The record beyond the routine. Listed separately because these are the
  /// rows that cannot be recreated by turning up tomorrow — a missed quest is
  /// one day, a lost Tanita scan is six months.
  final int sessions;
  final int scans;
  final int labs;
  final int documents;
  final int bytes;

  const BackupSummary({
    required this.templates,
    required this.quests,
    required this.days,
    required this.logEntries,
    required this.sessions,
    required this.scans,
    required this.labs,
    required this.documents,
    required this.bytes,
  });

  /// Rounded to the nearest KB — an exact byte count is noise at this size.
  String get sizeLabel =>
      bytes < 1024 ? '$bytes B' : '${(bytes / 1024).round()} KB';
}

/// A whole backup: the JSON text plus what's in it.
class Backup {
  final String json;
  final BackupSummary summary;

  const Backup({required this.json, required this.summary});
}

/// Exports the entire database as JSON — the manual backup.
///
/// The app is local-first and free, which means there is no server holding a
/// copy of anything. A phone that dies takes the whole record with it, so an
/// export the user can actually keep is not a nice-to-have.
///
/// The format is drift's own `toJson`, on BOTH sides. The first version wrote
/// hand-built maps for readability, and the shapes did not match what
/// `fromJson` expects — so the file looked perfect and could not be read back,
/// which is the one failure a backup exists to prevent. Symmetry beats
/// prettiness here: one serialiser means export and restore cannot drift
/// apart, and a schema change breaks the test rather than the recovery.
class ExportRepository {
  final AppDatabase db;

  ExportRepository(this.db);

  /// Version of the export FORMAT, which is not the schema version — the two
  /// move independently and confusing them is how a restore corrupts a save.
  /// Bumped to 2 when the backup grew from the routine alone to the whole
  /// record. A version 1 file is still readable — it simply carries less.
  static const int formatVersion = 2;

  Future<Backup> build() async {
    final templates = await db.select(db.taskTemplates).get();
    final quests = await db.select(db.dailyQuests).get();
    final rollups = await db.select(db.dayRollups).get();
    final log = await db.select(db.activityLogEntries).get();
    final player =
        await (db.select(db.playerStates)..where((p) => p.id.equals(0)))
            .getSingle();

    final sessions = await db.select(db.workoutSessions).get();
    final sets = await db.select(db.workoutSets).get();
    final food = await db.select(db.foodLogEntries).get();
    final meals = await db.select(db.meals).get();
    final scans = await db.select(db.bodyMeasurements).get();
    final segments = await db.select(db.bodySegments).get();
    final labs = await db.select(db.labResults).get();
    final health = await db.select(db.healthDays).get();
    final reviews = await db.select(db.weeklyReviews).get();
    final deloadRows = await db.select(db.deloads).get();
    final documents = await db.select(db.memoryDocuments).get();

    final payload = <String, Object?>{
      'app': 'The System',
      'formatVersion': formatVersion,
      'schemaVersion': db.schemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      // drift's own toJson on BOTH sides, so export and restore cannot drift
      // apart. These five were hand-written maps for readability, and the
      // shapes did not match what fromJson expects — which meant a backup
      // that looked perfect and could not be read back.
      'player': player.toJson(serializer: _json),
      'taskTemplates': [for (final r in templates) r.toJson(serializer: _json)],
      'dailyQuests': [for (final r in quests) _dated(r.toJson(serializer: _json))],
      'dayRollups': [for (final r in rollups) _dated(r.toJson(serializer: _json))],
      'activityLog': [for (final r in log) r.toJson(serializer: _json)],

      // EVERYTHING ELSE YOU CANNOT GET BACK. The backup used to hold the
      // routine and nothing else — no training history, no body scans, no
      // blood work, no eating. Restoring it would have handed back a third of
      // a life and looked like success.
      'workoutSessions': [for (final r in sessions) _dated(r.toJson(serializer: _json))],
      'workoutSets': [for (final r in sets) r.toJson(serializer: _json)],
      'foodLog': [for (final r in food) _dated(r.toJson(serializer: _json))],
      'meals': [for (final r in meals) r.toJson(serializer: _json)],
      'bodyMeasurements': [for (final r in scans) _dated(r.toJson(serializer: _json))],
      'bodySegments': [for (final r in segments) _dated(r.toJson(serializer: _json))],
      'labResults': [for (final r in labs) _dated(r.toJson(serializer: _json))],
      'healthDays': [for (final r in health) _dated(r.toJson(serializer: _json))],
      'weeklyReviews': [for (final r in reviews) _dated(r.toJson(serializer: _json))],
      'deloads': [for (final r in deloadRows) _dated(r.toJson(serializer: _json))],

      // Documents, not chunks. The vectors are derived and enormous; the text
      // they came from is small and is the thing that cannot be recreated.
      // Restore re-ingests, which re-chunks and re-embeds with whatever
      // embedder is current — which is also how a restore lands on a phone
      // with a different key than the one it left.
      'memoryDocuments': [for (final r in documents) r.toJson(serializer: _json)],
    };

    // Indented on purpose: a backup that can be skimmed in a text editor is
    // worth far more than the bytes saved by packing it onto one line.
    final json = const JsonEncoder.withIndent('  ').convert(payload);

    return Backup(
      json: json,
      summary: BackupSummary(
        templates: templates.length,
        quests: quests.length,
        days: rollups.length,
        logEntries: log.length,
        sessions: sessions.length,
        scans: scans.length,
        labs: labs.length,
        documents: documents.length,
        bytes: utf8.encode(json).length,
      ),
    );
  }

  /// What a restore would do, worked out before anything is touched.
  ///
  /// Read first, act second. A restore replaces everything, so the screen has
  /// to be able to say what is in the file and what it would cost BEFORE the
  /// user agrees to it.
  RestorePlan inspect(String json) {
    final Map<String, Object?> payload;
    try {
      final decoded = jsonDecode(json);
      if (decoded is! Map<String, Object?>) {
        return const RestorePlan.rejected('That is not a System backup.');
      }
      payload = decoded;
    } catch (_) {
      return const RestorePlan.rejected('That is not valid JSON.');
    }

    if (payload['app'] != 'The System') {
      return const RestorePlan.rejected('That backup is from another app.');
    }

    final from = payload['schemaVersion'];
    if (from is int && from > db.schemaVersion) {
      // Refused rather than attempted. A newer backup may hold columns this
      // build has never heard of, and a half-understood restore is worse than
      // none — it looks like it worked.
      return RestorePlan.rejected(
        'That backup is from a newer version of the app (schema $from, this '
        'build is ${db.schemaVersion}). Update before restoring it.',
      );
    }

    int count(String key) => (payload[key] as List?)?.length ?? 0;

    return RestorePlan(
      payload: payload,
      exportedAt: payload['exportedAt'] as String?,
      quests: count('dailyQuests'),
      sessions: count('workoutSessions'),
      meals: count('foodLog'),
      scans: count('bodyMeasurements'),
      labs: count('labResults'),
      documents: count('memoryDocuments'),
    );
  }

  /// Replaces everything with the contents of [plan].
  ///
  /// DESTRUCTIVE and deliberately so: a restore that merged would leave you
  /// with two overlapping histories and no way to tell which day was real.
  ///
  /// One transaction. Either the whole record comes back or the database is
  /// untouched — a restore that fails halfway is the worst possible outcome,
  /// because it destroys what you had AND does not give you what you wanted.
  Future<int> restore(RestorePlan plan) async {
    if (!plan.isValid) throw StateError(plan.problem!);
    final payload = plan.payload!;
    var rows = 0;

    List<Map<String, Object?>> at(String key) => [
      for (final row in (payload[key] as List? ?? const []))
        if (row is Map<String, Object?>) row,
    ];

    await db.transaction(() async {
      // Cleared in DEPENDENCY ORDER — sets before sessions, quests before
      // templates — or the foreign keys refuse before anything is written.
      await db.delete(db.workoutSets).go();
      await db.delete(db.workoutSessions).go();
      await db.delete(db.dailyQuests).go();
      await db.delete(db.taskTemplates).go();
      await db.delete(db.dayRollups).go();
      await db.delete(db.activityLogEntries).go();
      await db.delete(db.foodLogEntries).go();
      await db.delete(db.meals).go();
      await db.delete(db.bodySegments).go();
      await db.delete(db.bodyMeasurements).go();
      await db.delete(db.labResults).go();
      await db.delete(db.healthDays).go();
      await db.delete(db.weeklyReviews).go();
      await db.delete(db.deloads).go();
      await db.delete(db.memoryChunks).go();
      await db.delete(db.memoryDocuments).go();

      final player = payload['player'];
      if (player is Map<String, Object?>) {
        await db
            .into(db.playerStates)
            .insertOnConflictUpdate(PlayerStateRow.fromJson(player, serializer: _json));
        rows++;
      }

      // Written back parents-first, mirroring the order above in reverse.
      // fromJson is drift's own, so enum columns come back as the enums they
      // went out as rather than as loose strings.
      for (final r in at('taskTemplates')) {
        await db
            .into(db.taskTemplates)
            .insertOnConflictUpdate(TaskTemplateRow.fromJson(r, serializer: _json));
        rows++;
      }
      for (final r in at('dailyQuests')) {
        await db
            .into(db.dailyQuests)
            .insertOnConflictUpdate(DailyQuestRow.fromJson(r, serializer: _json));
        rows++;
      }
      for (final r in at('dayRollups')) {
        await db
            .into(db.dayRollups)
            .insertOnConflictUpdate(DayRollupRow.fromJson(r, serializer: _json));
        rows++;
      }
      for (final r in at('activityLog')) {
        await db
            .into(db.activityLogEntries)
            .insertOnConflictUpdate(ActivityLogRow.fromJson(r, serializer: _json));
        rows++;
      }
      for (final r in at('workoutSessions')) {
        await db
            .into(db.workoutSessions)
            .insertOnConflictUpdate(WorkoutSessionRow.fromJson(r, serializer: _json));
        rows++;
      }
      for (final r in at('workoutSets')) {
        await db
            .into(db.workoutSets)
            .insertOnConflictUpdate(WorkoutSetRow.fromJson(r, serializer: _json));
        rows++;
      }
      for (final r in at('meals')) {
        await db.into(db.meals).insertOnConflictUpdate(MealRow.fromJson(r, serializer: _json));
        rows++;
      }
      for (final r in at('foodLog')) {
        await db
            .into(db.foodLogEntries)
            .insertOnConflictUpdate(FoodLogRow.fromJson(r, serializer: _json));
        rows++;
      }
      for (final r in at('bodyMeasurements')) {
        await db
            .into(db.bodyMeasurements)
            .insertOnConflictUpdate(BodyMeasurementRow.fromJson(r, serializer: _json));
        rows++;
      }
      for (final r in at('bodySegments')) {
        await db
            .into(db.bodySegments)
            .insertOnConflictUpdate(BodySegmentRow.fromJson(r, serializer: _json));
        rows++;
      }
      for (final r in at('labResults')) {
        await db
            .into(db.labResults)
            .insertOnConflictUpdate(LabResultRow.fromJson(r, serializer: _json));
        rows++;
      }
      for (final r in at('healthDays')) {
        await db
            .into(db.healthDays)
            .insertOnConflictUpdate(HealthDayRow.fromJson(r, serializer: _json));
        rows++;
      }
      for (final r in at('weeklyReviews')) {
        await db
            .into(db.weeklyReviews)
            .insertOnConflictUpdate(WeeklyReviewRow.fromJson(r, serializer: _json));
        rows++;
      }
      for (final r in at('deloads')) {
        await db.into(db.deloads).insertOnConflictUpdate(DeloadRow.fromJson(r, serializer: _json));
        rows++;
      }
      for (final r in at('memoryDocuments')) {
        await db
            .into(db.memoryDocuments)
            .insertOnConflictUpdate(MemoryDocumentRow.fromJson(r, serializer: _json));
        rows++;
      }
    });

    return rows;
  }

  /// Writes the backup next to the app's own data. Returns the path, or null
  /// on web where there is no file system to write to.
  Future<String?> saveToFile(String json) =>
      saveBackupFile(_fileName(), json);

  /// Hands the backup to the share sheet, which is the only route to storage
  /// that survives uninstalling the app. Returns false if it was dismissed.
  Future<bool> share(String json) => shareBackupFile(_fileName(), json);

  /// Timestamped, because a backup you cannot date is a backup you cannot
  /// choose between.
  static String _fileName() {
    final now = DateTime.now();
    final stamp =
        '${now.year}-${_two(now.month)}-${_two(now.day)}-${_two(now.hour)}${_two(now.minute)}';
    return 'arise-backup-$stamp.json';
  }


  /// A row as drift writes it, plus a readable date beside the integer day
  /// key.
  ///
  /// The extra key costs nothing on the way back in — `fromJson` reads the
  /// fields it knows and ignores the rest — and it is the difference between a
  /// file a person can check and a wall of day numbers. `day` 20693 means
  /// nothing to anyone opening this in a text editor a year from now.
  static Map<String, Object?> _dated(Map<String, Object?> row) {
    final day = row['day'];
    if (day is! int) return row;
    final d = dateOfDayKey(day);
    return {
      ...row,
      'date': '${d.year}-${_two(d.month)}-${_two(d.day)}',
    };
  }

  static String _two(int n) => n.toString().padLeft(2, '0');






}

/// What a backup file holds, and whether it can be restored at all.
class RestorePlan {
  final Map<String, Object?>? payload;
  final String? problem;
  final String? exportedAt;
  final int quests;
  final int sessions;
  final int meals;
  final int scans;
  final int labs;
  final int documents;

  const RestorePlan({
    required this.payload,
    this.exportedAt,
    this.quests = 0,
    this.sessions = 0,
    this.meals = 0,
    this.scans = 0,
    this.labs = 0,
    this.documents = 0,
  }) : problem = null;

  const RestorePlan.rejected(this.problem)
    : payload = null,
      exportedAt = null,
      quests = 0,
      sessions = 0,
      meals = 0,
      scans = 0,
      labs = 0,
      documents = 0;

  bool get isValid => payload != null;

  /// One line describing what is in the file.
  String get summary => '$quests quests · $sessions sessions · $meals meals · '
      '$scans scans · $labs results · $documents documents';
}

/// One serializer for both directions, so an export and a restore cannot
/// disagree about a shape.
///
/// Needed because of a narrow but fatal mismatch: `daysOfWeek` is a
/// `List<int>` behind a type converter, drift writes it as a JSON array, and
/// `jsonDecode` hands every array back as `List<dynamic>`. Drift's default
/// serializer then casts straight to `List<int>` and throws. The backup looked
/// perfect and could not be read back — the exact failure a backup exists to
/// prevent.
class _BackupSerializer extends ValueSerializer {
  const _BackupSerializer();

  static const _defaults = ValueSerializer.defaults();

  @override
  dynamic toJson<T>(T value) => _defaults.toJson<T>(value);

  @override
  T fromJson<T>(dynamic json) {
    if (json is List) {
      // Whether T is `List<int>` or `List<int>?`, captured through a generic
      // because a nullable type has no expression form of its own.
      bool wants<E>() => T == _TypeOf<E>().type || T == _TypeOf<E?>().type;

      // Re-typed rather than cast, so the element type is real.
      if (wants<List<int>>()) return json.cast<int>() as T;
      if (wants<List<String>>()) return json.cast<String>() as T;
      if (wants<List<double>>()) return json.cast<double>() as T;
    }
    return _defaults.fromJson<T>(json);
  }
}

class _TypeOf<T> {
  const _TypeOf();
  Type get type => T;
}

const _json = _BackupSerializer();
