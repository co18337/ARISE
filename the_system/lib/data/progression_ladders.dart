import '../game/game.dart';

/// The ladders, as DATA.
///
/// Deliberately SHORT and deliberately few. Most gym movements do not ladder —
/// a lat pulldown does not become a different exercise, it gets heavier, and
/// that is what loadStepHalfKg is for. Laddering is for movements where the
/// next step really is a different movement because your own bodyweight is the
/// load and you cannot add to it.
///
/// The unlock rule is the point. A phase template says "assisted pull-ups in
/// week 17" whether or not you can hold a dead hang; a ladder says you hang
/// until hanging is easy, and only then start pulling.
class ProgressionLadders {
  ProgressionLadders._();

  /// Bodyweight pushing: bench, then floor, then parallel bars.
  static const ProgressionLadder push = ProgressionLadder([
    'incline_pushups',
    'pushups',
    'assisted_dips',
  ]);

  /// The bar, from zero. The plan's own progression — hang, then lower under
  /// control, then pull.
  static const ProgressionLadder pull = ProgressionLadder([
    'dead_hang',
    'negative_pullup',
    'pullups',
  ]);

  /// Machine-assisted pulling, for the gym days. Ends at the same place.
  static const ProgressionLadder assistedPull = ProgressionLadder([
    'lat_pulldown',
    'assisted_pullup',
    'pullups',
  ]);

  /// Trunk work: bracing, then bracing under rotation and load.
  static const ProgressionLadder trunk = ProgressionLadder([
    'dead_bug',
    'side_plank',
    'hanging_knee_raise',
  ]);

  static const List<ProgressionLadder> all = [push, pull, assistedPull, trunk];

  /// The movement to actually prescribe in place of [exerciseId].
  ///
  /// Returns the id unchanged when it is not on any ladder, which is most of
  /// them. A movement appearing on two ladders resolves against the FIRST it
  /// belongs to — pullups is the top of two, and the top rung resolves to
  /// itself either way, so the ambiguity cannot bite.
  static String resolve(
    String exerciseId,
    Map<String, ExerciseRecord> history,
  ) {
    for (final ladder in all) {
      if (ladder.contains(exerciseId)) return ladder.currentRung(history);
    }
    return exerciseId;
  }
}
