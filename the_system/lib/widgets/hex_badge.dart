import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Achievement tiers. Colours come from our own palette — no badge artwork is
/// copied from anywhere, every hexagon here is drawn by [_HexPainter].
enum BadgeTier {
  bronze(Color(0xFFB87333)),
  silver(Color(0xFFB8C4D0)),
  gold(AppColors.accentGold),
  platinum(Color(0xFF7DF9FF)),
  apex(AppColors.accentMagenta);

  final Color color;

  const BadgeTier(this.color);
}

/// A hexagonal achievement badge: a dim outline when locked, lit when earned.
///
/// The hexagon is painted rather than shipped as an image, so it scales to any
/// size, recolours per tier for free, and stays original artwork.
class HexBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final BadgeTier tier;
  final bool earned;
  final double size;
  final VoidCallback? onTap;

  const HexBadge({
    super.key,
    required this.icon,
    required this.label,
    this.tier = BadgeTier.bronze,
    this.earned = false,
    this.size = 72,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = earned ? tier.color : AppColors.textDim;

    return Semantics(
      label: '$label, ${earned ? 'earned' : 'locked'}',
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: _HexPainter(color: color, earned: earned),
                child: Center(
                  child: Icon(
                    icon,
                    size: size * 0.36,
                    color: earned ? color : AppColors.textDim,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: size + 14,
              child: Text(
                label.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.hudLabel.copyWith(
                  color: color,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HexPainter extends CustomPainter {
  final Color color;
  final bool earned;

  _HexPainter({required this.color, required this.earned});

  /// Flat-top hexagon inscribed in the box.
  Path _hexPath(Size size, double inset) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) - inset;
    final path = Path();
    for (var i = 0; i < 6; i++) {
      // Start at -30° so the hexagon sits flat-topped rather than pointy-topped.
      final angle = (math.pi / 3) * i - math.pi / 6;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    return path..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final outer = _hexPath(size, 1.5);

    if (earned) {
      // Outer bloom, drawn first so the border sits crisply on top of it.
      canvas.drawPath(
        outer,
        Paint()
          ..color = color.withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }

    canvas.drawPath(
      outer,
      Paint()..color = color.withValues(alpha: earned ? 0.16 : 0.05),
    );

    canvas.drawPath(
      outer,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = earned ? 2 : 1
        ..color = color.withValues(alpha: earned ? 0.95 : 0.4),
    );

    // A second inner ring reads as machined depth; only earned badges get it,
    // which is most of what makes them look "lit".
    if (earned) {
      canvas.drawPath(
        _hexPath(size, size.width * 0.13),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = color.withValues(alpha: 0.45),
      );
    }
  }

  @override
  bool shouldRepaint(_HexPainter old) =>
      old.color != color || old.earned != earned;
}
