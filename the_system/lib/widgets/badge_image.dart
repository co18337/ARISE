import 'package:flutter/material.dart';

import '../game/game.dart';

/// One of the bundled badge illustrations from assets/badges.
///
/// The artwork is full-colour, so unlike the stat emblems it is NOT tinted —
/// each crest and tier already carries its own metal. Locked states dim it
/// instead, which keeps the shape readable while making it obviously unearned.
class BadgeImage extends StatelessWidget {
  /// File stem in assets/badges, e.g. `crest_s` or `tier_gold`.
  final String asset;

  final double size;

  /// 1.0 = fully lit. Lower values desaturate and darken for a locked badge.
  final double opacity;

  /// Draws a coloured bloom behind the badge.
  final Color? glow;

  const BadgeImage({
    super.key,
    required this.asset,
    required this.size,
    this.opacity = 1.0,
    this.glow,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      'assets/badges/$asset.png',
      width: size,
      height: size,
      // The source art is around 130px; letting Flutter filter it smoothly
      // matters more than sharpness when it is drawn at 38dp in the header.
      filterQuality: FilterQuality.medium,
    );

    if (opacity < 1) {
      // Greyscale as well as dim: a merely faded gold badge still reads as
      // gold, which would make a locked tier look earned at a glance.
      image = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child: Opacity(opacity: opacity, child: image),
      );
    }

    if (glow == null) return image;

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: glow!.withValues(alpha: 0.34),
            blurRadius: size * 0.42,
            spreadRadius: -size * 0.14,
          ),
        ],
      ),
      child: image,
    );
  }
}

/// Each rank's crest. The enum name IS the filename, so adding a rank means
/// adding one image and nothing else.
extension RankBadge on Rank {
  String get badgeAsset => 'crest_$name';
}
