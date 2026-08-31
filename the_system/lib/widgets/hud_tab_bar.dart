import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Uppercase tabs with an underline on the active one — the COMM /
/// ALL TIME · MONTH · WEEK pattern from Ingress.
class HudTabBar extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Color? accent;

  const HudTabBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: InkWell(
              onTap: () => onSelected(i),
              child: _Tab(
                label: labels[i],
                selected: i == selectedIndex,
                accent: accent,
              ),
            ),
          ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? accent;

  const _Tab({required this.label, required this.selected, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.hudLabel.copyWith(
              color: selected ? accent : AppColors.textDim,
              fontSize: 11,
            ),
          ),
        ),
        // The underline animates so switching tabs reads as one indicator
        // sliding rather than two separate things blinking.
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 2,
          color: selected ? accent : Colors.transparent,
        ),
      ],
    );
  }
}
