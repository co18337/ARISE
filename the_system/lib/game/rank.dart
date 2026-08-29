/// Hunter rank, Solo Leveling style. Derived from the hunter level — never
/// stored, so it can never disagree with the XP that produced it.
///
/// Deliberately knows nothing about colours; the palette mapping lives in
/// lib/theme/rank_colors.dart so game logic stays independent of the UI.
enum Rank {
  e(minLevel: 1, label: 'E'),
  d(minLevel: 5, label: 'D'),
  c(minLevel: 10, label: 'C'),
  b(minLevel: 20, label: 'B'),
  a(minLevel: 35, label: 'A'),
  s(minLevel: 50, label: 'S');

  /// Lowest hunter level that holds this rank.
  final int minLevel;

  /// Single letter shown in the HUD badge.
  final String label;

  const Rank({required this.minLevel, required this.label});

  /// The rank for a given hunter level.
  static Rank forLevel(int level) {
    // Walk down from the highest rank and take the first one reached.
    for (final rank in Rank.values.reversed) {
      if (level >= rank.minLevel) return rank;
    }
    return Rank.e;
  }

  /// The next rank up, or null at S rank.
  Rank? get next {
    final i = index + 1;
    return i < Rank.values.length ? Rank.values[i] : null;
  }
}
