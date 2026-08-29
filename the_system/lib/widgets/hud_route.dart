import 'package:flutter/material.dart';

/// Route transition for every full-screen overlay.
///
/// Material's default slide-from-the-right reads as "phone app". A fade with a
/// slight scale-up reads as a panel being projected, which is the whole point
/// of the System look. Kept in one place so every overlay opens identically —
/// that consistency is a big part of why Ingress feels coherent.
Route<T> hudRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    // Translucent so the screen underneath stays faintly visible, like a HUD
    // layer rather than a separate page.
    opaque: false,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (_, _, _) => page,
    transitionsBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}
