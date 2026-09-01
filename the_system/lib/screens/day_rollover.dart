import 'package:flutter/widgets.dart';

import '../data/day_key.dart';
import '../game/game.dart';

/// Keeps a date-scoped screen honest across midnight.
///
/// An Android process is rarely killed, so a screen left open overnight keeps
/// the date it was built with. Every write it then makes lands on the wrong
/// day: a dinner typed at 00:05 is logged against yesterday, and ARISE summons
/// a session that is already over. Nothing warns you, because from the app's
/// point of view it is still the same afternoon.
///
/// TODAY has guarded against this since Phase 6 and keeps its own richer
/// version — it also runs a 30-second ticker to close lapsed steps, which the
/// other screens have no use for. This is the same rule, extracted for the
/// screens that only need the rule.
///
/// A host must mix in [WidgetsBindingObserver] as well:
///
/// ```dart
/// class _FooState extends State<Foo>
///     with WidgetsBindingObserver, DayRollover<Foo> { ... }
/// ```
mixin DayRollover<W extends StatefulWidget>
    on State<W>, WidgetsBindingObserver {
  /// The clock the screen reads its dates from — never `DateTime.now()`, or
  /// none of this can be tested.
  Clock get rolloverClock;

  /// The date the screen is currently showing.
  DateTime get shownDay;

  /// Rebuild whatever is scoped to a date: the day itself, and any future or
  /// stream opened against it. Called inside setState.
  void openDay();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    openDay();
  }

  @override
  void dispose() {
    // An observer outlives its widget unless removed, and then calls setState
    // on a dead State.
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state != AppLifecycleState.resumed) return;
    reopenIfDayChanged();
  }

  /// Reissues the screen if the calendar has moved on. Safe to call at any
  /// time — it does nothing on the same day, so it cannot loop.
  void reopenIfDayChanged() {
    if (!mounted) return;
    if (dayKeyOf(rolloverClock.now()) == dayKeyOf(shownDay)) return;
    setState(openDay);
  }
}
