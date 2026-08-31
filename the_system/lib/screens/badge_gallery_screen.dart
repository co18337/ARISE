import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../widgets/badge_image.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/hud_tab_bar.dart';
import '../widgets/system_panel.dart';

/// DEV SCREEN — the usable badges, at the sizes they are really drawn at.
///
/// It exists to answer one question that cannot be answered by looking at the
/// files: which of these still read at 38dp? A badge that looks fine in a file
/// browser can be a smudge in a header.
///
/// It now shows only badges 21–32. Everything below that was ruled out after
/// looking at it here: 00–12 are flat dark silhouettes with no metal, which
/// all but vanish on this background; 13–20 are coloured but roughly 55px at
/// source, half the resolution of the rest; and 12, 13, 14 and 17 are
/// measurably clipped — their artwork runs off the edge of the crop.
///
/// Delete this screen and its nav entry once the picks are final. It costs no
/// extra assets: every badge here is one the app already ships.
class BadgeGalleryScreen extends StatefulWidget {
  const BadgeGalleryScreen({super.key});

  /// The badges available to assign — the ten in use plus two spares.
  static const List<({String asset, String number, String? role})> usable = [
    (asset: 'crest_e', number: '31', role: 'E RANK'),
    (asset: 'crest_d', number: '25', role: 'D RANK'),
    (asset: 'crest_c', number: '28', role: 'C RANK'),
    (asset: 'crest_b', number: '21', role: 'B RANK'),
    (asset: 'crest_a', number: '22', role: 'A RANK'),
    (asset: 'crest_s', number: '23', role: 'S RANK'),
    (asset: 'tier_bronze', number: '30', role: 'BRONZE'),
    (asset: 'tier_silver', number: '32', role: 'SILVER'),
    (asset: 'tier_gold', number: '29', role: 'GOLD'),
    (asset: 'tier_platinum', number: '27', role: 'PLATINUM'),
    (asset: 'spare_24', number: '24', role: null),
    (asset: 'spare_26', number: '26', role: null),
  ];

  @override
  State<BadgeGalleryScreen> createState() => _BadgeGalleryScreenState();
}

class _BadgeGalleryScreenState extends State<BadgeGalleryScreen> {
  /// The sizes that matter in this app: the header crest, a list icon, the
  /// medal in the case, and a level-up modal.
  static const List<({String label, double size})> _sizes = [
    (label: 'CREST 38', size: 38),
    (label: 'ROW 56', size: 56),
    (label: 'MEDAL 74', size: 74),
    (label: 'MODAL 110', size: 110),
  ];

  int _sizeIndex = 2;

  @override
  Widget build(BuildContext context) {
    final size = _sizes[_sizeIndex].size;
    const all = BadgeGalleryScreen.usable;
    final assigned = all.where((b) => b.role != null).toList();
    final spare = all.where((b) => b.role == null).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        HudSectionTitle('BADGE GALLERY', accent: AppColors.accentMagenta),
        const SizedBox(height: 10),
        Text(
          'Dev screen. Badges 21–32 only — the rest of the set was ruled out '
          'for low resolution, no contrast, or clipped artwork.',
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 16),
        HudTabBar(
          labels: [for (final s in _sizes) s.label],
          selectedIndex: _sizeIndex,
          onSelected: (i) => setState(() => _sizeIndex = i),
        ),
        const SizedBox(height: 18),
        _Group(
          title: 'Assigned',
          subtitle: 'Six rank crests, then the four medal tiers.',
          badges: assigned,
          size: size,
        ),
        const SizedBox(height: 14),
        _Group(
          title: 'Held in reserve',
          subtitle: 'Unused and available — say the word to swap either in.',
          badges: spare,
          size: size,
        ),
      ],
    );
  }
}

class _Group extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<({String asset, String number, String? role})> badges;
  final double size;

  const _Group({
    required this.title,
    required this.subtitle,
    required this.badges,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      title: title,
      glow: 0.16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(subtitle, style: AppTextStyles.body.copyWith(fontSize: 12)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 14,
            children: [
              for (final b in badges) _Cell(badge: b, size: size),
            ],
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final ({String asset, String number, String? role}) badge;
  final double size;

  const _Cell({required this.badge, required this.size});

  @override
  Widget build(BuildContext context) {
    final assigned = badge.role != null;

    return SizedBox(
      // Fixed width so switching size does not reflow the grid, and two
      // screenshots stay comparable.
      width: 112,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 118,
            child: Center(
              child: BadgeImage(asset: badge.asset, size: size),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            badge.number,
            style: AppTextStyles.counter.copyWith(
              fontSize: 13,
              color: assigned ? AppColors.accentGold : AppColors.textSecondary,
            ),
          ),
          Text(
            badge.role ?? 'SPARE',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.hudLabel.copyWith(
              fontSize: 8,
              color: assigned ? AppColors.accentGold : AppColors.textDim,
            ),
          ),
        ],
      ),
    );
  }
}
