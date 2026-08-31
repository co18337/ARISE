import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// The building block of the whole UI: a dark, semi-transparent card with a
/// soft rounded border and a faint glow.
///
/// Every panel on every screen should be one of these, so the look stays
/// consistent as more screens get added.
///
/// The corner brackets and the 45° notch this used to have are gone. Both were
/// trying to signal "HUD" through geometry, and at real size on a phone they
/// just made every surface look slightly broken. The signal now comes from the
/// palette, the glow and the letter-spacing — which is where it was always
/// doing the actual work.
class SystemPanel extends StatelessWidget {
  /// Optional heading, rendered uppercase in the HUD label style.
  final String? title;

  final Widget child;

  /// Border/glow colour. Defaults to the signature cyan; pass gold or purple
  /// for a rank or level-up panel.
  final Color? accent;

  /// How strong the outer glow is, 0..1. Kept low by default — the glow should
  /// suggest emission, not look like a blur bug.
  final double glow;

  final EdgeInsetsGeometry padding;

  /// Draws the heading's leading tick and hairline rule. Off for plain cards.
  final bool showTitleRule;

  const SystemPanel({
    super.key,
    this.title,
    required this.child,
    this.accent,
    this.glow = 0.30,
    this.padding = const EdgeInsets.all(16),
    this.showTitleRule = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = this.accent ?? AppColors.primary;
    return DecoratedBox(
      // ShapeDecoration (rather than BoxDecoration) so the fill, the 1px
      // border and the outer glow all follow the same rounded outline.
      decoration: ShapeDecoration(
        color: AppColors.panelFill,
        shape: AppShapes.panel(
          side: BorderSide(color: accent.withValues(alpha: 0.34), width: 1),
        ),
        shadows: [
          BoxShadow(
            color: accent.withValues(alpha: glow * 0.38),
            blurRadius: 20,
            spreadRadius: -6,
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              _PanelTitle(title!, accent: accent, rule: showTitleRule),
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

/// Panel heading: a short glowing tick, then the title in spaced caps, then a
/// hairline rule filling the remaining width.
class _PanelTitle extends StatelessWidget {
  final String text;
  final Color accent;
  final bool rule;

  const _PanelTitle(this.text, {required this.accent, required this.rule});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 13,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(color: accent.withValues(alpha: 0.8), blurRadius: 6),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.panelTitle.copyWith(color: accent),
          ),
        ),
        if (rule) ...[
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              color: accent.withValues(alpha: 0.18),
            ),
          ),
        ],
      ],
    );
  }
}
