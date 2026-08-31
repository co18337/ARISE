import 'package:flutter/material.dart';

import '../game/game.dart';
import '../theme/theme.dart';
import 'badge_image.dart';

/// The Hunter's rank crest.
///
/// Real illustrated artwork rather than a shape drawn in code. The painted
/// shield it replaced was defensible but flat: bevels faked with two strokes
/// only read as metal at large sizes, and this sits at 38dp in the header
/// where the illustration wins easily.
///
/// The crests escalate deliberately — plain disc at E, then a coloured
/// pentagon, then gold, and wings from B rank up, so the ladder is legible
/// without reading the letter.
class RankEmblem extends StatelessWidget {
  final Rank rank;
  final double size;

  const RankEmblem({super.key, required this.rank, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${rank.label} rank',
      child: BadgeImage(
        asset: rank.badgeAsset,
        size: size,
        glow: rank.color,
      ),
    );
  }
}
