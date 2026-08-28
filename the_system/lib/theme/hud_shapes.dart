import 'package:flutter/material.dart';

/// A rectangle with the corners cut off at 45° instead of rounded.
///
/// This one shape does most of the work in selling the "sci-fi HUD" look —
/// rounded corners read as friendly/consumer, cut corners read as technical.
/// By default only the top-left and bottom-right are cut, which gives the
/// slightly off-balance, panel-stencilled-onto-glass feel.
///
/// Flutter-specific note: this extends [OutlinedBorder] rather than being a
/// [CustomPainter]. Doing it as a shape means [ShapeDecoration] can use it for
/// the fill, the border AND the outer glow at once, so all three follow the
/// same cut-corner outline automatically.
class ChamferBorder extends OutlinedBorder {
  /// How far in from each corner the cut starts, in logical pixels.
  final double cut;

  final bool topLeft;
  final bool topRight;
  final bool bottomRight;
  final bool bottomLeft;

  const ChamferBorder({
    super.side = BorderSide.none,
    this.cut = 12,
    this.topLeft = true,
    this.topRight = false,
    this.bottomRight = true,
    this.bottomLeft = false,
  });

  Path _buildPath(Rect r, double inset) {
    // Never let the cut grow past half the shorter side, or the corners
    // would overlap and the path would fold in on itself.
    final double c = cut.clamp(0.0, r.shortestSide / 2);
    final Rect b = r.deflate(inset);
    final double tl = topLeft ? c : 0;
    final double tr = topRight ? c : 0;
    final double br = bottomRight ? c : 0;
    final double bl = bottomLeft ? c : 0;

    return Path()
      ..moveTo(b.left + tl, b.top)
      ..lineTo(b.right - tr, b.top)
      ..lineTo(b.right, b.top + tr)
      ..lineTo(b.right, b.bottom - br)
      ..lineTo(b.right - br, b.bottom)
      ..lineTo(b.left + bl, b.bottom)
      ..lineTo(b.left, b.bottom - bl)
      ..lineTo(b.left, b.top + tl)
      ..close();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _buildPath(rect, 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _buildPath(rect, side.width);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none) return;
    // Stroke sits centred on the path, so inset by half the width to keep the
    // whole line inside the shape's bounds.
    canvas.drawPath(
      _buildPath(rect, side.width / 2),
      side.toPaint()..style = PaintingStyle.stroke,
    );
  }

  @override
  ChamferBorder copyWith({BorderSide? side, double? cut}) => ChamferBorder(
    side: side ?? this.side,
    cut: cut ?? this.cut,
    topLeft: topLeft,
    topRight: topRight,
    bottomRight: bottomRight,
    bottomLeft: bottomLeft,
  );

  @override
  ShapeBorder scale(double t) => copyWith(side: side.scale(t), cut: cut * t);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);
}
