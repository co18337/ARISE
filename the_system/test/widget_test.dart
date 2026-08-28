import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:the_system/main.dart';

void main() {
  testWidgets('HUD lays out without overflow at phone width', (
    WidgetTester tester,
  ) async {
    // Moto G35 is roughly 360x800 logical pixels. The default test surface is
    // 800x600, which is wider than any phone — so without this the wide
    // letter-spaced HUD text could overflow on the real device and the tests
    // would never notice. A RenderFlex overflow fails the test automatically.
    tester.view.physicalSize = const Size(360 * 3, 800 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('DAILY QUESTS'), findsOneWidget);
  });

  testWidgets('Today screen renders the System HUD', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('THE SYSTEM'), findsOneWidget);
    expect(find.text('DAILY QUESTS'), findsOneWidget);
    expect(find.text('HUNTER'), findsOneWidget);
    expect(find.text('DAILY XP'), findsOneWidget);
    // "Morning skincare" is a daily quest, so it appears whatever the date.
    expect(find.text('Morning skincare'), findsOneWidget);
  });

  testWidgets('completing a quest adds its XP to the daily total', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Nothing completed yet: both the XP bar and the quests-cleared
    // readout sit at "0 / <total>".
    expect(find.textContaining(RegExp(r'^0 / ')), findsNWidgets(2));

    await tester.tap(find.text('Morning skincare'));
    // pumpAndSettle waits out the completion pulse + XP bar animations.
    await tester.pumpAndSettle();

    // Morning skincare is worth 10 XP.
    expect(find.textContaining(RegExp(r'^10 / ')), findsOneWidget);
    expect(find.textContaining(RegExp(r'^1 / ')), findsOneWidget);
  });
}
