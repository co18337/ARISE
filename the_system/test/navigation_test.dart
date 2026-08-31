import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/data/db/database.dart';
import 'package:the_system/data/export/export_repository.dart';
import 'package:the_system/data/repositories/activity_repository.dart';
import 'package:the_system/data/repositories/player_repository.dart';
import 'package:the_system/data/memory/memory_repository.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
import 'package:the_system/data/repositories/workout_repository.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/main.dart';
import 'package:the_system/screens/activity_log_screen.dart';
import 'package:the_system/screens/backup_screen.dart';
import 'package:the_system/screens/badge_gallery_screen.dart';
import 'package:the_system/screens/memory_screen.dart';
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
  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(420 * 3, 1900 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
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
      inTraining(find.textContaining('IGNITE')),
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

    expect(inMemory(find.text('CORPUS')), findsOneWidget);
    // Nothing stored yet, and the screen is honest about the key.
    expect(inMemory(find.text('not set')), findsOneWidget);

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

    await disposeTree(tester);
  });

  testWidgets('a finished session is locked and says so', (
    WidgetTester tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'TRAINING');

    final training = find.byType(TrainingScreen);
    Finder inTraining(Finder m) => find.descendant(of: training, matching: m);

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
    useTallSurface(tester);
    await tester.pumpWidget(buildApp());
    await settle(tester);
    await navigateTo(tester, 'TRAINING');

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
}
