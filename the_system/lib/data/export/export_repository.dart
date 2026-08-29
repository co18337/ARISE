import 'dart:convert';

import '../day_key.dart';
import '../db/database.dart';
import 'backup_file.dart';

/// What a backup contains, for the screen to show before writing one.
class BackupSummary {
  final int templates;
  final int quests;
  final int days;
  final int logEntries;
  final int bytes;

  const BackupSummary({
    required this.templates,
    required this.quests,
    required this.days,
    required this.logEntries,
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
/// The format is built BY HAND rather than from drift's `toJson`. A backup is
/// a contract: it has to keep meaning the same thing after the schema changes,
/// and generated serialisation quietly changes shape whenever a column does.
/// Every row also carries a human-readable date next to its integer day
/// number, so the file can be read by a person, not just re-imported.
class ExportRepository {
  final AppDatabase db;

  ExportRepository(this.db);

  /// Version of the export FORMAT, which is not the schema version — the two
  /// move independently and confusing them is how a restore corrupts a save.
  static const int formatVersion = 1;

  Future<Backup> build() async {
    final templates = await db.select(db.taskTemplates).get();
    final quests = await db.select(db.dailyQuests).get();
    final rollups = await db.select(db.dayRollups).get();
    final log = await db.select(db.activityLogEntries).get();
    final player =
        await (db.select(db.playerStates)..where((p) => p.id.equals(0)))
            .getSingle();

    final payload = <String, Object?>{
      'app': 'The System',
      'formatVersion': formatVersion,
      'schemaVersion': db.schemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'player': _player(player),
      'taskTemplates': templates.map(_template).toList(),
      'dailyQuests': quests.map(_quest).toList(),
      'dayRollups': rollups.map(_rollup).toList(),
      'activityLog': log.map(_logEntry).toList(),
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
        bytes: utf8.encode(json).length,
      ),
    );
  }

  /// Writes the backup next to the app's own data. Returns the path, or null
  /// on web where there is no file system to write to.
  Future<String?> saveToFile(String json) {
    final now = DateTime.now();
    final stamp =
        '${now.year}-${_two(now.month)}-${_two(now.day)}-${_two(now.hour)}${_two(now.minute)}';
    return saveBackupFile('the-system-backup-$stamp.json', json);
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  Map<String, Object?> _player(PlayerStateRow p) => {
    'hunterName': p.hunterName,
    'totalXp': p.totalXp,
    'statXp': {
      'str': p.strXp,
      'sta': p.staXp,
      'dis': p.disXp,
      'rec': p.recXp,
    },
    'currentStreak': p.currentStreak,
    'longestStreak': p.longestStreak,
    'perfectDays': p.perfectDays,
    'lastActiveDay': p.lastActiveDay,
    'acknowledgedLevel': p.acknowledgedLevel,
    'acknowledgedRank': p.acknowledgedRank,
  };

  Map<String, Object?> _template(TaskTemplateRow t) => {
    'id': t.id,
    'title': t.title,
    'category': t.category.name,
    'stat': t.stat.name,
    'schedule': t.schedule.name,
    'daysOfWeek': t.daysOfWeek,
    'xp': t.xp,
    'scheduledMinutes': t.scheduledMinutes,
    'graceMinutes': t.graceMinutes,
    'isActive': t.isActive,
    'sortOrder': t.sortOrder,
    'createdAt': t.createdAt.toIso8601String(),
    'archivedAt': t.archivedAt?.toIso8601String(),
  };

  Map<String, Object?> _quest(DailyQuestRow q) => {
    'id': q.id,
    'templateId': q.templateId,
    'day': q.day,
    'date': _isoDate(q.day),
    'status': q.status.name,
    'completedAt': q.completedAt?.toIso8601String(),
    'xpAwarded': q.xpAwarded,
    'stat': q.stat.name,
    'scheduledMinutes': q.scheduledMinutes,
    'graceMinutes': q.graceMinutes,
  };

  Map<String, Object?> _rollup(DayRollupRow r) => {
    'day': r.day,
    'date': _isoDate(r.day),
    'xpEarned': r.xpEarned,
    'xpAvailable': r.xpAvailable,
    'questsCleared': r.questsCleared,
    'questsMissed': r.questsMissed,
    'questsTotal': r.questsTotal,
    'isPerfect': r.isPerfect,
    'statXp': {
      'str': r.strXp,
      'sta': r.staXp,
      'dis': r.disXp,
      'rec': r.recXp,
    },
  };

  Map<String, Object?> _logEntry(ActivityLogRow e) => {
    'at': e.at.toIso8601String(),
    'kind': e.kind.name,
    'title': e.title,
    'detail': e.detail,
    'xpDelta': e.xpDelta,
  };

  /// The calendar date an integer day number stands for, as YYYY-MM-DD.
  static String _isoDate(int day) {
    final d = dateOfDayKey(day);
    return '${d.year}-${_two(d.month)}-${_two(d.day)}';
  }
}
