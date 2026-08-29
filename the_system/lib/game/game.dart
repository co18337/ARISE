// Barrel file: `import '../game/game.dart';` gets the whole game engine.
//
// Everything in here is PURE Dart — no Flutter, no database, no I/O. That is
// what makes the progression rules testable without a device and swappable
// without touching storage or widgets.
export 'clock.dart';
export 'game_rules.dart';
export 'level_curve.dart';
export 'rank.dart';
export 'routine.dart';
export 'streaks.dart';
