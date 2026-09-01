import 'package:flutter/material.dart';

import '../ai/ai_log_repository.dart';
import '../data/db/database.dart' show AiCallRow;
import '../config/app_config.dart';
import '../data/memory/memory_repository.dart';
import '../data/memory/memory_seeder.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hud_entrance.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/hud_tab_bar.dart';
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

  /// The call log. Shown on its own tab here rather than as another
  /// destination on the hub: the corpus and the model are two halves of the
  /// same thing, and the radial menu is already crowded.
  final AiLogRepository aiLogRepository;

  const MemoryScreen({
    super.key,
    required this.memoryRepository,
    required this.aiLogRepository,
  });

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  final TextEditingController _query = TextEditingController(
    text: 'how have my interval runs been going',
  );

  int _tab = 0;
  MemoryStats _stats = MemoryStats.empty;
  AiSummary _ai = AiSummary.empty;
  List<AiCallRow> _recentCalls = const [];
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
    final ai = await widget.aiLogRepository.summary();
    final calls = await widget.aiLogRepository.recent();
    if (mounted) {
      setState(() {
        _stats = stats;
        _ai = ai;
        _recentCalls = calls;
      });
    }
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

  /// Converts the corpus to the current embedder.
  ///
  /// Explicit, never automatic. Vectors from two embedders are not comparable,
  /// so a switch means re-embedding every chunk — a few hundred API calls that
  /// nobody should spend on your behalf just because the app started.
  Future<void> _reembed() => _run(() async {
    final converted = await widget.memoryRepository.reembedAll();
    return converted == 0
        ? 'Already up to date — nothing to convert.'
        : 'Converted $converted chunks. Recall now matches on meaning rather '
              'than on shared words.';
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
        HudTabBar(
          labels: const ['CORPUS', 'THE MODEL'],
          selectedIndex: _tab,
          onSelected: (i) => setState(() => _tab = i),
        ),
        const SizedBox(height: 18),
        if (_tab == 1) ...[
          _AiPanel(summary: _ai, calls: _recentCalls),
          const SizedBox(height: 12),
          GradientButton(
            label: 'Forget cached answers',
            icon: Icons.refresh,
            colors: [AppColors.accentGold, AppColors.accentMagenta],
            onPressed: _busy || _ai.cachedAnswers == 0
                ? null
                : () => _run(() async {
                    final removed = await widget.aiLogRepository.clearCache();
                    return 'Forgot $removed remembered answers.';
                  }),
          ),
          if (_message != null) ...[
            const SizedBox(height: 14),
            Text(
              _message!,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.remaining),
            ),
          ],
        ] else ...[
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
        if (_stats.staleChunks > 0) ...[
          const SizedBox(height: 10),
          HudEntrance(
            index: 3,
            child: GradientButton(
              label: 'Convert ${_stats.staleChunks} chunks',
              icon: Icons.upgrade,
              colors: [AppColors.accentGold, AppColors.primary],
              onPressed: _busy ? null : _reembed,
            ),
          ),
        ],
        const SizedBox(height: 10),
        HudEntrance(
          index: 4,
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
      ],
    );
  }
}

/// Whether the model is reachable, what it has been asked, and what broke.
class _AiPanel extends StatelessWidget {
  final AiSummary summary;
  final List<AiCallRow> calls;

  const _AiPanel({required this.summary, required this.calls});

  @override
  Widget build(BuildContext context) {
    final hasKey = AppConfig.hasGeminiKey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatListPanel(
          title: 'The model',
          accent: hasKey ? AppColors.remaining : AppColors.textDim,
          rows: [
            StatRow(
              'API key',
              hasKey ? 'present' : 'not set',
              valueColor: hasKey ? AppColors.remaining : AppColors.textDim,
            ),
            StatRow('Model', AppConfig.geminiModel),
            StatRow('Calls today', '${summary.callsToday}'),
            StatRow(
              'Failures today',
              '${summary.failuresToday}',
              valueColor:
                  summary.failuresToday > 0 ? AppColors.danger : null,
            ),
            StatRow('Served from memory', '${summary.cacheHitsToday}'),
            StatRow('Answers remembered', '${summary.cachedAnswers}'),
            if (summary.averageMs > 0)
              StatRow('Average reply', '${summary.averageMs} ms'),
          ],
        ),
        if (!hasKey) ...[
          const SizedBox(height: 12),
          SystemPanel(
            glow: 0.16,
            child: Text(
              'Everything works without a key — food is logged and the figures '
              'are typed by hand, and the trainer falls back to its own rules. '
              'Add a key to assets/config/.env and restart to turn estimation '
              'on.',
              style: AppTextStyles.body.copyWith(fontSize: 12),
            ),
          ),
        ],
        if (summary.lastError != null) ...[
          const SizedBox(height: 12),
          SystemPanel(
            title: 'Last error',
            accent: AppColors.danger,
            glow: 0.2,
            child: Text(
              summary.lastError!,
              style: AppTextStyles.body.copyWith(fontSize: 11),
            ),
          ),
        ],
        if (calls.isNotEmpty) ...[
          const SizedBox(height: 12),
          SystemPanel(
            title: 'Recent calls',
            glow: 0.16,
            child: Column(
              children: [
                for (final call in calls)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Icon(
                          call.ok ? Icons.check : Icons.close,
                          size: 13,
                          color: call.ok
                              ? AppColors.remaining
                              : AppColors.danger,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            call.cached ? '${call.lane} (remembered)' : call.lane,
                            style: AppTextStyles.body.copyWith(fontSize: 12),
                          ),
                        ),
                        Text(
                          call.cached ? '—' : '${call.durationMs} ms',
                          style: AppTextStyles.counter.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
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
        if (stats.staleChunks > 0)
          StatRow(
            'Not yet converted',
            '${stats.staleChunks}',
            valueColor: AppColors.accentGold,
          ),
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
