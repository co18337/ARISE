import 'package:flutter/material.dart';

/// Corner radii, in one place.
///
/// This app used to cut its corners at 45° instead of rounding them, on the
/// theory that angular reads "technical" and rounded reads "consumer". Seen at
/// real size on a phone it didn't hold up: at chip and button scale the notch
/// is only a few pixels and reads as a rendering artefact rather than a
/// decision, and repeating it on every surface made the whole screen look
/// unfinished. Soft, consistent radii carry the sci-fi feel far better — the
/// look comes from the palette, the glow and the typography, not the corners.
///
/// The scale is deliberately small: four steps, each visibly different from
/// the next. More than that and nothing reads as a system.
class AppRadii {
  AppRadii._();

  /// Large surfaces — panels, cards, the active step.
  static const double panel = 16;

  /// One row of a list, rendered as its own card.
  static const double row = 12;

  /// Buttons and other controls.
  static const double control = 12;

  /// Fully round. Used for stat pills and counters.
  static const double pill = 999;

  static BorderRadius get panelRadius => BorderRadius.circular(panel);
  static BorderRadius get rowRadius => BorderRadius.circular(row);
  static BorderRadius get controlRadius => BorderRadius.circular(control);
  static BorderRadius get pillRadius => BorderRadius.circular(pill);
}

/// Shorthand for the [ShapeDecoration] shapes used across the app.
///
/// [ShapeDecoration] (rather than BoxDecoration) is still the right tool: it
/// makes the fill, the border and the outer glow all follow one outline, which
/// is what keeps a glowing panel looking like a single object.
class AppShapes {
  AppShapes._();

  static RoundedRectangleBorder rounded(
    double radius, {
    BorderSide side = BorderSide.none,
  }) => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
    side: side,
  );

  static RoundedRectangleBorder panel({BorderSide side = BorderSide.none}) =>
      rounded(AppRadii.panel, side: side);

  static RoundedRectangleBorder row({BorderSide side = BorderSide.none}) =>
      rounded(AppRadii.row, side: side);

  static RoundedRectangleBorder control({BorderSide side = BorderSide.none}) =>
      rounded(AppRadii.control, side: side);

  static StadiumBorder pill({BorderSide side = BorderSide.none}) =>
      StadiumBorder(side: side);
}
