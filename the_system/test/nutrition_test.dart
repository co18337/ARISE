import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/ai/ai_result.dart';
import 'package:the_system/ai/lanes/nutrition_lane.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/meal_catalog.dart';
import 'package:the_system/data/memory/memory_repository.dart';
import 'package:the_system/data/repositories/nutrition_repository.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';

void main() {
  group('the plan, as reference', () {
    test('every weekday has a breakfast and a dinner', () {
      for (var weekday = 1; weekday <= 7; weekday++) {
        final slots = MealCatalog.forWeekday(weekday).map((m) => m.slot).toSet();
        expect(slots, contains(MealSlot.breakfast), reason: 'day $weekday');
        expect(slots, contains(MealSlot.dinner), reason: 'day $weekday');
      }
    });

    test('exactly one breakfast and one dinner per day', () {
      for (var weekday = 1; weekday <= 7; weekday++) {
        final meals = MealCatalog.forWeekday(weekday);
        for (final slot in [MealSlot.breakfast, MealSlot.dinner]) {
          expect(meals.where((m) => m.slot == slot), hasLength(1),
              reason: '${slot.label} on day $weekday');
        }
      }
    });

    test('meal ids are unique', () {
      final ids = MealCatalog.all.map((m) => m.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
    });
  });

  group('macro maths', () {
    test('totals add up and scale', () {
      const a = MacroTotals(kcal: 300, proteinG: 20);
      const b = MacroTotals(kcal: 450, proteinG: 12);
      expect(a.plus(b).kcal, 750);
      expect(a.scaled(0.5).kcal, 150);
    });

    test('protein leads the breakdown', () {
      final rows = macroBreakdown(MacroTotals.zero, NutritionTargets.plan);
      expect(rows.first.label, 'PROTEIN');
    });

    test('the target sits above the measured BMR', () {
      expect(NutritionTargets.plan.kcal,
          greaterThan(NutritionTargets.measuredBmr));
    });
  });

  group('analysis parsing', () {
    AnalysedItem item(String name, int kcal, double protein) => AnalysedItem(
      name: name,
      quantity: '1',
      kcal: kcal,
      proteinG: protein,
      carbsG: 0,
      fatG: 0,
      fibreG: 0,
    );

    test('totals are summed here, not taken from the model', () {
      // Language models are unreliable at arithmetic and reliable at reading
      // "two chapatis". We only ever ask for the per-item figures.
      final analysis = FoodAnalysis(
        items: [item('chapati', 120, 4), item('dal', 180, 9)],
        confidence: 0.8,
        assumptions: '',
      );
      expect(analysis.totals.kcal, 300);
      expect(analysis.totals.proteinG, 13);
    });

    test('items survive the round trip through storage', () {
      final analysis = FoodAnalysis(
        items: [item('curd', 90, 5)],
        confidence: 0.7,
        assumptions: 'assumed one small bowl',
      );
      final restored = FoodAnalysis.decodeItems(analysis.encodeItems());
      expect(restored, hasLength(1));
      expect(restored.single.name, 'curd');
      expect(restored.single.kcal, 90);
    });

    test('unreadable stored items degrade to none rather than throwing', () {
      expect(FoodAnalysis.decodeItems('not json'), isEmpty);
      expect(FoodAnalysis.decodeItems(null), isEmpty);
    });
  });

  group('logging what was eaten', () {
    late AppDatabase db;
    late NutritionRepository nutrition;

    // A Wednesday, so the reference rotation is fixed.
    final wednesday = DateTime(2026, 9, 2);

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      nutrition = NutritionRepository(db, clock: FixedClock(wednesday));
    });

    tearDown(() => db.close());

    test('the day starts with a plan to read and nothing eaten', () async {
      final day = await nutrition.readDay(wednesday);

      expect(day.plan, isNotEmpty, reason: 'reference is there');
      expect(day.plan.map((m) => m.id), contains('breakfast_wed'));
      expect(day.entries, isEmpty);
      expect(day.eaten.kcal, 0);
      expect(day.typedCount, 0);
    });

    test('what is typed is stored exactly as typed', () async {
      const typed = '2 chapatis whole wheat + 1 cup of tea + salad';
      await nutrition.addEntry(wednesday, MealSlot.breakfast, typed);

      final entry =
          (await nutrition.readDay(wednesday)).forSlot(MealSlot.breakfast).single;
      expect(entry.body, typed);
      expect(entry.source, MacroSource.none);
      expect(entry.costed, isFalse);
    });

    test('eating twice in a slot is two entries, not an overwrite', () async {
      // A second snack is a different thing you ate. Merging them would lose
      // what actually happened.
      await nutrition.addEntry(wednesday, MealSlot.snack, 'a banana');
      await nutrition.addEntry(wednesday, MealSlot.snack, 'handful of peanuts');

      final snacks = (await nutrition.readDay(wednesday)).forSlot(MealSlot.snack);
      expect(snacks, hasLength(2));
      expect(snacks.map((e) => e.body),
          containsAll(['a banana', 'handful of peanuts']));
    });

    test('an uncosted entry is unknown, not zero', () async {
      // Counting it as zero calories would make a half-logged day look light,
      // which is the one wrong answer worse than no answer.
      await nutrition.addEntry(wednesday, MealSlot.lunch, 'rice and dal');
      final day = await nutrition.readDay(wednesday);

      expect(day.eaten.kcal, 0);
      expect(day.typedCount, 1);
      expect(day.costedCount, 0);
      expect(day.hasUncosted, isTrue);
    });

    test('figures typed by hand are counted and marked as yours', () async {
      await nutrition.addEntry(wednesday, MealSlot.lunch, 'rice and dal');
      final entry =
          (await nutrition.readDay(wednesday)).forSlot(MealSlot.lunch).single;

      await nutrition.setMacrosManually(
        entry.id,
        const MacroTotals(kcal: 520, proteinG: 18, carbsG: 80, fatG: 10, fibreG: 9),
      );

      final day = await nutrition.readDay(wednesday);
      final updated = day.forSlot(MealSlot.lunch).single;
      expect(updated.source, MacroSource.manual);
      expect(updated.costed, isTrue);
      expect(day.eaten.kcal, 520);
      expect(day.hasUncosted, isFalse);
    });

    test('editing the text throws away the old figures', () async {
      // They described the previous sentence. Keeping them would show a
      // costing for a meal that is no longer what is written — wrong in the
      // worst way, because it looks right.
      await nutrition.addEntry(wednesday, MealSlot.dinner, 'khichdi');
      var entry =
          (await nutrition.readDay(wednesday)).forSlot(MealSlot.dinner).single;
      await nutrition.setMacrosManually(entry.id, const MacroTotals(kcal: 400));
      expect((await nutrition.readDay(wednesday)).eaten.kcal, 400);

      await nutrition.updateEntry(entry.id, 'khichdi and two parathas');

      entry =
          (await nutrition.readDay(wednesday)).forSlot(MealSlot.dinner).single;
      expect(entry.body, 'khichdi and two parathas');
      expect(entry.costed, isFalse);
      expect(entry.source, MacroSource.none);
    });

    test('re-saving identical text keeps the figures', () async {
      await nutrition.addEntry(wednesday, MealSlot.snack, 'a banana');
      final entry =
          (await nutrition.readDay(wednesday)).forSlot(MealSlot.snack).single;
      await nutrition.setMacrosManually(entry.id, const MacroTotals(kcal: 105));

      await nutrition.updateEntry(entry.id, 'a banana');
      expect((await nutrition.readDay(wednesday)).eaten.kcal, 105);
    });

    test('an entry can be deleted', () async {
      await nutrition.addEntry(wednesday, MealSlot.snack, 'nuts');
      final entry =
          (await nutrition.readDay(wednesday)).forSlot(MealSlot.snack).single;
      expect((await nutrition.readDay(wednesday)).entries, hasLength(1));

      await nutrition.deleteEntry(entry.id);
      expect((await nutrition.readDay(wednesday)).entries, isEmpty);
    });

    test('blank text adds nothing', () async {
      await nutrition.addEntry(wednesday, MealSlot.lunch, '   ');
      expect((await nutrition.readDay(wednesday)).entries, isEmpty);
    });

    test('entries come back in the order they were eaten', () async {
      await nutrition.addEntry(wednesday, MealSlot.dinner, 'soup');
      await nutrition.addEntry(wednesday, MealSlot.breakfast, 'oats');
      await nutrition.addEntry(wednesday, MealSlot.lunch, 'rice');

      final slots =
          (await nutrition.readDay(wednesday)).entries.map((e) => e.slot);
      expect(slots, [MealSlot.breakfast, MealSlot.lunch, MealSlot.dinner]);
    });

    test('with no key, estimating is refused politely', () async {
      await nutrition.addEntry(wednesday, MealSlot.breakfast, 'poha');
      final entry =
          (await nutrition.readDay(wednesday)).forSlot(MealSlot.breakfast).single;

      expect(nutrition.canAnalyse, isFalse);
      final result = await nutrition.analyseEntry(entry.id);
      expect(result, isA<AiNoKey<FoodAnalysis>>());
      expect(result.message, contains('No API key'));
      // And nothing is invented in place of an answer.
      expect((await nutrition.readDay(wednesday)).eaten.kcal, 0);
    });

    test('the day is streamed, so the screen updates as it fills', () async {
      expect((await nutrition.watchDay(wednesday).first).typedCount, 0);
      await nutrition.addEntry(wednesday, MealSlot.breakfast, 'idli');
      expect((await nutrition.watchDay(wednesday).first).typedCount, 1);
    });

    test('the day is written into memory in plain words', () async {
      final memory = MemoryRepository(db);
      final withMemory = NutritionRepository(
        db,
        clock: FixedClock(wednesday),
        memory: memory,
      );

      await withMemory.addEntry(
        wednesday,
        MealSlot.breakfast,
        '2 chapatis and curd',
      );
      final entry = (await withMemory.readDay(wednesday))
          .forSlot(MealSlot.breakfast)
          .single;
      await withMemory.setMacrosManually(
        entry.id,
        const MacroTotals(kcal: 380, proteinG: 16),
      );

      final hits = await memory.recall('chapatis curd breakfast');
      expect(hits, isNotEmpty);
      expect(hits.first.passage, contains('chapatis'));
    });

    test('nothing typed means nothing to remember', () async {
      final memory = MemoryRepository(db);
      await NutritionRepository(db, memory: memory).rememberDay(wednesday);
      expect((await memory.stats()).documents, 0);
    });
  });
}
