import 'package:drift/drift.dart';

import '../../ai/ai_result.dart';
import '../../ai/lanes/nutrition_lane.dart';
import '../../game/game.dart';
import '../../models/models.dart';
import '../day_key.dart';
import '../db/database.dart';
import '../memory/memory_repository.dart';

/// One thing eaten, as typed.
class FoodEntry {
  final int id;
  final MealSlot slot;

  /// Exactly what was written. The source of truth.
  final String body;

  final DateTime loggedAt;
  final MacroSource source;
  final double? confidence;
  final MacroTotals? macros;
  final List<AnalysedItem> items;
  final String? analysisError;

  const FoodEntry({
    required this.id,
    required this.slot,
    required this.body,
    required this.loggedAt,
    required this.source,
    required this.confidence,
    required this.macros,
    required this.items,
    required this.analysisError,
  });

  bool get costed => macros != null;

  /// Low enough that the screen should say what was assumed rather than show
  /// the number as if it were measured.
  bool get uncertain =>
      source == MacroSource.model && (confidence ?? 1) < 0.6;
}

/// A day of eating: what was typed, and what the plan suggested.
class IntakeDay {
  final DateTime date;

  /// What was actually eaten.
  final List<FoodEntry> entries;

  /// What the rotation SUGGESTED. Reference only — nothing is logged from it.
  final List<Meal> plan;

  final NutritionTargets targets;

  const IntakeDay({
    required this.date,
    required this.entries,
    required this.plan,
    required this.targets,
  });

  static IntakeDay empty(DateTime date) => IntakeDay(
    date: date,
    entries: const [],
    plan: const [],
    targets: NutritionTargets.plan,
  );

  /// Everything eaten in a slot — there can be more than one.
  List<FoodEntry> forSlot(MealSlot slot) =>
      [for (final e in entries) if (e.slot == slot) e];

  Meal? planFor(MealSlot slot) {
    for (final meal in plan) {
      if (meal.slot == slot) return meal;
    }
    return null;
  }

  /// Only COSTED entries count. Something typed but not yet analysed is not
  /// zero calories — it is unknown, and adding it in as zero would make a
  /// half-logged day look like a light one.
  MacroTotals get eaten => entries
      .where((e) => e.costed)
      .fold(MacroTotals.zero, (sum, e) => sum.plus(e.macros!));

  int get typedCount => entries.where((e) => e.body.trim().isNotEmpty).length;
  int get costedCount => entries.where((e) => e.costed).length;

  /// True when something was typed but never costed — the totals below are
  /// incomplete and the screen should admit it.
  bool get hasUncosted => typedCount > costedCount;

  List<MacroProgress> get breakdown => macroBreakdown(eaten, targets);
}

/// The only thing the UI talks to for eating.
///
/// The design turned over here: the app used to ask "did you follow the plan?"
/// and tick meals off it. It now asks "what did you eat?" and takes plain
/// text. Adherence to an ideal plan measures the plan; typed text measures the
/// person. The rotation survives as REFERENCE — something to cook from — and
/// nothing is logged against it.
class NutritionRepository {
  final AppDatabase db;
  final Clock clock;
  final MemoryRepository? memory;

  /// Null until a Gemini key exists. Everything works without it; the macros
  /// are simply typed by hand instead of estimated.
  final NutritionLane? lane;

  NutritionRepository(
    this.db, {
    this.clock = const Clock(),
    this.memory,
    this.lane,
  });

  bool get canAnalyse => lane != null;

  Stream<IntakeDay> watchDay(DateTime date) {
    final key = dayKeyOf(date);

    return (db.select(db.foodLogEntries)..where((e) => e.day.equals(key)))
        .watch()
        .asyncMap((rows) async => _assemble(date, rows));
  }

  Future<IntakeDay> readDay(DateTime date) async {
    final key = dayKeyOf(date);
    final rows = await (db.select(db.foodLogEntries)
          ..where((e) => e.day.equals(key)))
        .get();
    return _assemble(date, rows);
  }

  /// Adds what was eaten. Always a NEW entry.
  ///
  /// Two snacks in an afternoon are two entries, not one overwritten — the
  /// second is a different thing you ate, and merging them into one sentence
  /// would lose when each happened and make the estimate harder to check.
  Future<int> addEntry(DateTime date, MealSlot slot, String body) async {
    final trimmed = body.trim();
    if (trimmed.isEmpty) return 0;

    return db.into(db.foodLogEntries).insert(
          FoodLogEntriesCompanion.insert(
            day: dayKeyOf(date),
            slot: slot,
            body: trimmed,
            loggedAt: clock.now(),
          ),
        );
  }

  /// Rewrites an entry.
  ///
  /// Changing the text CLEARS any figures attached to it. They described the
  /// previous sentence, and leaving them would show a costing for a meal that
  /// is no longer what is written — the worst kind of wrong, because it looks
  /// right.
  Future<void> updateEntry(int entryId, String body) async {
    final trimmed = body.trim();
    if (trimmed.isEmpty) return deleteEntry(entryId);

    final existing = await (db.select(db.foodLogEntries)
          ..where((e) => e.id.equals(entryId)))
        .getSingleOrNull();
    if (existing == null || existing.body == trimmed) return;

    await (db.update(db.foodLogEntries)..where((e) => e.id.equals(entryId)))
        .write(
      FoodLogEntriesCompanion(
        body: Value(trimmed),
        macroSource: const Value(MacroSource.none),
        confidence: const Value(null),
        kcal: const Value(null),
        proteinG: const Value(null),
        carbsG: const Value(null),
        fatG: const Value(null),
        fibreG: const Value(null),
        items: const Value(null),
        analysisError: const Value(null),
      ),
    );
  }

  Future<void> deleteEntry(int entryId) =>
      (db.delete(db.foodLogEntries)..where((e) => e.id.equals(entryId))).go();

  /// Asks the model to cost one entry.
  ///
  /// Refuses to overwrite figures a person typed: a correction is the one
  /// number in the row that somebody actually knows.
  Future<AiResult<FoodAnalysis>> analyseEntry(int entryId) async {
    final advisor = lane;
    if (advisor == null) return const AiNoKey();

    final row = await (db.select(db.foodLogEntries)
          ..where((e) => e.id.equals(entryId)))
        .getSingleOrNull();
    if (row == null) return const AiBadResponse('entry has gone');
    if (row.macroSource == MacroSource.manual) {
      return const AiBadResponse('these figures were entered by hand');
    }

    final result = await advisor.analyse(row.body, slot: row.slot);

    if (result case AiOk(:final value)) {
      final totals = value.totals;
      await (db.update(db.foodLogEntries)..where((e) => e.id.equals(entryId)))
          .write(
        FoodLogEntriesCompanion(
          macroSource: const Value(MacroSource.model),
          confidence: Value(value.confidence),
          kcal: Value(totals.kcal),
          proteinG: Value(totals.proteinG),
          carbsG: Value(totals.carbsG),
          fatG: Value(totals.fatG),
          fibreG: Value(totals.fibreG),
          items: Value(value.encodeItems()),
          analysisError: const Value(null),
        ),
      );
      await rememberDay(dateOfDayKey(row.day));
    } else {
      // Recorded on the row, not just logged. A button that silently does
      // nothing is the hardest kind of failure to report.
      await (db.update(db.foodLogEntries)..where((e) => e.id.equals(entryId)))
          .write(FoodLogEntriesCompanion(analysisError: Value(result.message)));
    }

    return result;
  }

  /// Figures typed by hand. Always wins, and clears any error.
  Future<void> setMacrosManually(int entryId, MacroTotals macros) async {
    await (db.update(db.foodLogEntries)..where((e) => e.id.equals(entryId)))
        .write(
      FoodLogEntriesCompanion(
        macroSource: const Value(MacroSource.manual),
        confidence: const Value(null),
        kcal: Value(macros.kcal),
        proteinG: Value(macros.proteinG),
        carbsG: Value(macros.carbsG),
        fatG: Value(macros.fatG),
        fibreG: Value(macros.fibreG),
        analysisError: const Value(null),
      ),
    );

    final row = await (db.select(db.foodLogEntries)
          ..where((e) => e.id.equals(entryId)))
        .getSingleOrNull();
    if (row != null) await rememberDay(dateOfDayKey(row.day));
  }

  /// Writes the day's eating into memory, in prose, for the trainer to recall.
  Future<void> rememberDay(DateTime date) async {
    final store = memory;
    if (store == null) return;

    final day = await readDay(date);
    if (day.typedCount == 0) return;

    final eaten = day.eaten;
    await store.ingest(
      kind: MemoryKind.dailyLog,
      title: 'Food',
      day: dayKeyOf(date),
      externalId: 'food:${dayKeyOf(date)}',
      body: [
        'Logged ${day.typedCount} meals, of which ${day.costedCount} are costed.',
        for (final entry in day.entries)
          '${entry.slot.label}: ${entry.body}'
              '${entry.costed ? ' (${entry.macros!.kcal} kcal, '
                    '${entry.macros!.proteinG.round()} g protein)' : ''}',
        if (day.costedCount > 0)
          'Day so far: ${eaten.kcal} kcal, ${eaten.proteinG.round()} g protein, '
              '${eaten.fibreG.round()} g fibre, against targets of '
              '${day.targets.kcal} kcal and ${day.targets.proteinG.round()} g '
              'protein.',
        if (day.hasUncosted)
          'Some entries are not costed, so the totals are incomplete.',
      ].join('\n'),
    );
  }

  Future<IntakeDay> _assemble(DateTime date, List<FoodLogRow> rows) async {
    final mealRows = await (db.select(db.meals)
          ..where((m) => m.isActive.equals(true)))
        .get();

    final plan = <Meal>[
      for (final row in mealRows)
        if (_toMeal(row).servedOn(date.weekday)) _toMeal(row),
    ]..sort((a, b) => a.slot.atMinutes.compareTo(b.slot.atMinutes));

    final entries = [for (final row in rows) _toEntry(row)]..sort((a, b) {
      final bySlot = a.slot.atMinutes.compareTo(b.slot.atMinutes);
      return bySlot != 0 ? bySlot : a.loggedAt.compareTo(b.loggedAt);
    });

    return IntakeDay(
      date: date,
      entries: entries,
      plan: plan,
      targets: NutritionTargets.plan,
    );
  }

  FoodEntry _toEntry(FoodLogRow row) => FoodEntry(
    id: row.id,
    slot: row.slot,
    body: row.body,
    loggedAt: row.loggedAt,
    source: row.macroSource,
    confidence: row.confidence,
    macros: row.kcal == null
        ? null
        : MacroTotals(
            kcal: row.kcal!,
            proteinG: row.proteinG ?? 0,
            carbsG: row.carbsG ?? 0,
            fatG: row.fatG ?? 0,
            fibreG: row.fibreG ?? 0,
          ),
    items: FoodAnalysis.decodeItems(row.items),
    analysisError: row.analysisError,
  );

  Meal _toMeal(MealRow row) => Meal(
    id: row.id,
    name: row.name,
    slot: row.slot,
    daysOfWeek: row.daysOfWeek,
    kcal: row.kcal,
    proteinG: row.proteinG,
    carbsG: row.carbsG,
    fatG: row.fatG,
    fibreG: row.fibreG,
    detail: row.detail,
  );
}
