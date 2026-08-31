import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/models.dart';

/// One of the bundled game-icons.net emblems, tinted to any colour.
///
/// The files are white-on-transparent single-path SVGs, so ONE asset recolours
/// to every rank and stat at runtime — no separate image per colour, and it
/// stays crisp at any size. `colorFilter` with `srcIn` replaces the artwork's
/// own colour rather than blending with it, which is what makes the tint exact.
///
/// Artwork: game-icons.net, CC BY 3.0. Attribution is a licence condition and
/// lives in assets/icons/CREDITS.md, on the BACKUP screen, and in
/// LicenseRegistry (see main.dart).
class GameIcon extends StatelessWidget {
  /// File stem in assets/icons, e.g. `rank_s`.
  final String asset;

  final Color color;
  final double size;

  const GameIcon(
    this.asset, {
    super.key,
    required this.color,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$asset.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

/// Each stat's emblem: biceps, runner, hourglass, leaf.
///
/// The enum's own name IS the filename, so adding a stat means adding one file
/// and nothing else.
extension StatTypeIcon on StatType {
  String get iconAsset => 'stat_$name';
}
