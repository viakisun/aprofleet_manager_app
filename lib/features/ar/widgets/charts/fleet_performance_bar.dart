import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class FleetPerformanceBar extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final AnalyticsRange range;

  const FleetPerformanceBar({
    super.key,
    required this.data,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: const Color(0xFF1A1A1A),
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final date = data[group.x.toInt()]['date'] as DateTime;
              final availability = rod.toY;
              return BarTooltipItem(
                '${DateFormat('MMM dd').format(date)}\n${availability.toStringAsFixed(1)}%',
                const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= data.length) return const SizedBox();
                final date = data[value.toInt()]['date'] as DateTime;
                return Text(
                  DateFormat('MMM dd').format(date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        barGroups: data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final availability = item['availability'] as double;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: availability,
                color: _getBarColor(availability),
                width: 16,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Color _getBarColor(double value) {
    if (value >= 95) return Colors.green;
    if (value >= 90) return Colors.blue;
    if (value >= 80) return Colors.orange;
    return Colors.red;
  }
}
