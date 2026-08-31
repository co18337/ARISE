import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../data/memory/memory_repository.dart';
import '../data/memory/memory_seeder.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hud_entrance.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/stat_list_panel.dart';
import '../widgets/system_panel.dart';

/// MEMORY — what the System has stored, and what it can find in it.
///
/// Exists so the retrieval layer is not a black box that has to be taken on
/// faith until an LLM arrives to use it. You can fill it with sample data,
/// search it, and see the scores — which is the only honest way to know
/// whether it works before the real corpus exists.
class MemoryScreen extends StatefulWidget {
  final MemoryRepository memoryRepository;

  const MemoryScreen({super.key, required this.memoryRepository});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  final TextEditingController _query = TextEditingController(
    text: 'how have my interval runs been going',
  );

  MemoryStats _stats = MemoryStats.empty;
  List<MemoryHit> _hits = const [];
  bool _busy = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final stats = await widget.memoryRepository.stats();
    if (mounted) setState(() => _stats = stats);
  }

  Future<void> _run(Future<String> Function() action) async {
    setState(() => _busy = true);
    try {
      final message = await action();
      if (mounted) setState(() => _message = message);
    } catch (error) {
      if (mounted) setState(() => _message = 'Failed: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
      await _refresh();
    }
  }

  Future<void> _seed() => _run(() async {
    final written = await MemorySeeder(widget.memoryRepository).seed();
    return 'Seeded $written sample documents.';
  });

  Future<void> _clearSamples() => _run(() async {
    final removed = await widget.memoryRepository.clear(
      externalIdPrefix: MemorySeeder.prefix,
    );
    return 'Removed $removed sample documents.';
  });

  Future<void> _search() => _run(() async {
    final hits = await widget.memoryRepository.recall(_query.text, limit: 6);
    if (mounted) setState(() => _hits = hits);
    return hits.isEmpty
        ? 'Nothing matched. Try different words, or seed the sample corpus.'
        : 'Found ${hits.length} passages.';
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        HudSectionTitle('MEMORY', accent: AppColors.accentPurple),
        const SizedBox(height: 10),
        Text(
          'Everything the System can recall, chunked and embedded. Retrieval '
          'runs locally and needs no key; the key only changes how good the '
          'embeddings are.',
          style: AppTextStyles.body,
        ),
        const SizedBox(height: 16),
        HudEntrance(index: 0, child: _CorpusPanel(stats: _stats)),
        const SizedBox(height: 14),
        HudEntrance(index: 1, child: _SearchPanel(
          controller: _query,
          onSearch: _busy ? null : _search,
        )),
        if (_hits.isNotEmpty) ...[
          const SizedBox(height: 12),
          for (final hit in _hits) ...[
            _HitCard(hit: hit),
            const SizedBox(height: 8),
          ],
        ],
        const SizedBox(height: 10),
        HudEntrance(
          index: 2,
          child: GradientButton(
            label: 'Seed sample corpus',
            icon: Icons.auto_awesome,
            onPressed: _busy ? null : _seed,
          ),
        ),
        const SizedBox(height: 10),
        HudEntrance(
          index: 3,
          child: GradientButton(
            label: 'Clear sample data',
            icon: Icons.delete_outline,
            colors: [AppColors.danger, AppColors.accentMagenta],
            onPressed: _busy || _stats.isEmpty ? null : _clearSamples,
          ),
        ),
        if (_message != null) ...[
          const SizedBox(height: 14),
          Text(
            _message!,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.remaining),
          ),
        ],
      ],
    );
  }
}

class _CorpusPanel extends StatelessWidget {
  final MemoryStats stats;

  const _CorpusPanel({required this.stats});

  @override
  Widget build(BuildContext context) {
    return StatListPanel(
      title: 'Corpus',
      accent: AppColors.accentPurple,
      rows: [
        StatRow('Documents', '${stats.documents}'),
        StatRow('Chunks', '${stats.chunks}'),
        for (final kind in MemoryKind.values)
          if ((stats.byKind[kind] ?? 0) > 0)
            StatRow(kind.label, '${stats.byKind[kind]}'),
        StatRow('Embedder', stats.embedder),
        StatRow('Dimensions', '${stats.dimensions}'),
        if (stats.staleChunks > 0)
          StatRow(
            'Stale vectors',
            '${stats.staleChunks}',
            valueColor: AppColors.danger,
          ),
        StatRow(
          'Gemini key',
          AppConfig.hasGeminiKey ? 'present' : 'not set',
          valueColor: AppConfig.hasGeminiKey
              ? AppColors.remaining
              : AppColors.textDim,
        ),
      ],
    );
  }
}

class _SearchPanel extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSearch;

  const _SearchPanel({required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      title: 'Recall',
      glow: 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            onSubmitted: (_) => onSearch?.call(),
            decoration: InputDecoration(
              hintText: 'Ask the System something',
              hintStyle: AppTextStyles.body.copyWith(color: AppColors.textDim),
              filled: true,
              fillColor: AppColors.surfaceRaised.withValues(alpha: 0.6),
              border: OutlineInputBorder(
                borderRadius: AppRadii.controlRadius,
                borderSide: BorderSide(color: AppColors.primaryDim),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadii.controlRadius,
                borderSide: BorderSide(
                  color: AppColors.primaryDim.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GradientButton(
            label: 'Search memory',
            icon: Icons.travel_explore,
            onPressed: onSearch,
          ),
        ],
      ),
    );
  }
}

class _HitCard extends StatelessWidget {
  final MemoryHit hit;

  const _HitCard({required this.hit});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.surface.withValues(alpha: 0.55),
        shape: AppShapes.row(
          side: BorderSide(
            color: AppColors.accentPurple.withValues(alpha: 0.35),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${hit.kind.label} · ${hit.title}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.hudLabel.copyWith(
                      color: AppColors.accentPurple,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // The score is shown deliberately: a retrieval system you
                // cannot see the confidence of is one you cannot debug.
                Text(
                  hit.score.toStringAsFixed(2),
                  style: AppTextStyles.counter.copyWith(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              hit.passage,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
