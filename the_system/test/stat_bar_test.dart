import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_system/theme/theme.dart';
import 'package:the_system/widgets/stat_bar.dart';

/// The bar is the app's main feedback surface — level XP, daily XP, sets
/// logged, every stat on STATUS, weekly adherence. It shipped with the fill
/// collapsed to zero height, so a completed 4/4 session showed an empty track
/// and it looked like the data had not saved. These tests measure the fill.
void main() {
  Widget host(Widget child) => MaterialApp(
    theme: AppTheme.dark,
    home: Scaffold(
      body: Center(
        child: SizedBox(width: 300, child: child),
      ),
    ),
  );

  /// The painted fill: the DecoratedBox inside the FractionallySizedBox.
  Finder fillOf(WidgetTester tester) => find
      .descendant(
        of: find.byType(FractionallySizedBox),
        matching: find.byType(DecoratedBox),
      )
      .first;

  Future<void> settle(WidgetTester tester) async {
    // The fill animates in, so let the tween finish before measuring.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('a full bar paints a fill the height of the track', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(const StatBar(label: 'Sets logged', value: 4, max: 4, height: 12)),
    );
    await settle(tester);

    final fill = tester.getSize(fillOf(tester));
    // The regression: this was 0.0 tall, because a Stack lays out its
    // non-positioned children loosely and a childless DecoratedBox takes the
    // smallest size on offer.
    expect(fill.height, greaterThan(0), reason: 'the fill has no height');
    // Track is 12 tall with a 1px border, so the fill sits just inside it.
    expect(fill.height, closeTo(10, 2));
    expect(fill.width, greaterThan(200), reason: '4/4 should fill the track');
  });

  testWidgets('a half-full bar paints about half the width', (tester) async {
    await tester.pumpWidget(
      host(const StatBar(label: 'Daily XP', value: 44, max: 88, height: 10)),
    );
    await settle(tester);

    final fill = tester.getSize(fillOf(tester));
    expect(fill.height, greaterThan(0));
    // 300 wide minus the border; half of that.
    expect(fill.width, closeTo(149, 6));
  });

  testWidgets('an empty bar paints no fill but still has a track', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(const StatBar(label: 'Daily XP', value: 0, max: 88, height: 10)),
    );
    await settle(tester);

    expect(tester.getSize(fillOf(tester)).width, 0);
    // The track itself is still there to be filled.
    expect(find.byType(StatBar), findsOneWidget);
  });

  testWidgets('a bar with nothing scheduled does not divide by zero', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(const StatBar(label: 'Daily XP', value: 0, max: 0, height: 10)),
    );
    await settle(tester);
    expect(tester.getSize(fillOf(tester)).width, 0);
  });

  testWidgets('overshooting the max does not overflow the track', (
    tester,
  ) async {
    // Can happen when a template is re-rated after a quest was issued.
    await tester.pumpWidget(
      host(const StatBar(label: 'XP', value: 500, max: 88, height: 10)),
    );
    await settle(tester);

    final fill = tester.getSize(fillOf(tester));
    expect(fill.width, lessThanOrEqualTo(300));
    expect(fill.height, greaterThan(0));
  });
}
