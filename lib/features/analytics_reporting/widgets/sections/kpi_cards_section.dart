import 'package:flutter/material.dart';

import '../../../../domain/models/kpi.dart';
import '../kpi_card.dart';
import '../../controllers/analytics_controller.dart';

class KpiCardsSection extends StatelessWidget {
  final Kpi kpis;
  final AnalyticsController controller;

  const KpiCardsSection({
    super.key,
    required this.kpis,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'KEY PERFORMANCE INDICATORS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: [
            PerformanceMetricCard(
              title: 'Availability Rate',
              value: '${kpis.availabilityRate.toStringAsFixed(1)}%',
              trend: kpis.trend,
              color: Colors.green,
              icon: Icons.check_circle,
              sparklineData: controller.getAvailabilitySparkline(),
            ),
            PerformanceMetricCard(
              title: 'MTTR',
              value: '${kpis.mttr.toStringAsFixed(0)} min',
              trend: kpis.trend,
              color: Colors.blue,
              icon: Icons.build,
              sparklineData: controller.getMTTRSparkline(),
            ),
            PerformanceMetricCard(
              title: 'Utilization',
              value: '${kpis.utilization.toStringAsFixed(0)} km',
              trend: kpis.trend,
              color: Colors.orange,
              icon: Icons.speed,
              sparklineData: controller.getUtilizationSparkline(),
            ),
            PerformanceMetricCard(
              title: 'Daily Distance',
              value: '${kpis.dailyDistance.toStringAsFixed(0)} km',
              trend: kpis.trend,
              color: Colors.purple,
              icon: Icons.route,
              sparklineData: controller.getDailyDistanceSparkline(),
            ),
          ],
        ),
      ],
    );
  }
}
