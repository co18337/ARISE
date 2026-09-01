import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart' show debugPrint;

// database.g.dart is a `part of` this file, so it can only see the imports
// declared HERE — that's why the model enums, and TrainingPhase from the game
// engine, are imported even though this file never names them directly.
import '../../game/game.dart';
import '../../models/models.dart';
import '../day_key.dart';
import '../meal_catalog.dart';
import '../task_catalog.dart';
import 'tables.dart';

// Tells build_runner to generate the query API into database.g.dart.
// That generated file is committed but NEVER hand-edited — regenerate with:
//   dart run build_runner build --delete-conflicting-outputs
part 'database.g.dart';

@DriftDatabase(
  tables: [
    TaskTemplates,
    DailyQuests,
    DayRollups,
    PlayerStates,
    ActivityLogEntries,
    WorkoutSessions,
    WorkoutSets,
    MemoryDocuments,
    MemoryChunks,
    Meals,
    FoodLogEntries,
    AiCalls,
    AiCacheEntries,
    BodyMeasurements,
    BodySegments,
    LabResults,
    HealthDays,
    WeeklyReviews,
    Deloads,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Pass an executor in tests (`NativeDatabase.memory()`); leave it out in the
  /// app and it opens the real on-device file.
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 20;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seed();
    },
    // Runs when an existing database was created by an older schemaVersion.
    // Each step is guarded by a version check. Steps are additive by default;
    // where a column genuinely has to go (v3 retires `done`), its values are
    // copied to the replacement FIRST, so no history is ever lost.
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(playerStates, playerStates.perfectDays);
      }
      if (from < 3) {
        await _upgradeToRoutineSchema(m);
      }
      if (from < 4) {
        // Purely additive. The value is backfilled by the first
        // recomputeAll()/openToday() that runs, which rebuilds every cached
        // total from daily_quests anyway.
        await m.addColumn(playerStates, playerStates.questsCleared);
      }
      if (from < 5) {
        // Purely additive, and it defaults to the look the app already had.
        await m.addColumn(playerStates, playerStates.themeMode);
      }
      if (from < 6) {
        // New tables plus one column; nothing existing is touched. The
        // programme start stays null until the first session opens, which is
        // what makes an upgraded database start at week 1 rather than
        // inheriting a week number from data that never existed.
        await m.createTable(workoutSessions);
        await m.createTable(workoutSets);
        await m.addColumn(playerStates, playerStates.programmeStartDay);
      }
      if (from < 7) {
        // New tables only; nothing existing is touched.
        await m.createTable(memoryDocuments);
        await m.createTable(memoryChunks);
      }
      if (from < 8) {
        await m.addColumn(playerStates, playerStates.acknowledgedMedals);
      }
      if (from < 9) {
        await m.createTable(meals);
        // Existing databases have no rotation yet, so seed it here too.
        await _seedMeals();
      }
      if (from < 10) {
        await m.createTable(foodLogEntries);
        await m.createTable(aiCalls);
        await m.createTable(aiCacheEntries);
        // meal_log_entries is superseded: eating is now typed in plain words
        // rather than ticked against the plan, which measures what I ate
        // instead of measuring the plan. It shipped a day earlier and holds no
        // real history, so it goes rather than lingering unread.
        await customStatement('DROP TABLE IF EXISTS meal_log_entries');
      }
      if (from < 11) {
        // Drops the unique key on (day, slot) so a second snack is a second
        // entry rather than an overwrite. alterTable rebuilds the table from
        // the current Dart definition and copies the rows across.
        await m.alterTable(TableMigration(foodLogEntries));
      }
      if (from < 12) {
        // `notes` was never given a migration step of its own — it was added
        // to the table definition, so createTable(from < 6) includes it while
        // a database that reached v6 first never got it. Both are handled the
        // same way now: add the column only if it is genuinely absent.
        await _addColumnIfMissing(m, workoutSessions, workoutSessions.notes);
        await _addColumnIfMissing(
          m,
          workoutSessions,
          workoutSessions.noteSource,
        );
      }
      if (from < 13) {
        await _addColumnIfMissing(
          m,
          workoutSessions,
          workoutSessions.summonedAt,
        );
        await _addColumnIfMissing(m, workoutSets, workoutSets.isExtra);
        await _addColumnIfMissing(m, dayRollups, dayRollups.bonusXp);
      }

      if (from < 14) {
        await m.createTable(bodyMeasurements);
        // Deliberately NOT seeded here. The seeder writes segments and lab
        // results too, and those tables do not exist until the v15 step below
        // creates them — seeding at this point threw "no such table:
        // body_segments" on every upgrade path. v15 runs for everyone who
        // runs this, so the record is still seeded exactly once, after all
        // three tables exist.
      }

      if (from < 15) {
        // v14 shipped a six-column baseline. The real MC-780 report has
        // twenty figures plus five segments, and a transcription that drops
        // most of it is a transcription you have to do again in February.
        //
        // addColumn, NOT alterTable. alterTable rebuilds the table by copying
        // every current column out of the old one — and the old one does not
        // have these yet, so it fails with "no such column: at_minutes".
        // These are all nullable and purely additive, which is exactly what
        // addColumn is for; the existing scan is widened in place rather than
        // rebuilt.
        for (final column in <GeneratedColumn<Object>>[
          bodyMeasurements.atMinutes,
          bodyMeasurements.heightCm,
          bodyMeasurements.bmi,
          bodyMeasurements.fatMassKg,
          bodyMeasurements.fatFreeMassKg,
          bodyMeasurements.skeletalMuscleKg,
          bodyMeasurements.skeletalMusclePercent,
          bodyMeasurements.boneMassKg,
          bodyMeasurements.proteinKg,
          bodyMeasurements.totalBodyWaterKg,
          bodyMeasurements.totalBodyWaterPercent,
          bodyMeasurements.extracellularWaterKg,
          bodyMeasurements.intracellularWaterKg,
          bodyMeasurements.ecwOverTbwPercent,
          bodyMeasurements.bmrKj,
          bodyMeasurements.sarcopenicIndex,
          bodyMeasurements.phaseAngleDeg,
          bodyMeasurements.impedanceOhm,
        ]) {
          await _addColumnIfMissing(m, bodyMeasurements, column);
        }

        await m.createTable(bodySegments);
        await m.createTable(labResults);

        // Seeded HERE, after all three tables exist. The full record is one
        // unit: the scan, its five segments and the panel that was drawn the
        // same morning.
        await _seedHealthRecord();
      }

      if (from < 16) {
        // Purely a new table. Nothing existing is touched, and an empty
        // health_days simply means nothing has been synced yet — which is
        // also true of a fresh install until permission is granted.
        await m.createTable(healthDays);
      }

      if (from < 17) {
        // RENAMING AN ENUM VALUE IS A DATA MIGRATION, and this one was missed.
        // workout_sessions.phase is a textEnum, so the old names were sitting
        // in the database as strings — and the moment TrainingPhase.ignite
        // stopped existing, every attempt to read a stored session threw
        // "No enum value with that name: ignite" and TRAINING died outright.
        //
        // The column sweep below cannot catch this: the column is present and
        // its type is right; it is the VALUE that no longer resolves.
        //
        // ignite covered weeks 1-4, which GROUNDWORK and RESET were split out
        // of, so it maps by week rather than to a single successor.
        await customStatement(
          "UPDATE workout_sessions SET phase = 'groundwork' "
          "WHERE phase = 'ignite' AND week <= 2",
        );
        await customStatement(
          "UPDATE workout_sessions SET phase = 'reset' WHERE phase = 'ignite'",
        );
        await customStatement(
          "UPDATE workout_sessions SET phase = 'fatBurn' WHERE phase = 'reduce'",
        );
        await customStatement(
          "UPDATE workout_sessions SET phase = 'buildSculpt' "
          "WHERE phase = 'build'",
        );
        await customStatement(
          "UPDATE workout_sessions SET phase = 'sharpen' WHERE phase = 'forge'",
        );
      }

      if (from < 18) {
        await m.createTable(weeklyReviews);
      }

      if (from < 19) {
        // Purely additive and nullable: every set logged before this simply
        // has no weight recorded, which is true — it was never asked for.
        await _addColumnIfMissing(m, workoutSets, workoutSets.loadHalfKg);
      }

      if (from < 20) {
        await m.createTable(deloads);
      }

      // A net beneath every step above, and the last thing to run.
      //
      // A purely additive column is easy to declare and easy to forget to
      // migrate, and the failure is brutal and total: createAll gives it to
      // fresh installs, no step gives it to upgraded ones, and drift's row
      // mapper null-checks a non-nullable column — so the app throws
      // "Unexpected null value" on OPEN, before a single screen renders.
      // That shipped in v13 and it is the third time this bug class has bitten
      // (workout notes, note_source, then a stray bonus_xp).
      //
      // This does NOT replace the steps above. A column that needs a BACKFILL
      // — copying values out of a retired column, deriving from another table
      // — still needs its own step, and those run first, so anything they
      // handled is already here. The sweep only ever fires for a column
      // nothing added, which today is a crash rather than a default.
      await _addMissingColumns(m);
    },
    beforeOpen: (details) async {
      // SQLite has foreign keys OFF by default; without this the
      // daily_quests -> task_templates reference would not be enforced.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// First-run seeding. From here on the DATABASE is the source of truth for
  /// the plan — TaskCatalog is only the initial seed, so editing a template
  /// in-app (Phase 9) won't be overwritten on next launch.
  Future<void> _seed() async {
    await _seedHealthRecord();
    final now = DateTime.now();

    await batch((b) {
      b.insertAll(taskTemplates, [
        for (final (index, t) in TaskCatalog.all.indexed)
          TaskTemplatesCompanion.insert(
            id: t.id,
            title: t.title,
            category: t.category,
            stat: t.stat,
            schedule: t.schedule,
            daysOfWeek: Value(t.daysOfWeek),
            xp: t.xp,
            scheduledMinutes: Value(t.scheduledMinutes),
            graceMinutes: Value(t.graceMinutes),
            sortOrder: Value(index),
            createdAt: now,
          ),
      ]);
    });

    await _seedMeals();

    // The singleton player row must exist before anything tries to read it.
    //
    // id is passed EXPLICITLY. In SQLite a single INTEGER primary key is an
    // alias for the rowid, and an omitted rowid gets auto-assigned (1), which
    // silently ignores the column's `DEFAULT 0` — so every later
    // `where(id == 0)` lookup would find nothing.
    //
    // lastActiveDay starts at today so the missed-day backfill has a floor and
    // doesn't try to reconstruct history from before the app existed.
    await into(playerStates).insert(
      PlayerStatesCompanion(
        id: const Value(0),
        hunterName: const Value('PRINCE'),
        lastActiveDay: Value(dayKeyOf(now)),
      ),
    );
  }

  /// Adds a column only if the table does not already have it.
  ///
  /// createTable always builds the CURRENT shape of a table, so a database old
  /// enough to have a table created during its upgrade already has every
  /// column that table will ever have — and a later addColumn for one of them
  /// fails with "duplicate column name". A database that joined later does
  /// need it. Asking SQLite which is which is more reliable than reasoning
  /// about version windows, and it is the reasoning I got wrong once already.
  Future<void> _addColumnIfMissing(
    Migrator m,
    TableInfo<Table, dynamic> table,
    GeneratedColumn<Object> column,
  ) async {
    final info = await customSelect(
      'PRAGMA table_info(${table.actualTableName})',
    ).get();
    final existing = {for (final row in info) row.read<String>('name')};
    if (!existing.contains(column.name)) {
      await m.addColumn(table, column);
    }
  }

  /// Adds any column declared in Dart that the live database is missing.
  ///
  /// Reads the shape from the table definitions themselves, so it keeps
  /// working for v15 and everything after with no edit. `addColumn` refuses a
  /// NOT NULL column with no default, which is the right loud failure — such a
  /// column cannot be added to existing rows without deciding what they say,
  /// and that decision belongs in a real migration step.
  Future<void> _addMissingColumns(Migrator m) async {
    for (final table in allTables) {
      final info = await customSelect(
        'PRAGMA table_info(${table.actualTableName})',
      ).get();
      // Empty means the table itself is new; createTable above already built
      // it at the current shape.
      if (info.isEmpty) continue;
      final existing = {for (final row in info) row.read<String>('name')};
      for (final column in table.$columns) {
        if (!existing.contains(column.name)) {
          debugPrint(
            '[db] healing missing column '
            '${table.actualTableName}.${column.name}',
          );
          await m.addColumn(table, column);
        }
      }
    }
  }

  /// The 7 August 2026 health check: where all of this started.
  ///
  /// Seeded rather than typed in because it is the ORIGIN of every chart. A
  /// progress line whose first point is whenever the app happened to be
  /// installed measures the app, not the transformation.
  ///
  /// Transcribed from the reports themselves — Tanita MC-780 body composition,
  /// the Thyrocare panel and the HCL vitals. Every figure is stored as
  /// PRINTED, including the flags: deciding a value is high is interpretation,
  /// and that belongs to the doctor who ordered the test.
  ///
  /// insertOnConflictUpdate throughout, so re-running corrects a transcription
  /// without touching anything recorded since.
  Future<void> _seedHealthRecord() async {
    const day = 2026 * 10000 + 8 * 100 + 7; // placeholder, replaced below
    final key = dayKeyOf(DateTime(2026, 8, 7));
    assert(day > 0);

    await into(bodyMeasurements).insertOnConflictUpdate(
      BodyMeasurementsCompanion.insert(
        // A lone integer primary key is drift's rowid alias, so the companion
        // makes it optional and it has to be wrapped.
        day: Value(key),
        atMinutes: const Value(12 * 60 + 12),
        weightKg: 79.5,
        heightCm: const Value(182.5),
        bmi: const Value(23.9),
        bodyFatPercent: const Value(25.4),
        fatMassKg: const Value(20.2),
        fatFreeMassKg: const Value(59.3),
        muscleMassKg: const Value(56.2),
        skeletalMuscleKg: const Value(29.1),
        skeletalMusclePercent: const Value(36.6),
        boneMassKg: const Value(3.1),
        proteinKg: const Value(18.9),
        visceralFat: const Value(9),
        totalBodyWaterKg: const Value(37.3),
        totalBodyWaterPercent: const Value(46.9),
        extracellularWaterKg: const Value(15.6),
        intracellularWaterKg: const Value(21.7),
        ecwOverTbwPercent: const Value(41.8),
        bmrKcal: const Value(1713),
        bmrKj: const Value(7172),
        metabolicAge: const Value(37),
        sarcopenicIndex: const Value(8.11),
        phaseAngleDeg: const Value(6.3),
        impedanceOhm: const Value(649),
        source: const Value('Tanita MC-780'),
        note: const Value(
          'Baseline. Fat is carried mainly on the trunk — 11.2 kg of the '
          '20.2 kg total — while every limb reads average or better for '
          'muscle. The first job is reducing trunk fat while holding muscle '
          'mass.',
        ),
      ),
    );

    await batch((b) {
      b.insertAllOnConflictUpdate(bodySegments, [
        for (final seg in const [
          (BodySegment.trunk, 26.7, 11.2, 29.2, 30.7, 1.5, 1, -1),
          (BodySegment.rightArm, 19.4, 0.8, 3.0, 3.2, 0.2, 2, 0),
          (BodySegment.leftArm, 17.3, 0.7, 3.1, 3.3, 0.2, 1, 0),
          (BodySegment.rightLeg, 25.5, 3.8, 10.4, 11.0, 0.6, 2, 0),
          (BodySegment.leftLeg, 25.2, 3.7, 10.5, 11.1, 0.6, 2, 0),
        ])
          BodySegmentsCompanion.insert(
            day: key,
            segment: seg.$1,
            fatPercent: Value(seg.$2),
            fatKg: Value(seg.$3),
            muscleKg: Value(seg.$4),
            fatFreeMassKg: Value(seg.$5),
            otherMassKg: Value(seg.$6),
            fatRating: Value(seg.$7),
            muscleRating: Value(seg.$8),
          ),
      ]);

      b.insertAllOnConflictUpdate(labResults, [
        for (final r in _labBaseline)
          LabResultsCompanion.insert(
            day: key,
            panel: r.$1,
            name: r.$2,
            value: Value(r.$3),
            unit: Value(r.$4),
            refLow: Value(r.$5),
            refHigh: Value(r.$6),
            refText: Value(r.$7),
            flag: Value(r.$8),
            source: Value(r.$9),
          ),
      ]);
    });
  }

  /// The 7 August 2026 panel, exactly as the reports print it.
  ///
  /// (panel, name, value, unit, refLow, refHigh, refText, flag, source).
  /// The three flags are the report's own "Tests Outside Reference Range"
  /// page, not a judgement made here.
  static const List<
    (String, String, double?, String, double?, double?, String, String, String)
  >
  _labBaseline = [
    // --- Lipid.
    ('LIPID', 'Total cholesterol', 132, 'mg/dL', null, 200, '< 200', '', 'Thyrocare'),
    ('LIPID', 'HDL cholesterol', 37, 'mg/dL', 40, 60, '40-60', 'low', 'Thyrocare'),
    ('LIPID', 'LDL cholesterol', 79.23, 'mg/dL', null, 100, '< 100', '', 'Thyrocare'),
    ('LIPID', 'Triglycerides', 68, 'mg/dL', null, 150, '< 150', '', 'Thyrocare'),
    ('LIPID', 'Non-HDL cholesterol', 94.5, 'mg/dL', null, 160, '< 160', '', 'Thyrocare'),
    ('LIPID', 'VLDL cholesterol', 13.54, 'mg/dL', 5, 40, '5 - 40', '', 'Thyrocare'),
    ('LIPID', 'TC / HDL ratio', 3.6, 'ratio', 3, 5, '3 - 5', '', 'Thyrocare'),
    ('LIPID', 'TG / HDL ratio', 1.83, 'ratio', null, 3.12, '< 3.12', '', 'Thyrocare'),
    ('LIPID', 'LDL / HDL ratio', 2.1, 'ratio', 1.5, 3.5, '1.5-3.5', '', 'Thyrocare'),

    // --- Liver.
    ('LIVER', 'SGPT (ALT)', 83.3, 'U/L', null, 45, '< 45', 'high', 'Thyrocare'),
    ('LIVER', 'SGOT (AST)', 31.6, 'U/L', null, 35, '< 35', '', 'Thyrocare'),
    ('LIVER', 'SGOT / SGPT ratio', 0.38, 'ratio', null, 2, '< 2', '', 'Thyrocare'),
    ('LIVER', 'GGT', 21.1, 'U/L', null, 55, '< 55', '', 'Thyrocare'),
    ('LIVER', 'Alkaline phosphatase', 81.69, 'U/L', 45, 129, '45-129', '', 'Thyrocare'),
    ('LIVER', 'Bilirubin total', 0.9, 'mg/dL', 0.3, 1.2, '0.3-1.2', '', 'Thyrocare'),
    ('LIVER', 'Bilirubin direct', 0.15, 'mg/dL', 0, 0.20, '0 - 0.20', '', 'Thyrocare'),
    ('LIVER', 'Bilirubin indirect', 0.75, 'mg/dL', 0, 0.9, '0-0.9', '', 'Thyrocare'),

    // --- Kidney.
    ('KIDNEY', 'Blood urea nitrogen', 12.15, 'mg/dL', 7.94, 20.07, '7.94 - 20.07', '', 'Thyrocare'),
    ('KIDNEY', 'Creatinine', 0.73, 'mg/dL', 0.72, 1.18, '0.72-1.18', '', 'Thyrocare'),
    ('KIDNEY', 'Urea', 26, 'mg/dL', 17, 43, 'Adult : 17-43', '', 'Thyrocare'),
    ('KIDNEY', 'Uric acid', 6.4, 'mg/dL', 4.2, 7.3, '4.2 - 7.3', '', 'Thyrocare'),
    ('KIDNEY', 'Calcium', 9.92, 'mg/dL', 8.8, 10.6, '8.8-10.6', '', 'Thyrocare'),
    ('KIDNEY', 'eGFR', 129, 'mL/min/1.73m²', 90, null, '>= 90 normal', '', 'Thyrocare'),

    // --- Electrolytes.
    ('ELECTROLYTES', 'Sodium', 138.5, 'mmol/L', 136, 145, '136-145', '', 'Thyrocare'),
    ('ELECTROLYTES', 'Potassium', 4.47, 'mmol/L', 3.5, 5.1, '3.5-5.1', '', 'Thyrocare'),
    ('ELECTROLYTES', 'Chloride', 101.1, 'mmol/L', 98, 107, '98-107', '', 'Thyrocare'),

    // --- Hemogram.
    ('HEMOGRAM', 'Haemoglobin', 16.6, 'g/dL', 13.0, 17.0, '13.0-17.0', '', 'Thyrocare'),
    ('HEMOGRAM', 'Haematocrit (PCV)', 51.6, '%', 40.0, 50.0, '40.0-50.0', 'high', 'Thyrocare'),
    ('HEMOGRAM', 'Total RBC', 5.34, '10⁶/µL', 4.5, 5.5, '4.5-5.5', '', 'Thyrocare'),
    ('HEMOGRAM', 'MCV', 96.6, 'fL', 83.0, 101.0, '83.0-101.0', '', 'Thyrocare'),
    ('HEMOGRAM', 'MCH', 31.1, 'pg', 27.0, 32.0, '27.0-32.0', '', 'Thyrocare'),
    ('HEMOGRAM', 'MCHC', 32.2, 'g/dL', 31.5, 34.5, '31.5-34.5', '', 'Thyrocare'),
    ('HEMOGRAM', 'RDW-CV', 12.7, '%', 11.6, 14, '11.6-14', '', 'Thyrocare'),
    ('HEMOGRAM', 'Total leucocyte count', 6.91, '10³/µL', 4.0, 10.0, '4.0 - 10.0', '', 'Thyrocare'),
    ('HEMOGRAM', 'Neutrophils', 56, '%', 40, 80, '40-80', '', 'Thyrocare'),
    ('HEMOGRAM', 'Lymphocytes', 37.2, '%', 20, 40, '20-40', '', 'Thyrocare'),
    ('HEMOGRAM', 'Monocytes', 3.9, '%', 2, 10, '2-10', '', 'Thyrocare'),
    ('HEMOGRAM', 'Eosinophils', 2, '%', 1, 6, '1-6', '', 'Thyrocare'),
    ('HEMOGRAM', 'Basophils', 0.6, '%', 0, 2, '0-2', '', 'Thyrocare'),
    ('HEMOGRAM', 'Platelet count', 268, '10³/µL', 150, 410, '150-410', '', 'Thyrocare'),

    // --- Metabolic.
    ('METABOLIC', 'Fasting blood sugar', 79.9, 'mg/dL', 70.0, 100.0, '70.0-100.0', '', 'Thyrocare'),

    // --- Vitals, from the HCL consult the same morning.
    ('VITALS', 'Height', 182.5, 'cm', null, null, '', '', 'HCL Healthcare'),
    ('VITALS', 'Weight', 78.4, 'kg', null, null, '', '', 'HCL Healthcare'),
    ('VITALS', 'BMI', 23.54, 'kg/m²', 18.5, 25.0, '18.5-25.0', '', 'HCL Healthcare'),
    ('VITALS', 'Blood pressure systolic', 100, 'mmHg', null, null, '', '', 'HCL Healthcare'),
    ('VITALS', 'Blood pressure diastolic', 70, 'mmHg', null, null, '', '', 'HCL Healthcare'),
    ('VITALS', 'Pulse rate', 78, 'bpm', null, null, '', '', 'HCL Healthcare'),
    ('VITALS', 'Respiratory rate', 16, '/min', null, null, '', '', 'HCL Healthcare'),
    ('VITALS', 'SpO2', 98, '%', null, null, '', '', 'HCL Healthcare'),
  ];

  /// Writes the meal rotation. Called on first run and by the v9 upgrade.
  ///
  /// insertOnConflictUpdate rather than insert: re-running it refreshes the
  /// macros of a meal whose numbers were corrected in the catalog, without
  /// touching anything logged against it.
  Future<void> _seedMeals() async {
    await batch((b) {
      b.insertAllOnConflictUpdate(meals, [
        for (final meal in MealCatalog.all)
          MealsCompanion.insert(
            id: meal.id,
            name: meal.name,
            slot: meal.slot,
            daysOfWeek: Value(meal.daysOfWeek),
            kcal: meal.kcal,
            proteinG: meal.proteinG,
            carbsG: meal.carbsG,
            fatG: meal.fatG,
            fibreG: meal.fibreG,
            detail: meal.detail,
          ),
      ]);
    });
  }

  /// Schema v3 — the guided routine.
  ///
  /// Every step is additive except one: the `done` boolean genuinely has to
  /// go, because `status` supersedes it and leaving both would let them
  /// disagree. It is dropped only AFTER its values have been copied across, so
  /// no completion is ever lost.
  Future<void> _upgradeToRoutineSchema(Migrator m) async {
    await m.addColumn(taskTemplates, taskTemplates.scheduledMinutes);
    await m.addColumn(taskTemplates, taskTemplates.graceMinutes);
    await m.addColumn(dayRollups, dayRollups.questsMissed);
    await m.addColumn(dailyQuests, dailyQuests.status);
    await m.addColumn(dailyQuests, dailyQuests.scheduledMinutes);
    await m.addColumn(dailyQuests, dailyQuests.graceMinutes);

    // Carry every existing completion over to the new column. Anything not
    // done becomes `pending`, which is the honest starting point: the routine
    // engine will close it as missed once it sees the window has shut.
    await customStatement(
      "UPDATE daily_quests SET status = 'done' WHERE done = 1",
    );
    await customStatement('ALTER TABLE daily_quests DROP COLUMN done');

    await _applyRoutineTimings();
  }

  /// Writes the catalog's routine timings onto templates that were seeded
  /// before times existed, and copies them onto already-issued quests.
  ///
  /// Matched by id rather than by position, so a template the user has since
  /// added in-app is simply left alone instead of being given someone else's
  /// schedule.
  Future<void> _applyRoutineTimings() async {
    for (final (index, t) in TaskCatalog.all.indexed) {
      await (update(taskTemplates)..where((row) => row.id.equals(t.id))).write(
        TaskTemplatesCompanion(
          scheduledMinutes: Value(t.scheduledMinutes),
          graceMinutes: Value(t.graceMinutes),
          // The catalog is now kept in routine order, so re-seeding sortOrder
          // puts existing rows into the same order the day is walked in.
          sortOrder: Value(index),
        ),
      );
    }

    // Quests snapshot their timings, so existing rows need the values copied
    // across; without this every past quest would look like an "anytime" step.
    await customStatement('''
      UPDATE daily_quests SET
        scheduled_minutes = (
          SELECT scheduled_minutes FROM task_templates
          WHERE task_templates.id = daily_quests.template_id
        ),
        grace_minutes = COALESCE((
          SELECT grace_minutes FROM task_templates
          WHERE task_templates.id = daily_quests.template_id
        ), 120)
    ''');
  }
}

/// Opens the on-device database. drift_flutter picks the right backend per
/// platform: a `the_system.sqlite` file in the app documents directory on
/// Android, and sqlite3 compiled to WebAssembly (backed by OPFS or IndexedDB)
/// in the browser.
///
/// The `web:` options are REQUIRED — drift_flutter throws an ArgumentError on
/// web without them, and because this runs in main() before runApp() the app
/// dies before painting anything, showing a blank white page with no clue.
/// The two URIs are relative to the web root, i.e. the files committed in
/// `web/`. They are version-pinned to drift/sqlite3 — see ARCHITECTURE.md.
QueryExecutor _openConnection() => driftDatabase(
  name: 'the_system',
  web: DriftWebOptions(
    sqlite3Wasm: Uri.parse('sqlite3.wasm'),
    driftWorker: Uri.parse('drift_worker.js'),
    onResult: _reportWebStorage,
  ),
);

/// Logs which storage backend the browser actually gave us.
///
/// This matters because the unreliable ones LOSE DATA SILENTLY — a quest ticked
/// just before a reload can simply not be there afterwards, with no error.
/// Without cross-origin isolation Chrome falls back to an IndexedDB-emulated
/// file system; see the run command in ARCHITECTURE.md. Android is unaffected
/// (it uses a real SQLite file), so this is a dev-on-web concern only.
void _reportWebStorage(WasmDatabaseResult result) {
  final bool durable = switch (result.chosenImplementation) {
    WasmStorageImplementation.opfsShared ||
    WasmStorageImplementation.opfsLocks => true,
    _ => false,
  };

  if (durable) {
    debugPrint('[db] web storage: ${result.chosenImplementation.name} (durable)');
  } else {
    debugPrint(
      '[db] WARNING: web storage is ${result.chosenImplementation.name}, which '
      'can lose recent writes on reload. Missing browser features: '
      '${result.missingFeatures}. Run with the cross-origin isolation headers '
      '(see ./run_web.sh) to get durable OPFS storage.',
    );
  }
}
