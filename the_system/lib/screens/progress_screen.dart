import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/repositories/health_repository.dart';
import '../data/repositories/progress_repository.dart';
import '../game/game.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/hud_charts.dart';
import '../widgets/hud_entrance.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/hud_tab_bar.dart';
import '../widgets/stat_list_panel.dart';
import '../widgets/system_panel.dart';
import 'blood_work_screen.dart';
import 'day_rollover.dart';

/// PROGRESS — what has actually changed, charted.
///
/// Two different clocks share this screen and it matters that they are drawn
/// differently. Body composition moves on a scale of MONTHS: two points a
/// season apart, and the honest picture is a line between them. Adherence
/// moves DAILY, and the honest picture is thirty bars where the gaps are as
/// informative as the heights.
///
/// So the range filter applies to the daily charts and deliberately NOT to the
/// scans. Filtering two readings taken in August and February down to "last 7
/// days" would empty the one chart that matters most.
class ProgressScreen extends StatefulWidget {
  final ProgressRepository progressRepository;

  /// Health Connect. Optional in the sense that everything on this screen
  /// works without it — the body scans, the XP bars and the blood work are all
  /// entered or earned by hand.
  final HealthRepository healthRepository;

  const ProgressScreen({
    super.key,
    required this.progressRepository,
    required this.healthRepository,
  });

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with WidgetsBindingObserver, DayRollover<ProgressScreen> {
  // Default to a month: a week is noise, a quarter is a smear.
  ChartRange _range = ChartRange.month;

  late DateTime _today;
  late Stream<ProgressView> _stream;

  @override
  Clock get rolloverClock => widget.progressRepository.clock;

  @override
  DateTime get shownDay => _today;

  @override
  void openDay() {
    _today = widget.progressRepository.clock.now();
    _stream = widget.progressRepository.watch(_range);
  }

  bool _syncing = false;
  String? _syncMessage;

  Future<void> _sync() async {
    setState(() {
      _syncing = true;
      _syncMessage = null;
    });
    try {
      var status = await widget.healthRepository.status();
      if (!status.authorised) {
        status = await widget.healthRepository.requestPermissions();
      }
      if (!status.canSync) {
        if (mounted) setState(() => _syncMessage = status.summary);
        return;
      }
      final outcome = await widget.healthRepository.sync();
      if (!mounted) return;
      setState(() {
        _syncMessage =
            outcome.error ??
            (outcome.didSomething
                ? '${outcome.daysStored} days read'
                      '${outcome.questsVerified.isEmpty ? '' : ' · cleared '
                          '${outcome.questsVerified.join(', ')}'}'
                : 'Nothing new to read.');
        // The range query is built once when the stream is opened, so a new
        // sync needs a new stream rather than waiting for a table event.
        _stream = widget.progressRepository.watch(_range);
      });
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  void _setRange(ChartRange range) {
    setState(() {
      _range = range;
      _stream = widget.progressRepository.watch(range);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProgressView>(
      stream: _stream,
      builder: (context, snapshot) {
        final view = snapshot.data;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            HudSectionTitle('PROGRESS'),
            const SizedBox(height: 18),
            if (view == null)
              _Notice('READING THE RECORD…')
            else ...[
              ..._composition(view),
              const SizedBox(height: 18),
              _rangeBar(),
              const SizedBox(height: 14),
              ..._momentum(view),
              ..._health(view),
              ..._bloodWorkLink(view),
            ],
          ],
        );
      },
    );
  }

  Widget _rangeBar() => HudTabBar(
    labels: [for (final r in ChartRange.values) r.label],
    selectedIndex: ChartRange.values.indexOf(_range),
    onSelected: (i) => _setRange(ChartRange.values[i]),
  );

  // --- Body composition -----------------------------------------------------

  List<Widget> _composition(ProgressView view) {
    final baseline = view.baseline;
    final latest = view.latest;
    if (baseline == null || latest == null) {
      return [
        SystemPanel(
          title: 'BODY COMPOSITION',
          child: _Empty('No scan on record yet.'),
        ),
      ];
    }

    return [
      HudEntrance(
        index: 0,
        child: SystemPanel(
          title: 'BODY COMPOSITION',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ScanHeader(scan: latest, baseline: baseline),
              const SizedBox(height: 16),
              if (view.hasTrend) ..._trendCharts(view)
              else
                // One reading is not a trend, and drawing a single dot on an
                // axis pretends otherwise. Say what is missing instead.
                _Empty(
                  'The line starts at your next scan. One reading is a '
                  'measurement; two are a direction.',
                ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 14),
      HudEntrance(
        index: 1,
        child: StatListPanel(
          title: 'THE READING',
          rows: [
            StatRow('Taken', _longDate(latest.date)),
            if (latest.source.isNotEmpty) StatRow('Source', latest.source),
            if (latest.heightCm != null)
              StatRow('Height', '${_trim(latest.heightCm!)} cm'),
            StatRow('Weight', '${_trim(latest.weightKg)} kg'),
            if (latest.bmi != null) StatRow('BMI', _trim(latest.bmi!)),
            if (latest.bodyFatPercent != null)
              StatRow('Body fat', '${_trim(latest.bodyFatPercent!)} %'),
            if (latest.fatMassKg != null)
              StatRow('Fat mass', '${_trim(latest.fatMassKg!)} kg'),
            if (latest.fatFreeMassKg != null)
              StatRow('Fat-free mass', '${_trim(latest.fatFreeMassKg!)} kg'),
            if (latest.muscleMassKg != null)
              StatRow('Muscle mass', '${_trim(latest.muscleMassKg!)} kg'),
            if (latest.skeletalMuscleKg != null)
              StatRow(
                'Skeletal muscle',
                '${_trim(latest.skeletalMuscleKg!)} kg'
                '${latest.skeletalMusclePercent == null ? '' : ' · '
                    '${_trim(latest.skeletalMusclePercent!)} %'}',
              ),
            if (latest.boneMassKg != null)
              StatRow('Bone mass', '${_trim(latest.boneMassKg!)} kg'),
            if (latest.proteinKg != null)
              StatRow('Protein', '${_trim(latest.proteinKg!)} kg'),
            if (latest.visceralFat != null)
              StatRow('Visceral fat rating', '${latest.visceralFat}'),
            if (latest.sarcopenicIndex != null)
              StatRow(
                'Sarcopenic index',
                '${_trim(latest.sarcopenicIndex!)} kg/m²',
              ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      HudEntrance(
        index: 2,
        child: StatListPanel(
          title: 'METABOLISM',
          rows: [
            // Body water is deliberately NOT here. The Tanita prints TBW, ECW,
            // ICW and the ratio between them, and none of it tells you
            // anything you can act on: hydration swings with what you drank
            // this morning, so it moves more between two readings than the fat
            // it is meant to inform. It is still STORED — the report is the
            // record — it is simply not shown.
            if (latest.bmrKcal != null)
              StatRow(
                'BMR',
                '${latest.bmrKcal} kcal'
                '${latest.bmrKj == null ? '' : ' · ${latest.bmrKj} kJ'}',
              ),
            if (latest.metabolicAge != null)
              StatRow('Metabolic age', '${latest.metabolicAge}'),
            if (latest.phaseAngleDeg != null)
              StatRow('Phase angle', '${_trim(latest.phaseAngleDeg!)}°'),
          ],
        ),
      ),
      if (latest.hasSegments) ...[
        const SizedBox(height: 10),
        HudEntrance(index: 3, child: _SegmentPanel(scan: latest)),
      ],
      if (latest.note != null && latest.note!.isNotEmpty) ...[
        const SizedBox(height: 10),
        _Footnote(latest.note!),
      ],
      const SizedBox(height: 10),
      // The boundary from CLAUDE.md, on screen rather than only in a comment.
      _Footnote(
        'The System charts these figures. It does not interpret them — that '
        'reading belongs to your doctor.',
      ),
    ];
  }

  /// One small chart per figure, rather than three series crammed onto one
  /// axis.
  ///
  /// Weight in kilograms and body fat in percent do not share a scale — plotted
  /// together, a 6 kg loss and a 7-point drop in body fat end up as two lines
  /// that cannot both be read. Separate charts also mean every figure the
  /// Tanita prints can be trended, not just the three that happened to fit.
  List<Widget> _trendCharts(ProgressView view) {
    final metrics = <(String, String, Color, double? Function(BodyScan))>[
      ('WEIGHT', ' kg', AppColors.primary, (s) => s.weightKg),
      ('BODY FAT', ' %', AppColors.accentMagenta, (s) => s.bodyFatPercent),
      ('FAT MASS', ' kg', AppColors.accentMagenta, (s) => s.fatMassKg),
      ('MUSCLE MASS', ' kg', AppColors.statStr, (s) => s.muscleMassKg),
      ('SKELETAL MUSCLE', ' kg', AppColors.statStr, (s) => s.skeletalMuscleKg),
      (
        'VISCERAL FAT',
        '',
        AppColors.accentGold,
        (s) => s.visceralFat?.toDouble(),
      ),
      ('BMI', '', AppColors.textSecondary, (s) => s.bmi),
      (
        'METABOLIC AGE',
        '',
        AppColors.textSecondary,
        (s) => s.metabolicAge?.toDouble(),
      ),
      (
        'BMR',
        ' kcal',
        AppColors.statRec,
        (s) => s.bmrKcal?.toDouble(),
      ),
    ];

    final labels = [for (final s in view.scans) _shortDate(s.date)];
    final charts = <Widget>[];

    for (final (label, unit, colour, pick) in metrics) {
      final spots = [
        for (final (i, scan) in view.scans.indexed)
          if (pick(scan) != null) FlSpot(i.toDouble(), pick(scan)!),
      ];
      // Two readings or it is not a trend.
      if (spots.length < 2) continue;

      charts.addAll([
        Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 2),
          child: Text(
            label,
            style: AppTextStyles.hudLabel.copyWith(
              fontSize: 10,
              color: AppColors.textDim,
            ),
          ),
        ),
        HudLineChart(
          height: 130,
          xLabels: labels,
          series: [
            ChartSeries(
              label: label,
              color: colour,
              unit: unit,
              spots: spots,
            ),
          ],
        ),
      ]);
    }

    return charts;
  }

  // --- Daily momentum -------------------------------------------------------

  List<Widget> _momentum(ProgressView view) {
    if (!view.hasDays) {
      return [
        SystemPanel(
          title: 'MOMENTUM',
          child: _Empty(
            'Nothing recorded in this window. Answer a day and it appears '
            'here.',
          ),
        ),
      ];
    }

    return [
      HudEntrance(
        index: 2,
        child: SystemPanel(
          title: 'XP EARNED',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HudBarChart(
                unit: ' XP',
                bars: [
                  for (final d in view.days)
                    ChartBar(
                      label: _shortDate(d.date),
                      value: d.xpEarned.toDouble(),
                      // Gold for a perfect day. The palette already means that
                      // everywhere else in the app; a chart is no place to
                      // start meaning something different.
                      color: d.isPerfect
                          ? AppColors.accentGold
                          : AppColors.accentPurple,
                    ),
                ],
              ),
              const SizedBox(height: 6),
              _Footnote(
                'Only days the app recorded. A gap is a day with no record, '
                'not a day of zero.',
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 14),
      HudEntrance(
        index: 3,
        child: StatListPanel(
          title: 'IN THIS WINDOW',
          rows: [
            StatRow('Days recorded', '${view.days.length}'),
            StatRow('XP earned', '${view.xpInRange}'),
            StatRow(
              'Quests cleared',
              '${view.clearedInRange}',
              valueColor: AppColors.primary,
            ),
            StatRow(
              'Quests missed',
              '${view.missedInRange}',
              valueColor: view.missedInRange > 0 ? AppColors.danger : null,
            ),
            StatRow(
              'Perfect days',
              '${view.perfectInRange}',
              valueColor: AppColors.accentGold,
            ),
            StatRow(
              'Adherence',
              '${(view.adherenceInRange * 100).round()} %',
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      HudEntrance(
        index: 4,
        child: SystemPanel(
          title: 'WHERE THE XP WENT',
          child: Builder(
            builder: (context) {
              final byStat = view.xpByStat;
              final total = byStat.values.fold(0, (a, b) => a + b);
              if (total == 0) {
                return _Empty('No XP in this window yet.');
              }
              return HudDonut(
                slices: [
                  for (final entry in byStat.entries)
                    ChartSlice(
                      label: entry.key.label,
                      value: entry.value.toDouble(),
                      color: _statColour(entry.key),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    ];
  }

  // --- Daily health, from Health Connect ------------------------------------

  List<Widget> _health(ProgressView view) {
    if (!view.hasHealth) {
      return [
        const SizedBox(height: 18),
        HudSectionTitle('DAILY HEALTH'),
        const SizedBox(height: 14),
        SystemPanel(
          title: 'NOTHING SYNCED',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Empty(
                'Steps, sleep and resting heart rate appear here once Health '
                'Connect is linked. Nothing in the routine depends on it — '
                'every quest can still be answered by hand.',
              ),
              const SizedBox(height: 10),
              _SyncButton(busy: _syncing, onPressed: _sync),
              if (_syncMessage != null) ...[
                const SizedBox(height: 8),
                _Footnote(_syncMessage!),
              ],
            ],
          ),
        ),
      ];
    }

    return [
      const SizedBox(height: 18),
      HudSectionTitle('DAILY HEALTH'),
      const SizedBox(height: 14),
      _SyncButton(busy: _syncing, onPressed: _sync),
      if (_syncMessage != null) ...[
        const SizedBox(height: 8),
        _Footnote(_syncMessage!),
      ],
      const SizedBox(height: 12),
      HudEntrance(
        index: 5,
        child: StatListPanel(
          title: 'IN THIS WINDOW',
          rows: [
            StatRow('Days with data', '${view.health.length}'),
            StatRow('Steps a day', '${view.averageSteps}'),
            StatRow('Steps total', '${view.totalSteps}'),
            if (view.totalDistanceKm > 0)
              StatRow(
                'Distance',
                '${view.totalDistanceKm.toStringAsFixed(1)} km',
              ),
            if (view.averageSleepLabel != null)
              StatRow('Sleep a night', view.averageSleepLabel!),
            if (view.averageRestingHeartRate != null)
              StatRow(
                'Resting heart rate',
                '${view.averageRestingHeartRate} bpm',
              ),
          ],
        ),
      ),
      if (view.stepDays.isNotEmpty) ...[
        const SizedBox(height: 12),
        HudEntrance(
          index: 6,
          child: SystemPanel(
            title: 'STEPS',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HudBarChart(
                  bars: [
                    for (final d in view.stepDays)
                      ChartBar(
                        label: _shortDate(d.date),
                        value: d.steps!.toDouble(),
                        color: AppColors.statSta,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                _Footnote(
                  'Only days the phone reported. A day it was left at home is '
                  'a gap, not a day of no steps.',
                ),
              ],
            ),
          ),
        ),
      ],
      if (view.heartDays.length >= 2) ...[
        const SizedBox(height: 12),
        HudEntrance(
          index: 7,
          child: SystemPanel(
            title: 'RESTING HEART RATE',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HudLineChart(
                  xLabels: [for (final d in view.heartDays) _shortDate(d.date)],
                  series: [
                    ChartSeries(
                      label: 'RESTING',
                      color: AppColors.danger,
                      unit: ' bpm',
                      spots: [
                        for (final (i, d) in view.heartDays.indexed)
                          FlSpot(i.toDouble(), d.restingHeartRate!.toDouble()),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // The boundary again, in the one place it is most tempting to
                // cross. A resting heart rate is a number this app draws.
                _Footnote(
                  'Charted, not interpreted. What a resting heart rate means '
                  'for you is a conversation with your doctor.',
                ),
              ],
            ),
          ),
        ),
      ],
      if (view.sleepDays.length >= 2) ...[
        const SizedBox(height: 12),
        HudEntrance(
          index: 8,
          child: SystemPanel(
            title: 'SLEEP',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HudBarChart(
                  unit: ' min',
                  bars: [
                    for (final d in view.sleepDays)
                      ChartBar(
                        label: _shortDate(d.date),
                        value: d.sleepMinutes!.toDouble(),
                        // Gold past seven hours — the plan's own target, and
                        // the thing it calls the hardest part of the whole
                        // transformation.
                        color: d.sleepMinutes! >= 420
                            ? AppColors.accentGold
                            : AppColors.accentPurple,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                _Footnote(
                  'Gold is seven hours or more. The plan calls sleep the '
                  'hardest part of all of this, and the lever for the rest.',
                ),
              ],
            ),
          ),
        ),
      ],
    ];
  }

  // --- Blood work lives elsewhere -------------------------------------------

  /// A link, not a section.
  ///
  /// The panel used to be on this screen and it did not belong: PROGRESS
  /// answers "is my body changing?", and liver enzymes do not answer that.
  /// It is a record that matters at the next test, not a training signal, and
  /// putting it here invited reading it as one.
  List<Widget> _bloodWorkLink(ProgressView view) {
    if (view.labs.isEmpty) return const [];
    final flagged = view.flaggedLabs.length;

    return [
      const SizedBox(height: 18),
      InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BloodWorkScreen(view: view),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        child: SystemPanel(
          glow: 0.14,
          child: Row(
            children: [
              Icon(Icons.science_outlined, size: 18, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BLOOD WORK', style: AppTextStyles.panelTitle),
                    const SizedBox(height: 3),
                    Text(
                      '${view.labs.length} results'
                      '${flagged == 0 ? '' : ' · $flagged outside range'}',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textDim,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  static Color _statColour(StatType stat) => switch (stat) {
    StatType.str => AppColors.statStr,
    StatType.sta => AppColors.statSta,
    StatType.dis => AppColors.statDis,
    StatType.rec => AppColors.statRec,
  };

  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  static String _shortDate(DateTime d) => '${d.day}/${d.month}';

  static const List<String> _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];

  static String _longDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';
}

/// The headline comparison: where you started, where you are, what moved.
class _ScanHeader extends StatelessWidget {
  final BodyScan scan;
  final BodyScan baseline;

  const _ScanHeader({required this.scan, required this.baseline});

  @override
  Widget build(BuildContext context) {
    final same = scan.date == baseline.date;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _Figure(
                label: 'WEIGHT',
                value: '${_ProgressScreenState._trim(scan.weightKg)} kg',
                delta: same ? null : scan.weightKg - baseline.weightKg,
                unit: 'kg',
                // Down is progress here, which is NOT true of every figure on
                // this screen — muscle going down is not an improvement. So
                // the direction that counts as good is declared per figure
                // rather than assumed from the sign.
                lowerIsBetter: true,
              ),
            ),
            if (scan.bodyFatPercent != null)
              Expanded(
                child: _Figure(
                  label: 'BODY FAT',
                  value:
                      '${_ProgressScreenState._trim(scan.bodyFatPercent!)} %',
                  delta: same || baseline.bodyFatPercent == null
                      ? null
                      : scan.bodyFatPercent! - baseline.bodyFatPercent!,
                  unit: '%',
                  lowerIsBetter: true,
                ),
              ),
            if (scan.muscleMassKg != null)
              Expanded(
                child: _Figure(
                  label: 'MUSCLE',
                  value: '${_ProgressScreenState._trim(scan.muscleMassKg!)} kg',
                  delta: same || baseline.muscleMassKg == null
                      ? null
                      : scan.muscleMassKg! - baseline.muscleMassKg!,
                  unit: 'kg',
                  lowerIsBetter: false,
                ),
              ),
          ],
        ),
        if (!same) ...[
          const SizedBox(height: 8),
          Text(
            'AGAINST THE BASELINE OF '
            '${_ProgressScreenState._longDate(baseline.date)}',
            style: AppTextStyles.hudLabel.copyWith(
              fontSize: 9,
              color: AppColors.textDim,
            ),
          ),
        ],
      ],
    );
  }
}

class _Figure extends StatelessWidget {
  final String label;
  final String value;
  final double? delta;
  final String unit;
  final bool lowerIsBetter;

  const _Figure({
    required this.label,
    required this.value,
    required this.delta,
    required this.unit,
    required this.lowerIsBetter,
  });

  @override
  Widget build(BuildContext context) {
    final d = delta;
    final improved = d == null ? null : (lowerIsBetter ? d < 0 : d > 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.hudLabel.copyWith(
            fontSize: 9,
            color: AppColors.textDim,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, style: AppTextStyles.readout),
        ),
        if (d != null && d.abs() >= 0.05) ...[
          const SizedBox(height: 2),
          Text(
            '${d > 0 ? '+' : ''}${d.toStringAsFixed(1)} $unit',
            style: AppTextStyles.hudLabel.copyWith(
              fontSize: 10,
              color: improved == true ? AppColors.primary : AppColors.danger,
            ),
          ),
        ],
      ],
    );
  }
}

/// The five segments, side by side.
///
/// A table rather than the report's radar chart. A pentagon with five labels
/// is unreadable at 360dp, and the question it answers — where is the fat, is
/// anything lopsided — is answered better by numbers in a column.
class _SegmentPanel extends StatelessWidget {
  final BodyScan scan;

  const _SegmentPanel({required this.scan});

  @override
  Widget build(BuildContext context) {
    return SystemPanel(
      title: 'BY SEGMENT',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(flex: 3, child: _Head('')),
              const Expanded(flex: 3, child: _Head('FAT')),
              const Expanded(flex: 3, child: _Head('MUSCLE')),
            ],
          ),
          const SizedBox(height: 6),
          for (final seg in scan.segments)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      seg.segment.label,
                      style: AppTextStyles.hudLabel.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      seg.fatKg == null
                          ? '—'
                          : '${_ProgressScreenState._trim(seg.fatKg!)} kg'
                                '${seg.fatPercent == null ? '' : '  '
                                    '${_ProgressScreenState._trim(seg.fatPercent!)}%'}',
                      style: AppTextStyles.readout.copyWith(
                        fontSize: 11,
                        color: AppColors.accentMagenta,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      seg.muscleKg == null
                          ? '—'
                          : '${_ProgressScreenState._trim(seg.muscleKg!)} kg',
                      style: AppTextStyles.readout.copyWith(
                        fontSize: 11,
                        color: AppColors.statStr,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          _Footnote(
            'Segment ratings on the report run -4 to +4 against its reference '
            'population. They are stored as printed; what they mean is not '
            'the System\'s to say.',
          ),
        ],
      ),
    );
  }
}

class _Head extends StatelessWidget {
  final String text;

  const _Head(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppTextStyles.hudLabel.copyWith(
      fontSize: 9,
      color: AppColors.textDim,
    ),
  );
}

/// Pulls from Health Connect on demand.
///
/// On demand rather than in the background: a background sync needs a
/// foreground service and a permanent notification, which is a lot of
/// machinery for data nobody looks at more than once a day.
class _SyncButton extends StatelessWidget {
  final bool busy;
  final VoidCallback onPressed;

  const _SyncButton({required this.busy, required this.onPressed});

  @override
  Widget build(BuildContext context) => GradientButton(
    label: busy ? 'Reading…' : 'Sync Health Connect',
    icon: busy ? null : Icons.sync,
    onPressed: busy ? null : onPressed,
  );
}

class _Empty extends StatelessWidget {
  final String text;

  const _Empty(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      text,
      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
    ),
  );
}

class _Footnote extends StatelessWidget {
  final String text;

  const _Footnote(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppTextStyles.body.copyWith(
      fontSize: 11,
      color: AppColors.textDim,
      height: 1.4,
    ),
  );
}

class _Notice extends StatelessWidget {
  final String text;

  const _Notice(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 40),
    child: Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.hudLabel.copyWith(color: AppColors.textSecondary),
      ),
    ),
  );
}
