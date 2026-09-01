@Tags(['live'])
library;

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/ai/ai_result.dart';
import 'package:the_system/ai/gemini_client.dart';
import 'package:the_system/ai/lanes/nutrition_lane.dart';
import 'package:the_system/ai/lanes/trainer_lane.dart';
import 'package:the_system/data/memory/memory_repository.dart';
import 'package:the_system/data/memory/memory_trainer.dart';
import 'package:the_system/config/app_config.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/models/models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // flutter_test installs an HttpOverrides that answers every real request
  // with a stub, to keep tests hermetic. This probe wants the actual network.
  HttpOverrides.global = null;

  test('live: the real client costs a real meal', () async {
    await AppConfig.load();
    // ignore: avoid_print
    print('LIVE key present: ${AppConfig.hasGeminiKey}');
    if (!AppConfig.hasGeminiKey) return;

    final db = AppDatabase(NativeDatabase.memory());
    final client = GeminiClient(db);
    final lane = NutritionLane(client);

    // ignore: avoid_print
    print('LIVE chain: ${await client.resolveModel()}');

    for (final probe in [
      ('dinner', MealSlot.dinner, '1 bowl potato sabji+6 chapati+ 1 cup of tea'),
      ('snack', MealSlot.snack, '1 tomoto onion chilli bhel'),
    ]) {
      final result = await lane.analyse(probe.$3, slot: probe.$2);
      switch (result) {
        case AiOk(:final value, :final cached):
          final t = value.totals;
          // ignore: avoid_print
          print('LIVE ${probe.$1}: ${value.items.length} items, '
              'confidence ${value.confidence}, cached=$cached');
          for (final i in value.items) {
            // ignore: avoid_print
            print('LIVE    ${i.quantity} ${i.name} = ${i.kcal} kcal, '
                '${i.proteinG}g protein');
          }
          // ignore: avoid_print
          print('LIVE   TOTAL ${t.kcal} kcal, ${t.proteinG.round()}g protein, '
              '${t.carbsG.round()}g carbs, ${t.fatG.round()}g fat, '
              '${t.fibreG.round()}g fibre');
        default:
          // ignore: avoid_print
          print('LIVE ${probe.$1} FAILED: ${result.message}');
      }
    }

    // The trainer lane, over a corpus with something real in it.
    final memory = MemoryRepository(db);
    await memory.ingest(
      kind: MemoryKind.workoutSession,
      title: 'Last Monday',
      body: 'ENDURANCE session, week 1. Steady run: 1 of 1 sets at 12 min — '
          'completed. Chin tucks: 2 of 2 sets — completed. Felt easy after '
          'the first ten minutes.',
    );
    await memory.ingest(
      kind: MemoryKind.workoutSession,
      title: 'Last Friday',
      body: 'ENDURANCE session, week 1. Steady run: 0 of 1 sets at 12 min — '
          'cut short. Right knee was sore so the run was stopped early.',
    );

    final plan = await MemoryTrainerAdvisor(
      memory: memory,
      lane: TrainerLane(client),
    ).planSession(weekday: DateTime.monday, week: 1, clearedByExercise: const {});

    // ignore: avoid_print
    print('LIVE trainer source: ${plan.noteSource.name}');
    for (final note in plan.notes) {
      // ignore: avoid_print
      print('LIVE trainer note: $note');
    }

    final calls = await db.select(db.aiCalls).get();
    // ignore: avoid_print
    print('LIVE calls logged: ${calls.length}');
    for (final c in calls) {
      // ignore: avoid_print
      print('LIVE   ${c.lane} model=${c.model} ok=${c.ok} '
          'cached=${c.cached} ${c.durationMs}ms ${c.error ?? ''}');
    }
    await db.close();
  }, timeout: const Timeout(Duration(minutes: 4)));
}
