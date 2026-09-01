import 'dart:math' as math;

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
import 'package:the_system/data/health/health_source.dart';
import 'package:the_system/data/repositories/health_repository.dart';
import 'package:the_system/data/repositories/plan_repository.dart';
import 'package:the_system/data/repositories/progress_repository.dart';
import 'package:the_system/data/repositories/review_repository.dart';
import 'package:the_system/data/repositories/quest_repository.dart';
import 'package:the_system/data/repositories/workout_repository.dart';
import 'package:the_system/game/game.dart';
import 'package:the_system/main.dart';
import 'package:the_system/screens/backup_screen.dart';
import 'package:the_system/screens/nav_hub.dart';
import 'package:the_system/widgets/system_panel.dart';
import 'package:the_system/theme/theme.dart';
import 'package:the_system/widgets/theme_toggle_button.dart';

/// Relative luminance, per the sRGB definition used by WCAG.
double _luminance(Color c) {
  double channel(double v) => v <= 0.03928
      ? v / 12.92
      : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * channel(c.r) + 0.7152 * channel(c.g) + 0.0722 * channel(c.b);
}

/// WCAG contrast ratio, 1 (identical) to 21 (black on white).
double _contrast(Color a, Color b) {
  final la = _luminance(a), lb = _luminance(b);
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('palettes', () {
    test('both palettes define every colour and declare their brightness', () {
      expect(AppPalette.dark.isDark, isTrue);
      expect(AppPalette.warm.isDark, isFalse);
    });

    test('text is legible against its own background in both palettes', () {
      // The point of a second palette is that the neon values do NOT carry
      // over. This is the check that catches a colour copied across unchanged.
      for (final p in [AppPalette.dark, AppPalette.warm]) {
        final name = p.isDark ? 'dark' : 'warm';
        expect(_contrast(p.textPrimary, p.background), greaterThan(7),
            reason: '$name: primary text on background');
        expect(_contrast(p.textSecondary, p.background), greaterThan(3),
            reason: '$name: secondary text on background');
        expect(_contrast(p.primary, p.background), greaterThan(2.5),
            reason: '$name: signature colour on background');
        expect(_contrast(p.danger, p.background), greaterThan(2.5),
            reason: '$name: danger on background');
      }
    });

    test('the two palettes are genuinely different', () {
      expect(AppPalette.warm.background, isNot(AppPalette.dark.background));
      expect(AppPalette.warm.textPrimary, isNot(AppPalette.dark.textPrimary));
      expect(AppPalette.warm.accentGold, isNot(AppPalette.dark.accentGold));
    });
  });

  group('mode resolution', () {
    test('dark and warm ignore the phone', () {
      for (final b in Brightness.values) {
        expect(AppTheme.paletteFor(AppThemeMode.dark, b), AppPalette.dark);
        expect(AppTheme.paletteFor(AppThemeMode.warm, b), AppPalette.warm);
      }
    });

    test('auto follows the phone', () {
      expect(
        AppTheme.paletteFor(AppThemeMode.auto, Brightness.dark),
        AppPalette.dark,
      );
      expect(
        AppTheme.paletteFor(AppThemeMode.auto, Brightness.light),
        AppPalette.warm,
      );
    });
  });

  group('persistence', () {
    test('the chosen mode survives a restart', () async {
      final repo = PlayerRepository(db);
      expect(await repo.readThemeMode(), AppThemeMode.dark); // seeded default

      await repo.setThemeMode(AppThemeMode.warm);
      expect(await repo.readThemeMode(), AppThemeMode.warm);

      await repo.setThemeMode(AppThemeMode.auto);
      expect(await repo.readThemeMode(), AppThemeMode.auto);
    });

    test('an unrecognised stored value falls back to dark', () async {
      // A value written by a future build, opened by this one. Better a
      // readable app than a crash on launch.
      await db.customStatement(
        "UPDATE player_states SET theme_mode = 'neon' WHERE id = 0",
      );
      expect(await PlayerRepository(db).readThemeMode(), AppThemeMode.dark);
    });
  });

  group('the switch', () {
    Widget app(AppThemeMode mode) => MyApp(
      questRepository: QuestRepository(db, clock: FixedClock.todayAt(21, 30)),
      playerRepository: PlayerRepository(db),
      activityRepository: ActivityRepository(db),
      exportRepository: ExportRepository(db),
      workoutRepository: WorkoutRepository(db, clock: FixedClock.todayAt(21, 30)),
      memoryRepository: MemoryRepository(db),
      aiLogRepository: AiLogRepository(db),
      nutritionRepository: NutritionRepository(db, clock: FixedClock.todayAt(21, 30)),
      progressRepository: ProgressRepository(db),
      planRepository: PlanRepository(db),
      reviewRepository: ReviewRepository(
        db: db,
        progress: ProgressRepository(db),
        memory: MemoryRepository(db),
      ),
      healthRepository: HealthRepository(
        db: db,
        source: NoopHealthSource(),
        quests: QuestRepository(db),
      ),
      alertRepository: AlertRepository(
        quests: QuestRepository(db),
        notifier: NoopNotifier(),
      ),
      initialThemeMode: mode,
    );

    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    Future<void> disposeTree(WidgetTester tester) async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 10));
    }

    testWidgets('sits in the top-right and shows the active mode', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(app(AppThemeMode.dark));
      await settle(tester);

      expect(find.byType(ThemeToggleButton), findsOneWidget);
      expect(find.text('DARK'), findsOneWidget);

      await disposeTree(tester);
    });

    testWidgets('cycles dark to warm to auto and repaints', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(app(AppThemeMode.dark));
      await settle(tester);
      expect(AppColors.palette.isDark, isTrue);

      await tester.tap(find.byType(ThemeToggleButton));
      await settle(tester);
      expect(find.text('WARM'), findsOneWidget);
      // The global palette really swapped, which is what every widget reads.
      expect(AppColors.palette, AppPalette.warm);

      await tester.tap(find.byType(ThemeToggleButton));
      await settle(tester);
      expect(find.text('AUTO'), findsOneWidget);

      await tester.tap(find.byType(ThemeToggleButton));
      await settle(tester);
      expect(find.text('DARK'), findsOneWidget);

      await disposeTree(tester);
    });

    testWidgets('the whole app still lays out in the warm theme', (
      WidgetTester tester,
    ) async {
      // A light theme is where hardcoded dark-only assumptions surface, and a
      // RenderFlex overflow fails this outright.
      tester.view.physicalSize = const Size(360 * 3, 800 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(app(AppThemeMode.warm));
      await settle(tester);

      expect(find.text('PRINCE'), findsOneWidget);
      expect(find.text('DAILY QUESTS'), findsWidgets);
      expect(AppColors.palette.isDark, isFalse);

      await disposeTree(tester);
    });

    testWidgets('a screen with no live stream still repaints on a flip', (
      WidgetTester tester,
    ) async {
      // The regression: MaterialApp's `home` is captured by the Navigator when
      // the first route is pushed, so rebuilding MaterialApp with a new theme
      // never reached the screens. Streaming screens corrected themselves on
      // the next emission and looked fine; a wholly static one kept the old
      // palette — a light panel on a dark app.
      //
      // Driven through BACKUP, which has no StreamBuilder at all — a single
      // Future that resolves once and never emits again. It replaced the badge
      // gallery here when that dev screen left the hub, and it has to be a
      // SHELL SECTION rather than a pushed route: a pushed route covers the
      // shell bar, taking the theme toggle with it.
      tester.view.physicalSize = const Size(420 * 3, 1900 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(app(AppThemeMode.dark));
      await settle(tester);

      // Onto the most static screen in the app.
      await tester.tap(find.bySemanticsLabel('Open navigation hub'));
      await settle(tester);
      await tester.tap(
        find.descendant(of: find.byType(NavHub), matching: find.text('BACKUP')),
      );
      await settle(tester);
      expect(find.byType(BackupScreen), findsOneWidget);

      // The panel's own fill, which is the thing that stayed light.
      Color panelFill() {
        final panel = tester.widget<DecoratedBox>(
          find
              .descendant(
                of: find.byType(SystemPanel),
                matching: find.byType(DecoratedBox),
              )
              .first,
        );
        return (panel.decoration as ShapeDecoration).color!;
      }

      final inDark = panelFill();

      await tester.tap(find.byType(ThemeToggleButton));
      await settle(tester);
      final inWarm = panelFill();
      expect(
        inWarm,
        isNot(inDark),
        reason: 'the static screen did not repaint when the theme changed',
      );
      expect(inWarm, AppPalette.warm.panelFill);

      // And back again — the half that used to stay stuck.
      // Settling BETWEEN the taps matters: the button computes the next mode
      // from the one it was built with, so two taps in the same frame both
      // read "warm" and land on AUTO rather than stepping through to dark.
      await tester.tap(find.byType(ThemeToggleButton)); // warm -> auto
      await settle(tester);
      await tester.tap(find.byType(ThemeToggleButton)); // auto -> dark
      await settle(tester);
      expect(find.text('DARK'), findsOneWidget);
      expect(
        panelFill(),
        inDark,
        reason: 'flipping back left the old palette behind',
      );

      await disposeTree(tester);
    });

    testWidgets('choosing a mode writes it to the database', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(app(AppThemeMode.dark));
      await settle(tester);

      await tester.tap(find.byType(ThemeToggleButton));
      await settle(tester);

      expect(await PlayerRepository(db).readThemeMode(), AppThemeMode.warm);

      await disposeTree(tester);
    });
  });
}
