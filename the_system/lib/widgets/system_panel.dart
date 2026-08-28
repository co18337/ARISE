import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// The building block of the whole UI: a dark, semi-transparent card with a
/// thin glowing cut-corner border — the Solo Leveling "status window".
///
/// Every panel on every screen should be one of these, so the look stays
/// consistent as more screens get added.
class SystemPanel extends StatelessWidget {
  /// Optional heading, rendered uppercase in the HUD label style.
  final String? title;

  final Widget child;

  /// Border/glow colour. Defaults to the signature cyan; pass gold or purple
  /// for a rank or level-up panel later.
  final Color accent;

  /// How strong the outer glow is, 0..1. Kept low by default — the glow
  /// should suggest emission, not look like a blur bug.
  final double glow;

  final EdgeInsetsGeometry padding;

  /// Draws small L-shaped brackets at the square corners (a tactical-overlay
  /// touch borrowed from Ingress-style HUDs).
  final bool showCornerBrackets;

  const SystemPanel({
    super.key,
    this.title,
    required this.child,
    this.accent = AppColors.primary,
    this.glow = 0.30,
    this.padding = const EdgeInsets.all(16),
    this.showCornerBrackets = true,
  });

  @override
  Widget build(BuildContext context) {
    final Widget panel = DecoratedBox(
      // ShapeDecoration (rather than BoxDecoration) so the fill, the 1px
      // border and the outer glow all follow the chamfered outline.
      decoration: ShapeDecoration(
        color: AppColors.panelFill,
        shape: ChamferBorder(
          cut: 14,
          side: BorderSide(color: accent.withValues(alpha: 0.55), width: 1),
        ),
        shadows: [
          BoxShadow(
            color: accent.withValues(alpha: glow * 0.5),
            blurRadius: 18,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[_PanelTitle(title!, accent: accent), const SizedBox(height: 12)],
            child,
          ],
        ),
      ),
    );

    if (!showCornerBrackets) return panel;

    // CustomPaint wraps the panel so the brackets draw on top of the border,
    // right at its edges, without affecting layout.
    return CustomPaint(foregroundPainter: _CornerBracketPainter(accent), child: panel);
  }
}

/// Panel heading: a short glowing tick, then the title in spaced caps, then a
/// hairline rule filling the remaining width.
class _PanelTitle extends StatelessWidget {
  final String text;
  final Color accent;

  const _PanelTitle(this.text, {required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 13,
          decoration: BoxDecoration(
            color: accent,
            boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.8), blurRadius: 6)],
          ),
        ),
        const SizedBox(width: 8),
        Text(text.toUpperCase(), style: AppTextStyles.panelTitle.copyWith(color: accent)),
        const SizedBox(width: 10),
        Expanded(
          child: Container(height: 1, color: accent.withValues(alpha: 0.22)),
        ),
      ],
    );
  }
}

/// Draws short L-brackets at the two square corners (top-right, bottom-left).
/// The other two are chamfered, so brackets there would fight the cut.
class _CornerBracketPainter extends CustomPainter {
  final Color accent;

  _CornerBracketPainter(this.accent);

  @override
  void paint(Canvas canvas, Size size) {
    const double len = 10;
    final Paint p = Paint()
      ..color = accent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Top-right corner.
    canvas.drawPath(
      Path()
        ..moveTo(size.width - len, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, len),
      p,
    );
    // Bottom-left corner.
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - len)
        ..lineTo(0, size.height)
        ..lineTo(len, size.height),
      p,
    );
  }

  // Only repaint if the colour actually changed.
  @override
  bool shouldRepaint(_CornerBracketPainter old) => old.accent != accent;
}
