import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Charts dressed as System readouts.
///
/// fl_chart's defaults are a light Material chart — grey gridlines, rounded
/// blue bars, a white tooltip. None of that belongs here, and restyling it at
/// every call site would guarantee three screens that disagree. So the styling
/// lives once, in this file, and the screens pass data.
///
/// One rule throughout: NO synthesised points. A day the app was never opened
/// has no rollup, and drawing a zero there would read as a day of total failure
/// rather than a day with no record. Gaps stay gaps.

/// A labelled series for [HudLineChart].
class ChartSeries {
  final String label;
  final Color color;

  /// x is a position on the shared axis, y the value. Ordered by x.
  final List<FlSpot> spots;

  /// Appended to the value in the tooltip: 'kg', '%', ' XP'.
  final String unit;

  const ChartSeries({
    required this.label,
    required this.color,
    required this.spots,
    this.unit = '',
  });
}

/// A trend line. Used for body composition, where the x axis is time and the
/// gap between points is months rather than days.
class HudLineChart extends StatelessWidget {
  final List<ChartSeries> series;

  /// Drawn under the x axis, one per spot index.
  final List<String> xLabels;

  final double height;

  const HudLineChart({
    super.key,
    required this.series,
    required this.xLabels,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    final grid = AppColors.grid;
    final visible = series.where((s) => s.spots.isNotEmpty).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    // A flat series (every reading identical) gives a zero-height range, which
    // fl_chart renders as a line jammed against the top edge. Padding the
    // window keeps it centred.
    final values = [
      for (final s in visible)
        for (final spot in s.spots) spot.y,
    ];
    var minY = values.reduce((a, b) => a < b ? a : b);
    var maxY = values.reduce((a, b) => a > b ? a : b);
    final pad = (maxY - minY).abs() < 0.01 ? 1.0 : (maxY - minY) * 0.15;
    minY -= pad;
    maxY += pad;

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: grid, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(0),
                  style: AppTextStyles.hudLabel.copyWith(
                    fontSize: 9,
                    color: AppColors.textDim,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                getTitlesWidget: (value, meta) {
                  final i = value.round();
                  if (i < 0 || i >= xLabels.length) {
                    return const SizedBox.shrink();
                  }
                  // Every label on a two-point chart; thinned out beyond that,
                  // because overlapping dates are worse than fewer dates.
                  final step = (xLabels.length / 4).ceil();
                  if (xLabels.length > 5 && i % step != 0) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      xLabels[i],
                      style: AppTextStyles.hudLabel.copyWith(
                        fontSize: 9,
                        color: AppColors.textDim,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.surfaceRaised,
              tooltipBorder: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
              getTooltipItems: (touched) => [
                for (final t in touched)
                  LineTooltipItem(
                    '${visible[t.barIndex].label}  '
                    '${_trim(t.y)}${visible[t.barIndex].unit}',
                    AppTextStyles.hudLabel.copyWith(
                      fontSize: 11,
                      color: visible[t.barIndex].color,
                    ),
                  ),
              ],
            ),
          ),
          lineBarsData: [
            for (final s in visible)
              LineChartBarData(
                spots: s.spots,
                color: s.color,
                barWidth: 2,
                isCurved: s.spots.length > 2,
                curveSmoothness: 0.2,
                // Overshoot on a curve through body-weight readings would
                // draw a dip that never happened.
                preventCurveOverShooting: true,
                dotData: FlDotData(
                  getDotPainter: (spot, _, _, _) => FlDotCirclePainter(
                    radius: 3,
                    color: s.color,
                    strokeColor: AppColors.background,
                    strokeWidth: 1.5,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      s.color.withValues(alpha: 0.22),
                      s.color.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}

/// One bar on [HudBarChart].
class ChartBar {
  final String label;
  final double value;

  /// Bars can differ in meaning as well as height — a perfect day is gold.
  final Color color;

  const ChartBar({
    required this.label,
    required this.value,
    required this.color,
  });
}

/// A day-by-day bar chart. Used for XP earned, where every bar is one day and
/// the shape of the month is the point.
class HudBarChart extends StatelessWidget {
  final List<ChartBar> bars;
  final double height;
  final String unit;

  const HudBarChart({
    super.key,
    required this.bars,
    this.height = 150,
    this.unit = '',
  });

  @override
  Widget build(BuildContext context) {
    if (bars.isEmpty) return const SizedBox.shrink();
    final maxValue = bars.map((b) => b.value).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          maxY: maxValue <= 0 ? 1 : maxValue * 1.2,
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: AppColors.grid, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 34,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(0),
                  style: AppTextStyles.hudLabel.copyWith(
                    fontSize: 9,
                    color: AppColors.textDim,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final i = value.round();
                  if (i < 0 || i >= bars.length) {
                    return const SizedBox.shrink();
                  }
                  // A month of daily bars cannot carry 30 labels on a 360dp
                  // phone; roughly six is what fits without overlapping.
                  final step = (bars.length / 6).ceil();
                  if (bars.length > 7 && i % step != 0) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      bars[i].label,
                      style: AppTextStyles.hudLabel.copyWith(
                        fontSize: 9,
                        color: AppColors.textDim,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => AppColors.surfaceRaised,
              tooltipBorder: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
              getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                '${bars[group.x].label}\n'
                '${rod.toY.toStringAsFixed(0)}$unit',
                AppTextStyles.hudLabel.copyWith(
                  fontSize: 11,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < bars.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: bars[i].value,
                    color: bars[i].color,
                    width: bars.length > 20 ? 5 : 11,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// One wedge of [HudDonut].
class ChartSlice {
  final String label;
  final double value;
  final Color color;

  const ChartSlice({
    required this.label,
    required this.value,
    required this.color,
  });
}

/// A donut with a legend. Used for the XP split across the four stats, where
/// the question is proportion — which is the one question a pie answers well.
class HudDonut extends StatelessWidget {
  final List<ChartSlice> slices;
  final double size;

  const HudDonut({super.key, required this.slices, this.size = 132});

  @override
  Widget build(BuildContext context) {
    final shown = slices.where((s) => s.value > 0).toList();
    final total = shown.fold<double>(0, (sum, s) => sum + s.value);
    if (total <= 0) return const SizedBox.shrink();

    return Row(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: size * 0.28,
              sections: [
                for (final s in shown)
                  PieChartSectionData(
                    value: s.value,
                    color: s.color,
                    radius: size * 0.2,
                    showTitle: false,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Flexible, not fixed: four legend rows at a long label and a large
        // system font size is exactly how a Row overflows on a 360dp phone.
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final s in shown)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: s.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          s.label,
                          style: AppTextStyles.hudLabel.copyWith(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${(s.value / total * 100).round()}%',
                        style: AppTextStyles.readout.copyWith(
                          fontSize: 11,
                          color: s.color,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
