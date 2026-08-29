import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/export/export_repository.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
import 'package:the_system/models/models.dart';

/// The backup is the only copy of this data that can leave the phone, so the
/// tests care about one thing above all: that what comes out is complete and
/// actually parses.
void main() {
  late AppDatabase db;
  late QuestRepository quests;
  late ExportRepository export;

  final wednesday = DateTime(2026, 8, 26);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    quests = QuestRepository(db);
    export = ExportRepository(db);
    await quests.materialiseDay(wednesday);
  });

  tearDown(() => db.close());

  test('the export is valid JSON with every table in it', () async {
    final backup = await export.build();
    final decoded = jsonDecode(backup.json) as Map<String, Object?>;

    expect(decoded['app'], 'The System');
    expect(decoded['formatVersion'], ExportRepository.formatVersion);
    expect(decoded['schemaVersion'], db.schemaVersion);
    expect(DateTime.parse(decoded['exportedAt']! as String), isA<DateTime>());

    expect(decoded['taskTemplates'], isNotEmpty);
    expect(decoded['dailyQuests'], isNotEmpty);
    expect(decoded['dayRollups'], isNotEmpty);
    expect(decoded['player'], isA<Map<String, Object?>>());
  });

  test('a completed step is exported with its status and XP', () async {
    final day = await quests.watchDay(wednesday).first;
    final skincare = day.firstWhere((q) => q.template.id == 'morning_skincare');
    await quests.setStatus(skincare, QuestStatus.done);

    final decoded =
        jsonDecode((await export.build()).json) as Map<String, Object?>;
    final rows = (decoded['dailyQuests']! as List).cast<Map<String, Object?>>();
    final row = rows.firstWhere((q) => q['templateId'] == 'morning_skincare');

    expect(row['status'], 'done');
    expect(row['xpAwarded'], 10);
    expect(row['completedAt'], isNotNull);
    // Every day carries a readable date next to its integer key, so the file
    // can be understood by a person and not only re-imported by the app.
    expect(row['date'], '2026-08-26');
    expect(row['scheduledMinutes'], 7 * 60 + 10);
  });

  test('routine timings and the plan itself are part of the backup', () async {
    final decoded =
        jsonDecode((await export.build()).json) as Map<String, Object?>;
    final templates =
        (decoded['taskTemplates']! as List).cast<Map<String, Object?>>();
    final detox = templates.firstWhere((t) => t['id'] == 'detox_drink');

    // Restoring a backup has to restore the PLAN, not just the history.
    expect(detox['scheduledMinutes'], 5 * 60 + 35);
    expect(detox['graceMinutes'], 45);
    expect(detox['xp'], 5);
    expect(detox['schedule'], 'daily');
  });

  test('the summary matches what the file actually contains', () async {
    final backup = await export.build();
    final decoded = jsonDecode(backup.json) as Map<String, Object?>;

    expect(
      backup.summary.templates,
      (decoded['taskTemplates']! as List).length,
    );
    expect(backup.summary.quests, (decoded['dailyQuests']! as List).length);
    expect(backup.summary.bytes, utf8.encode(backup.json).length);
    expect(backup.summary.sizeLabel, contains('KB'));
  });

  test('the activity log is carried across too', () async {
    final day = await quests.watchDay(wednesday).first;
    await quests.setStatus(day.first, QuestStatus.missed);

    final decoded =
        jsonDecode((await export.build()).json) as Map<String, Object?>;
    final log = (decoded['activityLog']! as List).cast<Map<String, Object?>>();

    expect(log, hasLength(1));
    expect(log.single['kind'], 'questMissed');
  });
}
