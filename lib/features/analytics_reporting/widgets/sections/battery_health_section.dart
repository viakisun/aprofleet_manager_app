import 'package:flutter/material.dart';

import '../../../../domain/models/kpi.dart';
import '../../../../core/localization/app_localizations.dart';
import '../charts/battery_health_line.dart';
import '../../controllers/analytics_controller.dart';

class BatteryHealthSection extends StatelessWidget {
  final AnalyticsController controller;
  final AnalyticsRange range;

  const BatteryHealthSection({
    super.key,
    required this.controller,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.analyticsBatteryHealth,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: BatteryHealthLine(
              data: controller.getBatteryHealthData(),
              range: range,
            ),
          ),
        ],
      ),
    );
  }
}
