import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'hud_backdrop.dart';
import 'hud_section_title.dart';

/// The frame every full-screen overlay sits in.
///
/// Supplies the backdrop, the heading, and the circular X at bottom centre.
/// Every overlay dismisses the same way, from the same place on screen — that
/// single consistent affordance is most of why Ingress's many overlays feel
/// like one app instead of a pile of screens.
class HudOverlayScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Color accent;

  const HudOverlayScaffold({
    super.key,
    required this.title,
    required this.child,
    this.accent = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent so the translucent route shows the screen underneath.
      backgroundColor: Colors.transparent,
      body: HudBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: HudSectionTitle(title, accent: accent),
              ),
              Expanded(child: child),
              const _CloseButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Semantics(
        button: true,
        label: 'Close',
        child: InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceRaised.withValues(alpha: 0.8),
              border: Border.all(
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
            ),
            child: const Icon(
              Icons.close,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
