import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/repositories/progress_repository.dart';
import '../game/game.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/hud_charts.dart';
import '../widgets/hud_entrance.dart';
import '../widgets/hud_section_title.dart';
import '../widgets/hud_tab_bar.dart';
import '../widgets/stat_list_panel.dart';
import '../widgets/system_panel.dart';
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

  const ProgressScreen({super.key, required this.progressRepository});

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
              ..._labs(view),
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
              if (view.hasTrend)
                HudLineChart(
                  xLabels: [for (final s in view.scans) _shortDate(s.date)],
                  series: _bodySeries(view),
                )
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
          title: 'WATER & METABOLISM',
          rows: [
            if (latest.totalBodyWaterKg != null)
              StatRow(
                'Total body water',
                '${_trim(latest.totalBodyWaterKg!)} kg'
                '${latest.totalBodyWaterPercent == null ? '' : ' · '
                    '${_trim(latest.totalBodyWaterPercent!)} %'}',
              ),
            if (latest.extracellularWaterKg != null)
              StatRow('Extracellular', '${_trim(latest.extracellularWaterKg!)} kg'),
            if (latest.intracellularWaterKg != null)
              StatRow('Intracellular', '${_trim(latest.intracellularWaterKg!)} kg'),
            if (latest.ecwOverTbwPercent != null)
              StatRow('ECW / TBW', '${_trim(latest.ecwOverTbwPercent!)} %'),
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
            if (latest.impedanceOhm != null)
              StatRow('Impedance', '${latest.impedanceOhm} Ω'),
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

  List<ChartSeries> _bodySeries(ProgressView view) {
    List<FlSpot> spots(double? Function(BodyScan) pick) => [
      for (final (i, scan) in view.scans.indexed)
        if (pick(scan) != null) FlSpot(i.toDouble(), pick(scan)!),
    ];

    return [
      ChartSeries(
        label: 'WEIGHT',
        color: AppColors.primary,
        unit: ' kg',
        spots: spots((s) => s.weightKg),
      ),
      ChartSeries(
        label: 'MUSCLE',
        color: AppColors.statStr,
        unit: ' kg',
        spots: spots((s) => s.muscleMassKg),
      ),
      ChartSeries(
        label: 'FAT',
        color: AppColors.accentMagenta,
        unit: ' %',
        spots: spots((s) => s.bodyFatPercent),
      ),
    ];
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

  // --- Blood work ------------------------------------------------------------

  List<Widget> _labs(ProgressView view) {
    if (view.labs.isEmpty) return const [];
    final flagged = view.flaggedLabs;

    return [
      const SizedBox(height: 18),
      HudSectionTitle('BLOOD WORK'),
      const SizedBox(height: 14),
      if (flagged.isNotEmpty) ...[
        SystemPanel(
          title: 'OUTSIDE THE REFERENCE RANGE',
          accent: AppColors.accentGold,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final lab in flagged) _LabRow(lab: lab),
              const SizedBox(height: 8),
              // The report's own flags, reproduced. Not a finding of the app's.
              _Footnote(
                'Flagged on the report itself, not by this app. What any of '
                'it means is a conversation with your doctor.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
      for (final entry in view.labsByPanel.entries) ...[
        SystemPanel(
          title: entry.key,
          glow: 0.14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [for (final lab in entry.value) _LabRow(lab: lab)],
          ),
        ),
        const SizedBox(height: 10),
      ],
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

/// One line of a lab report: name, value, and the range it was measured
/// against. The range travels with the value because it differs by lab and
/// method, and a number without it says nothing.
class _LabRow extends StatelessWidget {
  final LabResult lab;

  const _LabRow({required this.lab});

  @override
  Widget build(BuildContext context) {
    final flagged = lab.isFlagged;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              lab.name,
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  lab.reading,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.readout.copyWith(
                    fontSize: 12,
                    color: flagged
                        ? AppColors.accentGold
                        : AppColors.textPrimary,
                  ),
                ),
                if (lab.refText.isNotEmpty)
                  Text(
                    lab.refText,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.hudLabel.copyWith(
                      fontSize: 9,
                      color: AppColors.textDim,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
