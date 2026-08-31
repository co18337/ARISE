import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// The background behind every screen: a faint technical grid with a soft
/// cyan bloom at the top, so panels look like they're projected onto a
/// surface rather than floating on flat black.
class HudBackdrop extends StatelessWidget {
  final Widget child;

  const HudBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.background,
        gradient: RadialGradient(
          center: const Alignment(0, -1.1), // bloom originates above the screen
          radius: 1.3,
          colors: [AppColors.bloom, AppColors.background],
        ),
      ),
      // RepaintBoundary keeps the static grid from being repainted every
      // time a quest animates on top of it.
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _GridPainter(),
          child: child,
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  static const double _spacing = 32;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()
      ..color = AppColors.grid
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += _spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += _spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  // The grid never changes, so it never needs repainting.
  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}
