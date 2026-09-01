import 'package:drift/native.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/ai/ai_log_repository.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/export/export_repository.dart';
import 'package:the_system/data/repositories/activity_repository.dart';
import 'package:the_system/data/repositories/player_repository.dart';
import 'package:the_system/data/memory/memory_repository.dart';
import 'package:the_system/data/repositories/nutrition_repository.dart';
import 'package:the_system/data/alerts/notifier.dart';
import 'package:the_system/data/repositories/alert_repository.dart';
import 'package:the_system/data/repositories/progress_repository.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
import 'package:the_system/data/repositories/workout_repository.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/models/models.dart';
import 'package:the_system/main.dart';
import 'package:the_system/screens/activity_log_screen.dart';
import 'package:the_system/screens/backup_screen.dart';
import 'package:the_system/screens/badge_gallery_screen.dart';
import 'package:the_system/screens/meal_plan_screen.dart';
import 'package:the_system/screens/memory_screen.dart';
import 'package:the_system/screens/nutrition_screen.dart';
import 'package:the_system/screens/progress_screen.dart';
import 'package:the_system/screens/training_screen.dart';
import 'package:the_system/screens/nav_hub.dart';
import 'package:the_system/screens/status_screen.dart';
import 'package:the_system/screens/today_screen.dart';
import 'package:the_system/screens/weekly_report_screen.dart';
import 'package:the_system/widgets/rank_header.dart';

void main() {
  late AppDatabase db;

  /// 21:30 — the 8pm water step is the live one. See widget_test for why the
  /// clock is fixed rather than real.
  final clock = FixedClock.todayAt(21, 30);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await QuestRepository(db, clock: clock).materialiseDay(clock.now());
  });

  tearDown(() async => db.close());

  Widget buildApp() => MyApp(
    questRepository: QuestRepository(db, clock: clock),
    playerRepository: PlayerRepository(db),
    activityRepository: ActivityRepository(db),
    exportRepository: ExportRepository(db),
      workoutRepository: WorkoutRepository(db, clock: clock),
      memoryRepository: MemoryRepository(db),
      aiLogRepository: AiLogRepository(db),
      nutritionRepository: NutritionRepository(db, clock: clock),
      progressRepository: ProgressRepository(db),
      alertRepository: AlertRepository(
        quests: QuestRepository(db),
        notifier: NoopNotifier(),
      ),
  );

  /// Explicit pumps rather than pumpAndSettle — see the note in widget_test.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 9; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> disposeTree(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 10));
  }

  /// A tall surface so whole lists get built — a ListView only builds what's
  /// near the viewport, so off-screen panels genuinely don't exist to finders.
  void useTallSurface(WidgetTester tester, {double height = 1900}) {
    tester.view.physicalSize = Size(420 * 3, height * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
  }

  /// Taps ARISE and waits out the ceremony.
  ///
  /// The session is deliberately visible-but-unstartable until it is accepted,
  /// so every test that touches a set has to summon first — same as a person.
  Future<void> summon(WidgetTester tester) async {
    await tester.tap(find.text('ARISE'));
    // The ceremony holds for a minimum time so a fast trainer call does not
    // make it flash past; 3s of pumping clears it.
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  /// Opens the hub and picks a destination by its label.
  Future<void> navigateTo(WidgetTester tester, String label) async {
    await tester.tap(find.bySemanticsLabel('Open navigation hub'));
    await settle(tester);
    await tester.tap(
      find.descendant(of: find.byType(NavHub), matching: find.text(label)),
    );
    await settle(tester);
  }

  testWidgets('the hub opens with every destination and closes again', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await settle(tester);

    await tester.tap(find.bySemanticsLabel('Open navigation hub'));
    await settle(tester);

    expect(find.text('NAV'), findsOneWidget);
    final hub = find.byType(NavHub);
    for (final label in [
      'DAILY QUESTS',
      'STATUS',
      'REPORT',
      'TRAINING',
      'NUTRITION',
      'LOG',
      'MEMORY',
      'BACKUP',
      'BADGES',
    ]) {
      expect(
        find.descendant(of: hub, matching: find.text(label)),
        findsOneWidget,
        reason: label,
      );
    }

    // The circular X is the single dismiss affordance on every overlay.
    await tester.tap(find.bySemanticsLabel('Close'));
    await settle(tester);

    expect(find.text('NAV'), findsNothing);
    expect(find.byType(TodayScreen), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('the RankHeader persists across every section', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);

    for (final destination in ['STATUS', 'REPORT', 'LOG', 'DAILY QUESTS']) {
      await navigateTo(tester, destination);
      // The whole point of the shell: progression never leaves the screen.
      expect(find.byType(RankHeader), findsOneWidget, reason: destination);
      expect(find.text('PRINCE'), findsOneWidget, reason: destination);
    }

    await disposeTree(tester);
  });

  testWidgets('the hub navigates to each section', (WidgetTester tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);

    await navigateTo(tester, 'STATUS');
    expect(find.byType(StatusScreen), findsOneWidget);

    await navigateTo(tester, 'REPORT');
    expect(find.byType(WeeklyReportScreen), findsOneWidget);

    await navigateTo(tester, 'LOG');
    expect(find.byType(ActivityLogScreen), findsOneWidget);

    await navigateTo(tester, 'DAILY QUESTS');
    expect(find.byType(TodayScreen), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('STATUS shows the character sheet and its scope tabs', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'STATUS');

    final status = find.byType(StatusScreen);
    Finder inStatus(Finder m) => find.descendant(of: status, matching: m);

    expect(inStatus(find.text('E RANK')), findsOneWidget);
    for (final stat in ['STR', 'STA', 'DIS', 'REC']) {
      expect(inStatus(find.text(stat)), findsOneWidget, reason: stat);
    }
    expect(inStatus(find.text('ALL TIME')), findsOneWidget);
    expect(inStatus(find.text('CONSISTENCY')), findsOneWidget);
    expect(inStatus(find.text('EXPERIENCE')), findsOneWidget);

    // Switching scope re-queries without crashing.
    await tester.tap(inStatus(find.text('WEEK')));
    await settle(tester);
    expect(inStatus(find.text('CONSISTENCY')), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('the weekly report renders real figures, not a stub', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'REPORT');

    final report = find.byType(WeeklyReportScreen);
    Finder inReport(Finder m) => find.descendant(of: report, matching: m);

    expect(inReport(find.text('WEEKLY REPORT')), findsOneWidget);
    expect(inReport(find.text('ADHERENCE')), findsOneWidget);
    expect(inReport(find.text('THIS WEEK')), findsOneWidget);
    expect(inReport(find.text('ACHIEVEMENTS')), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('the activity log lists events written by the repository', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);

    // Answer the live step so there is something to log.
    await tester.tap(
      find.descendant(
        of: find.byType(TodayScreen),
        matching: find.text('DONE'),
      ),
    );
    await settle(tester);

    await navigateTo(tester, 'LOG');
    final log = find.byType(ActivityLogScreen);

    expect(
      find.descendant(of: log, matching: find.text('ACTIVITY LOG')),
      findsOneWidget,
    );
    // Grouped under a TODAY divider, with the quest title and its XP.
    expect(find.descendant(of: log, matching: find.text('TODAY')), findsOneWidget);
    expect(
      find.descendant(of: log, matching: find.text('Drink 3L water')),
      findsOneWidget,
    );
    // The morning steps that closed themselves out are in the feed too — the
    // routine writes misses down, it doesn't just forget them.
    expect(
      find.descendant(of: log, matching: find.text('Morning skincare')),
      findsOneWidget,
    );
    expect(find.descendant(of: log, matching: find.text('+10')), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('BACKUP builds a real export of the database', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'BACKUP');

    final backup = find.byType(BackupScreen);
    Finder inBackup(Finder m) => find.descendant(of: backup, matching: m);

    expect(inBackup(find.text('CONTENTS')), findsOneWidget);
    expect(inBackup(find.text('PREVIEW')), findsOneWidget);
    expect(inBackup(find.text('COPY JSON')), findsOneWidget);
    expect(inBackup(find.text('SAVE TO FILE')), findsOneWidget);
    // Real figures and real JSON, not a placeholder. Asserted on content
    // rather than on counts, which shift by one on Saturdays.
    expect(inBackup(find.textContaining('KB')), findsOneWidget);
    expect(
      inBackup(find.textContaining('"app": "The System"')),
      findsOneWidget,
    );

    await disposeTree(tester);
  });

  testWidgets('TRAINING issues the session behind the workout step', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'TRAINING');

    final training = find.byType(TrainingScreen);
    Finder inTraining(Finder m) => find.descendant(of: training, matching: m);

    expect(training, findsOneWidget);
    // Week 1 of the programme, and the phase says what it is for.
    expect(inTraining(find.text('WEEK 1')), findsOneWidget);
    expect(
      inTraining(find.textContaining('RESET')),
      findsOneWidget,
      reason: 'month one should be the cardio-only phase',
    );
    expect(inTraining(find.text('SETS LOGGED')), findsOneWidget);
    // Nothing logged yet, so the finish button reports what is left.
    expect(inTraining(find.textContaining('SETS REMAINING')), findsOneWidget);
    expect(inTraining(find.text('FINISH SESSION')), findsNothing);

    await disposeTree(tester);
  });

  testWidgets('logging a set moves the training session on', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'TRAINING');

    final before = find.descendant(
      of: find.byType(TrainingScreen),
      matching: find.byIcon(Icons.check),
    );
    expect(before, findsNothing);

    await summon(tester);

    // Tap the first set chip.
    await tester.tap(
      find
          .descendant(
            of: find.byType(TrainingScreen),
            matching: find.byIcon(Icons.radio_button_unchecked),
          )
          .first,
    );
    await settle(tester);

    expect(before, findsWidgets);

    await disposeTree(tester);
  });

  testWidgets('MEMORY seeds a corpus and finds things in it', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'MEMORY');

    final memory = find.byType(MemoryScreen);
    Finder inMemory(Finder m) => find.descendant(of: memory, matching: m);

    // Two matches now: the tab and the panel it selects.
    expect(inMemory(find.text('CORPUS')), findsNWidgets(2));
    expect(inMemory(find.text('THE MODEL')), findsOneWidget);

    await tester.tap(inMemory(find.text('SEED SAMPLE CORPUS')));
    // Seeding embeds well over a hundred chunks, so it needs longer than the
    // usual settle.
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(inMemory(find.textContaining('Seeded')), findsOneWidget);

    await tester.tap(inMemory(find.text('SEARCH MEMORY')));
    await settle(tester);
    // Real retrieval over the seeded corpus, with scores shown.
    expect(inMemory(find.textContaining('Found')), findsOneWidget);

    // The model tab is honest about there being no key, and about the app
    // working anyway.
    await tester.tap(inMemory(find.text('THE MODEL')));
    await settle(tester);
    expect(inMemory(find.text('API key')), findsOneWidget);
    expect(inMemory(find.text('not set')), findsOneWidget);
    expect(
      inMemory(find.textContaining('Everything works without a key')),
      findsOneWidget,
    );

    await disposeTree(tester);
  });

  testWidgets('the session waits to be accepted, and is not startable first', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'TRAINING');

    final training = find.byType(TrainingScreen);
    Finder inTraining(Finder m) => find.descendant(of: training, matching: m);

    // The System window, with the status recital and the one thing to press.
    expect(inTraining(find.text('THE SYSTEM')), findsOneWidget);
    expect(inTraining(find.text('ARISE')), findsOneWidget);
    expect(inTraining(find.text('HUNTER')), findsOneWidget);
    // Honest about having nothing to reason from yet.
    expect(
      inTraining(find.textContaining('still learning you')),
      findsOneWidget,
    );

    // The session is VISIBLE underneath — hiding it would make the ceremony a
    // wall — but taps do not reach it.
    expect(inTraining(find.text('SETS LOGGED')), findsOneWidget);
    await tester.tap(
      inTraining(find.byIcon(Icons.radio_button_unchecked)).first,
      warnIfMissed: false,
    );
    await settle(tester);
    expect(
      inTraining(find.byIcon(Icons.check)),
      findsNothing,
      reason: 'a set was logged before the session was accepted',
    );

    await summon(tester);

    // Accepted: the gate is gone and the session is live.
    expect(inTraining(find.text('ARISE')), findsNothing);
    expect(inTraining(find.textContaining('SUMMONED')), findsOneWidget);
    await tester.tap(inTraining(find.byIcon(Icons.radio_button_unchecked)).first);
    await settle(tester);
    expect(inTraining(find.byIcon(Icons.check)), findsWidgets);

    await disposeTree(tester);
  });

  testWidgets('extra work is logged and rewarded, without moving the ladder', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'TRAINING');
    await summon(tester);

    final training = find.byType(TrainingScreen);
    Finder inTraining(Finder m) => find.descendant(of: training, matching: m);

    // "One more" is always available while the session is open — there is no
    // cap on doing extra.
    expect(inTraining(find.text('ONE MORE')), findsWidgets);
    await tester.tap(inTraining(find.text('ONE MORE')).first);
    await settle(tester);

    // Log everything, the extra set included. (Tapping "the last unchecked
    // chip" would land in a different exercise — the extra belongs to the
    // first one.)
    for (var i = 0; i < 25; i++) {
      final open = inTraining(find.byIcon(Icons.radio_button_unchecked));
      if (open.evaluate().isEmpty) break;
      await tester.tap(open.first);
      await settle(tester);
    }

    expect(inTraining(find.textContaining('beyond the plan')), findsOneWidget);
    expect(inTraining(find.textContaining('+2 XP')), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('a finished session is locked and says so', (
    WidgetTester tester,
  ) async {
    // Taller than the default: the session card now reports the phase gate and
    // the scan emphasis above the exercises, and a ListView does not build
    // what it has not laid out — a finder cannot see an off-screen sign-off.
    useTallSurface(tester, height: 2600);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'TRAINING');

    final training = find.byType(TrainingScreen);
    Finder inTraining(Finder m) => find.descendant(of: training, matching: m);

    await summon(tester);

    // Log every set.
    for (var i = 0; i < 20; i++) {
      final open = inTraining(find.byIcon(Icons.radio_button_unchecked));
      if (open.evaluate().isEmpty) break;
      await tester.tap(open.first);
      await settle(tester);
    }
    expect(inTraining(find.byIcon(Icons.radio_button_unchecked)), findsNothing);
    expect(inTraining(find.text('FINISH SESSION')), findsOneWidget);

    await tester.tap(inTraining(find.text('FINISH SESSION')));
    await settle(tester);

    // The screen now visibly says the session is closed, rather than looking
    // exactly as it did a moment earlier.
    expect(inTraining(find.text('SESSION SIGNED OFF')), findsOneWidget);
    expect(inTraining(find.text('SESSION COMPLETE')), findsOneWidget);

    // And the sets can no longer be un-ticked behind the session's back.
    final chips = inTraining(find.byIcon(Icons.check));
    expect(chips, findsWidgets);
    await tester.tap(chips.first);
    await settle(tester);
    expect(
      inTraining(find.byIcon(Icons.radio_button_unchecked)),
      findsNothing,
      reason: 'a finished session must not be editable',
    );

    await disposeTree(tester);
  });

  testWidgets('finishing the session clears the workout quest and awards XP', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester, height: 2600);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'TRAINING');
    await summon(tester);

    for (var i = 0; i < 20; i++) {
      final open = find.descendant(
        of: find.byType(TrainingScreen),
        matching: find.byIcon(Icons.radio_button_unchecked),
      );
      if (open.evaluate().isEmpty) break;
      await tester.tap(open.first);
      await settle(tester);
    }
    await tester.tap(
      find.descendant(
        of: find.byType(TrainingScreen),
        matching: find.text('FINISH SESSION'),
      ),
    );
    await settle(tester);

    // The 20 XP for the workout quest actually lands. This is the call that
    // used to be a dropped Future.
    //
    // Asserted through the UI, not by awaiting a database read here: inside
    // testWidgets the fake clock never advances for real async, so awaiting a
    // repository future in the test body hangs forever.
    await navigateTo(tester, 'DAILY QUESTS');
    expect(
      find.descendant(of: find.byType(TodayScreen), matching: find.text('+20')),
      findsOneWidget,
      reason: 'the workout quest should be cleared and paid',
    );
    // And the shell's running total moved with it.
    expect(find.text('20'), findsWidgets);

    await disposeTree(tester);
  });

  testWidgets('NUTRITION adds what you type with a button, not Enter', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'NUTRITION');

    final nutrition = find.byType(NutritionScreen);
    Finder inNutrition(Finder m) => find.descendant(of: nutrition, matching: m);

    expect(inNutrition(find.text('ADD WHAT YOU ATE')), findsOneWidget);
    expect(inNutrition(find.text('WHAT I ATE TODAY')), findsOneWidget);
    expect(
      inNutrition(find.textContaining('Nothing logged yet')),
      findsOneWidget,
    );

    // Pick the slot, type, and press the button — no keyboard Enter involved,
    // because a phone's multi-line keyboard may not offer one.
    await tester.tap(inNutrition(find.text('DINNER')).first);
    await settle(tester);
    await tester.enterText(
      inNutrition(find.byType(TextField)).first,
      '1 bowl potato sabji + 6 chapati + 1 cup of tea',
    );
    await tester.tap(inNutrition(find.text('ADD')));
    await settle(tester);

    // Stored, listed, and honest that it has no figures yet.
    expect(
      inNutrition(find.text('1 bowl potato sabji + 6 chapati + 1 cup of tea')),
      findsOneWidget,
    );
    expect(inNutrition(find.text('0 OF 1 COSTED')), findsOneWidget);
    expect(
      inNutrition(find.textContaining('lower than what you actually ate')),
      findsOneWidget,
    );

    // The box clears itself, ready for the next thing.
    final field = tester.widget<TextField>(
      inNutrition(find.byType(TextField)).first,
    );
    expect(field.controller!.text, isEmpty);

    // No key in tests, so there is no ESTIMATE — only the manual route.
    expect(inNutrition(find.text('ESTIMATE')), findsNothing);
    expect(inNutrition(find.text('FIGURES')), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('NUTRITION takes a second snack as a second entry', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'NUTRITION');

    final nutrition = find.byType(NutritionScreen);
    Finder inNutrition(Finder m) => find.descendant(of: nutrition, matching: m);

    await tester.tap(inNutrition(find.text('SNACK')).first);
    await settle(tester);
    await tester.enterText(inNutrition(find.byType(TextField)).first, 'a banana');
    await tester.tap(inNutrition(find.text('ADD')));
    await settle(tester);

    await tester.tap(inNutrition(find.text('SNACK')).first);
    await settle(tester);
    await tester.enterText(inNutrition(find.byType(TextField)).first, 'peanuts');
    await tester.tap(inNutrition(find.text('ADD')));
    await settle(tester);

    // Both survive — the second did not overwrite the first.
    expect(inNutrition(find.text('a banana')), findsOneWidget);
    expect(inNutrition(find.text('peanuts')), findsOneWidget);
    expect(inNutrition(find.text('0 OF 2 COSTED')), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('NUTRITION keeps the plan as reference only', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'NUTRITION');

    // The plan is a page of its own now, opened from NUTRITION rather than
    // shown as a tab beside today's log. The two answer different questions —
    // what to cook from, versus what was actually eaten.
    await tester.tap(
      find.descendant(
        of: find.byType(NutritionScreen),
        matching: find.text('THE PLAN'),
      ),
    );
    await settle(tester);

    expect(find.byType(MealPlanScreen), findsOneWidget);

    // Something to cook from — with nothing to tick off.
    expect(find.text('THE IDEAL WEEK'), findsOneWidget);
    expect(find.textContaining('Nothing here is logged'), findsOneWidget);
    expect(find.text('ATE IT'), findsNothing);

    // A whole week, reachable a day at a time.
    for (final day in ['MON', 'WED', 'SUN']) {
      expect(find.text(day), findsOneWidget);
    }
    await tester.tap(find.text('SUN'));
    await settle(tester);
    expect(find.text('IF YOU ATE ALL OF IT'), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('PROGRESS charts the baseline and the days behind it', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    // A day answered, so the momentum charts have something real to draw.
    //
    // runAsync, not a bare await: testWidgets runs in a FakeAsync zone where
    // real timers never fire unless the tester pumps them, and drift schedules
    // its stream emissions on one. Awaiting a query directly here does not
    // fail — it HANGS, with no output and no timeout, which is a much worse
    // afternoon than a red test. Every other test in this file seeds in setUp
    // for the same reason.
    await tester.runAsync(() async {
      final quests = QuestRepository(db, clock: clock);
      final today = await quests.watchDay(clock.now()).first;
      await quests.setStatus(today.first, QuestStatus.done);
    });

    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'PROGRESS');

    // The Tanita baseline, on screen without anyone typing it.
    expect(find.text('BODY COMPOSITION'), findsOneWidget);
    // Twice: once as the headline figure, once in the full reading below it.
    expect(find.textContaining('79.5 kg'), findsNWidgets(2));
    expect(find.text('7 AUG 2026'), findsOneWidget);
    expect(find.textContaining('Tanita MC-780'), findsOneWidget);

    // One scan is a measurement, not a direction — and the screen says so
    // instead of drawing a single dot on an axis.
    expect(find.textContaining('starts at your next scan'), findsOneWidget);

    // The boundary, on screen and not only in a comment. Asserted before the
    // scroll below, because a ListView disposes what leaves the viewport.
    expect(find.textContaining('does not interpret them'), findsOneWidget);

    // The daily half is below the fold now that the full MC-780 panel is on
    // screen, so scroll to each thing rather than making the test surface
    // taller — a phone has to scroll for it too, and a finder cannot see what
    // a ListView has not built.
    Future<void> scrollTo(Finder target) async {
      await tester.dragUntilVisible(
        target,
        find.byType(ProgressScreen),
        const Offset(0, -280),
      );
      await settle(tester);
    }

    // The range filter is the answer to "a month of heart rate data". Tapped
    // first, because it sits above the charts it controls.
    await scrollTo(find.text('7D'));
    await tester.tap(find.text('7D'));
    await settle(tester);

    await scrollTo(find.text('XP EARNED'));
    expect(find.byType(BarChart), findsOneWidget);

    await scrollTo(find.text('WHERE THE XP WENT'));
    expect(find.byType(PieChart), findsOneWidget);

    // The blood work is here too, with the report's own flags.
    await scrollTo(find.text('BLOOD WORK'));
    expect(find.text('OUTSIDE THE REFERENCE RANGE'), findsOneWidget);
    expect(find.textContaining('SGPT'), findsWidgets);

    await disposeTree(tester);
  });

  testWidgets('a second scan turns the reading into a line', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.runAsync(
      () => ProgressRepository(db).recordScan(
        date: DateTime(2027, 2, 7),
        weightKg: 73.2,
        bodyFatPercent: 18.1,
        muscleMassKg: 57.4,
        source: 'Tanita MC-780',
      ),
    );

    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'PROGRESS');

    expect(find.byType(LineChart), findsOneWidget);
    expect(find.textContaining('starts at your next scan'), findsNothing);
    // Down 6.3 kg against the baseline, stated as a delta rather than left to
    // be worked out.
    expect(find.textContaining('-6.3'), findsOneWidget);
    expect(find.textContaining('AGAINST THE BASELINE'), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('TRAINING says why the trunk gets the extra set', (
    WidgetTester tester,
  ) async {
    // The seeded 7 Aug scan rates the trunk -1 for muscle and every limb 0,
    // so the emphasis is live from the first launch with no setup at all.
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'TRAINING');
    // The helper, not a bare tap: the ceremony holds for a minimum time and a
    // half-pumped timer trips "a Timer is still pending" at teardown.
    await summon(tester);

    expect(
      find.textContaining('below average for muscle'),
      findsOneWidget,
    );
    expect(find.textContaining('trunk'), findsWidgets);

    await disposeTree(tester);
  });

  testWidgets('ALERTS reports what the phone will say and whether it may', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'ALERTS');
    // The panel is a FutureBuilder over a drift stream; give it room to land.
    await settle(tester);
    await settle(tester);

    // Honest about the browser rather than pretending to be armed.
    expect(find.text('PERMISSION'), findsOneWidget);
    expect(find.textContaining('Not available on this platform'), findsWidgets);
    expect(find.textContaining('running in a browser'), findsOneWidget);

    // And it still shows the real schedule, which is the half that does not
    // need a phone to be right.
    expect(find.text('SCHEDULED'), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('the badge gallery lists every usable badge', (
    WidgetTester tester,
  ) async {
    // A dev screen, but a tested one: it drives 33 image assets, and a typo in
    // a filename shows as a blank square with no error anywhere.
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'BADGES');

    final gallery = find.byType(BadgeGalleryScreen);
    expect(gallery, findsOneWidget);
    // Every usable badge renders. A typo in a filename shows as a blank square
    // with no error anywhere, so this is worth asserting even on a dev screen.
    expect(
      find.descendant(of: gallery, matching: find.byType(Image)),
      findsNWidgets(BadgeGalleryScreen.usable.length),
    );
    // The picks are labelled so a screenshot shows what is taken.
    expect(
      find.descendant(of: gallery, matching: find.text('S RANK')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: gallery, matching: find.text('SPARE')),
      findsNWidgets(2),
    );

    await disposeTree(tester);
  });

  testWidgets('the shell lays out at phone width without overflow', (
    WidgetTester tester,
  ) async {
    // Moto G35 proportions. A RenderFlex overflow fails the test outright.
    tester.view.physicalSize = const Size(360 * 3, 800 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp());
    await settle(tester);

    for (final destination in ['STATUS', 'REPORT', 'LOG', 'BACKUP']) {
      await navigateTo(tester, destination);
      expect(find.byType(RankHeader), findsOneWidget, reason: destination);
    }

    await disposeTree(tester);
  });

  testWidgets('a screen left open past midnight moves to the new day', (
    WidgetTester tester,
  ) async {
    // The bug: NUTRITION and TRAINING captured their date once, in a `late
    // final`, and never looked again. An Android process is rarely killed, so
    // a phone left on the food screen overnight went on writing to YESTERDAY —
    // a dinner typed at 00:05 logged against the wrong day, silently.
    final start = DateTime.now();
    final movable = _MovableClock(
      DateTime(start.year, start.month, start.day, 23, 58),
    );

    useTallSurface(tester);
    await tester.pumpWidget(
      MyApp(
        questRepository: QuestRepository(db, clock: movable),
        playerRepository: PlayerRepository(db),
        activityRepository: ActivityRepository(db),
        exportRepository: ExportRepository(db),
        workoutRepository: WorkoutRepository(db, clock: movable),
        memoryRepository: MemoryRepository(db),
        aiLogRepository: AiLogRepository(db),
        nutritionRepository: NutritionRepository(db, clock: movable),
        progressRepository: ProgressRepository(db),
        alertRepository: AlertRepository(
          quests: QuestRepository(db),
          notifier: NoopNotifier(),
        ),
      ),
    );
    await settle(tester);
    await navigateTo(tester, 'NUTRITION');

    final nutrition = find.byType(NutritionScreen);
    Finder inNutrition(Finder m) => find.descendant(of: nutrition, matching: m);

    Future<void> log(String what) async {
      await tester.enterText(inNutrition(find.byType(TextField)).first, what);
      await tester.tap(inNutrition(find.text('ADD')));
      await settle(tester);
    }

    await log('1 cup of tea');
    expect(inNutrition(find.textContaining('1 cup of tea')), findsOneWidget);

    // Seven minutes later it is tomorrow, and the phone comes back to life.
    movable.instant = movable.instant.add(const Duration(minutes: 7));
    // The full round trip. Flutter asserts on shortcuts — paused is reachable
    // only through hidden, in both directions.
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    await settle(tester);

    // The screen reissued itself: the new day is empty, last night's tea is
    // where it happened rather than following the screen forward.
    expect(inNutrition(find.textContaining('1 cup of tea')), findsNothing);
    expect(inNutrition(find.textContaining('Nothing logged yet')),
        findsOneWidget);

    await log('2 chapatis');

    // The decisive check: two entries, two different days.
    final rows = await db.select(db.foodLogEntries).get();
    expect(rows, hasLength(2));
    expect(rows.map((r) => r.day).toSet(), hasLength(2),
        reason: 'the second entry belongs to the new day, not the old one');

    await disposeTree(tester);
  });
}

/// A clock that can be pushed forward, for testing the midnight rollover.
/// FixedClock cannot move, and the whole point here is that time passes while
/// one screen stays on screen.
class _MovableClock implements Clock {
  DateTime instant;

  _MovableClock(this.instant);

  @override
  DateTime now() => instant;
}
