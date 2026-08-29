/// Where the player sits inside their current level.
class LevelProgress {
  final int level;

  /// XP earned since reaching [level].
  final int xpIntoLevel;

  /// XP needed to go from [level] to the next one.
  final int xpForLevel;

  const LevelProgress({
    required this.level,
    required this.xpIntoLevel,
    required this.xpForLevel,
  });

  /// 0..1, for a progress bar.
  double get fraction => xpForLevel <= 0 ? 0 : xpIntoLevel / xpForLevel;

  int get xpRemaining => xpForLevel - xpIntoLevel;
}

/// Converts a running XP total into a level.
///
/// The cost of each level grows linearly ([base], then +[increment] per
/// level), which makes the TOTAL XP curve quadratic: early levels arrive fast
/// enough to feel rewarding, later ones take real commitment. Two instances
/// exist — see GameRules — because the hunter level and the four stat levels
/// should not advance at the same rate.
class LevelCurve {
  final int base;
  final int increment;

  const LevelCurve({required this.base, required this.increment});

  /// XP needed to advance FROM [level] to [level] + 1.
  int xpForLevel(int level) => base + (level - 1) * increment;

  /// Total XP needed to reach [level] starting from nothing.
  int totalXpToReach(int level) {
    final steps = level - 1;
    if (steps <= 0) return 0;
    // Arithmetic series: steps * base + increment * (0 + 1 + ... + steps-1)
    return steps * base + increment * (steps * (steps - 1)) ~/ 2;
  }

  /// The level a player with [totalXp] has reached. Levels start at 1.
  ///
  /// A loop rather than inverting the quadratic: it's obviously correct at a
  /// glance, and the iteration count is the player's level — a few dozen at
  /// most, so the clarity costs nothing.
  int levelForXp(int totalXp) {
    var level = 1;
    var remaining = totalXp < 0 ? 0 : totalXp;
    while (remaining >= xpForLevel(level)) {
      remaining -= xpForLevel(level);
      level++;
    }
    return level;
  }

  LevelProgress progressFor(int totalXp) {
    final level = levelForXp(totalXp);
    return LevelProgress(
      level: level,
      xpIntoLevel: (totalXp < 0 ? 0 : totalXp) - totalXpToReach(level),
      xpForLevel: xpForLevel(level),
    );
  }
}
