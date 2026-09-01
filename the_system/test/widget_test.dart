import 'package:drift/native.dart';
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
import 'package:the_system/main.dart';
import 'package:the_system/screens/today_screen.dart';

void main() {
  late AppDatabase db;

  /// 21:30 — late enough that the morning routine has lapsed and the 8pm
  /// water step is the active one, and EARLY enough that the 9pm dinner step
  /// hasn't opened. Every assertion below about which step is live depends on
  /// this being fixed rather than on whatever time the suite happens to run.
  final clock = FixedClock.todayAt(21, 30);

  setUp(() async {
    // NativeDatabase.memory() gives every test a fresh, throwaway SQLite
    // database with no file and no device — the migration runs, so the seed
    // data is present exactly as on a real first launch.
    db = AppDatabase(NativeDatabase.memory());
    // Materialise today's quests HERE, in setUp, where real async works
    // normally. Inside testWidgets the fake-async zone makes database work
    // much harder to await reliably.
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

  /// Pumps enough frames for the FutureBuilder and StreamBuilders to resolve.
  ///
  /// Deliberately NOT pumpAndSettle: that spins until the widget tree is
  /// completely idle, which never happens reliably when frames depend on
  /// database futures resolving outside the test's fake clock — and the
  /// countdown's periodic Timer means the tree is never truly idle anyway.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  /// Unmounts the tree, which cancels drift's stream subscriptions and the
  /// screen's periodic Timers, then pumps to flush drift's zero-duration
  /// cleanup timer. testWidgets fails any test that ends with a timer pending.
  Future<void> disposeTree(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    // The pump MUST advance the fake clock; a bare pump() only schedules a
    // frame without moving time, leaving a Timer(Duration.zero) unfired.
    await tester.pump(const Duration(milliseconds: 10));
  }

  /// The NavHub lists "DAILY QUESTS" too, and overlays are translucent, so
  /// screen-content assertions get scoped to the screen itself.
  Finder inToday(Finder matching) =>
      find.descendant(of: find.byType(TodayScreen), matching: matching);

  /// A tall surface, so a ListView builds the whole routine. It only builds
  /// what is near the viewport, so off-screen steps genuinely don't exist.
  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(420 * 3, 1900 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('HUD lays out without overflow at phone width', (
    WidgetTester tester,
  ) async {
    // Moto G35 is roughly 360x800 logical pixels. The default test surface is
    // 800x600, wider than any phone, so without this the wide letter-spaced
    // HUD text could overflow on the real device and the tests would never
    // notice. A RenderFlex overflow fails the test automatically.
    tester.view.physicalSize = const Size(360 * 3, 800 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildApp());
    await settle(tester);

    expect(inToday(find.text('DAILY QUESTS')), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('the persistent RankHeader shows Hunter, rank and level', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await settle(tester);

    expect(find.text('HUNTER'), findsOneWidget);
    expect(find.text('PRINCE'), findsOneWidget); // seeded player name
    expect(find.text('LEVEL 1'), findsOneWidget);
    expect(find.text('E RANK'), findsOneWidget); // fresh player
    // The crest is artwork, so it announces itself through semantics rather
    // than through any text a finder could match.
    expect(find.bySemanticsLabel('E rank'), findsOneWidget);

    // Shell counter bar.
    expect(find.text('TOTAL XP'), findsOneWidget);
    expect(find.text('STREAK'), findsOneWidget);
    expect(find.text('PERFECT'), findsOneWidget);
    expect(find.bySemanticsLabel('Open navigation hub'), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('the quests screen shows the day, countdown and routine', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);

    expect(inToday(find.text('DAILY QUESTS')), findsOneWidget);
    expect(find.text('REFRESH IN'), findsOneWidget);
    expect(find.text('DAILY XP'), findsOneWidget);
    expect(find.text('ROUTINE'), findsOneWidget);
    // Every step of the day is listed, whatever state it's in — the ones
    // already gone are context, not clutter.
    expect(find.text('Morning skincare'), findsOneWidget);
    expect(find.text('Sleep by 11pm'), findsOneWidget);
    // Times are shown so the list reads as a schedule.
    expect(find.text('5:35 AM'), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('exactly one step is live, and it is the one whose time it is', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);

    // 21:30, so the 8pm water step is inside its window and everything
    // earlier has closed itself out.
    expect(inToday(find.text('NOW · 8:00 PM')), findsOneWidget);
    // The two answers exist once each: there is only ever one active card.
    expect(inToday(find.text('DONE')), findsOneWidget);
    expect(inToday(find.text('MISSED')), findsOneWidget);
    // The 9pm step has not opened yet, so it is not offering itself.
    expect(inToday(find.text('NOW · 9:00 PM')), findsNothing);

    await disposeTree(tester);
  });

  testWidgets('the morning steps closed themselves out as missed', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);

    // Nobody opened the app all morning; the day still resolved itself, and
    // the day panel reports the count.
    //
    // Matched by pattern rather than by an exact number, because Saturday
    // issues one extra step — a test that only passes six days a week is
    // worse than no test.
    //
    // Asserted through the UI rather than by awaiting a database query here:
    // inside testWidgets the fake clock does not advance for real async, so
    // awaiting a drift stream in the test body hangs forever.
    expect(
      inToday(find.textContaining(RegExp(r'^[1-9]\d* missed$'))),
      findsOneWidget,
    );

    await disposeTree(tester);
  });

  testWidgets('resuming the app on the same day leaves the screen intact', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await settle(tester);

    // TodayScreen observes the lifecycle so it can reissue the day if the app
    // was left open across midnight. Resuming on the SAME day must be a no-op
    // — this guards the observer path against throwing or wiping state.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await settle(tester);

    expect(inToday(find.text('DAILY QUESTS')), findsOneWidget);
    expect(find.text('Drink 3L water'), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('answering DONE adds the step XP to the daily total', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);

    // Two zeroed readouts on the screen itself: the steps-cleared counter and
    // the DAILY XP bar. Scoped to TodayScreen because the shell's RankHeader
    // now shows a third one (XP toward the next level).
    expect(inToday(find.textContaining(RegExp(r'^0 / '))), findsNWidgets(2));

    await tester.tap(inToday(find.text('DONE')));
    await settle(tester);

    // Drink 3L water is worth 10 XP.
    expect(inToday(find.textContaining(RegExp(r'^10 / '))), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('answering MISSED resolves the step without awarding XP', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);

    await tester.tap(inToday(find.text('MISSED')));
    await settle(tester);

    // A miss is an answer, so the day advances — but the XP bar does not move.
    expect(inToday(find.textContaining(RegExp(r'^0 / '))), findsNWidgets(2));
    expect(inToday(find.text('NOW · 8:00 PM')), findsNothing);

    await disposeTree(tester);
  });

  testWidgets('between windows the screen says what is coming next', (
    WidgetTester tester,
  ) async {
    // 19:00 — the 1pm step shut at 6pm and the 8pm step has not opened, so
    // nothing at all is active. The screen must explain the gap rather than
    // showing a wall of grey rows.
    final evening = FixedClock.todayAt(19, 0);
    await QuestRepository(db, clock: evening).materialiseDay(evening.now());

    useTallSurface(tester);
    await tester.pumpWidget(
      MyApp(
        questRepository: QuestRepository(db, clock: evening),
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
      ),
    );
    await settle(tester);

    expect(inToday(find.text('NEXT AT 8:00 PM')), findsOneWidget);
    expect(inToday(find.text('DONE')), findsNothing);

    await disposeTree(tester);
  });

  testWidgets('the claim button stays disabled until every step is answered', (
    WidgetTester tester,
  ) async {
    // The button sits at the bottom of the list; a ListView only builds what
    // is near the viewport, so on a short surface it would not exist at all.
    useTallSurface(tester);

    await tester.pumpWidget(buildApp());
    await settle(tester);

    // It reports what is left rather than offering a "tick everything"
    // shortcut, which would defeat the point of the app.
    expect(find.textContaining('QUESTS REMAINING'), findsOneWidget);
    expect(find.text('CLAIM DAY'), findsNothing);

    await disposeTree(tester);
  });
}
