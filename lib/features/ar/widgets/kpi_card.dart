import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/constants/app_constants.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final KpiTrendDirection trend;
  final Color color;
  final IconData icon;
  final List<double> sparklineData;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.trend,
    required this.color,
    required this.icon,
    required this.sparklineData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              _buildTrendIndicator(),
            ],
          ),

          const SizedBox(height: 12),

          // Value
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          // Sparkline
          Expanded(
            child: _buildSparkline(),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIndicator() {
    IconData trendIcon;
    Color trendColor;

    switch (trend) {
      case KpiTrendDirection.up:
        trendIcon = Icons.trending_up;
        trendColor = Colors.green;
        break;
      case KpiTrendDirection.down:
        trendIcon = Icons.trending_down;
        trendColor = Colors.red;
        break;
      case KpiTrendDirection.stable:
        trendIcon = Icons.trending_flat;
        trendColor = Colors.grey;
        break;
    }

    return Icon(
      trendIcon,
      color: trendColor,
      size: 16,
    );
  }

  Widget _buildSparkline() {
    if (sparklineData.isEmpty) {
      return Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(
          child: Text(
            'No Data',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: sparklineData.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value);
            }).toList(),
            isCurved: true,
            color: color,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.1),
            ),
          ),
        ],
        minX: 0,
        maxX: sparklineData.length.toDouble() - 1,
        minY: sparklineData.reduce((a, b) => a < b ? a : b) - 5,
        maxY: sparklineData.reduce((a, b) => a > b ? a : b) + 5,
      ),
    );
  }
}
