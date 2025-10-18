import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/localization/app_localizations.dart';

class MaintenancePie extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final BuildContext context;

  const MaintenancePie({
    super.key,
    required this.data,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final total =
        data.fold<int>(0, (sum, item) => sum + (item['count'] as int));

    return Row(
      children: [
        // Pie Chart
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                enabled: true,
                touchCallback: (event, pieTouchResponse) {
                  // Handle touch events if needed
                },
              ),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: data.map((item) {
                final count = item['count'] as int;
                final color = item['color'] as Color;
                final percentage = (count / total * 100).toStringAsFixed(1);

                return PieChartSectionData(
                  color: color,
                  value: count.toDouble(),
                  title: '$percentage%',
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Legend
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: data.map((item) {
                final typeKey = item['type'] as String;
                final count = item['count'] as int;
                final color = item['color'] as Color;
                final percentage = (count / total * 100).toStringAsFixed(1);
                final localizedType = _getLocalizedMaintenanceType(typeKey, localizations);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizedType,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '$count ($percentage%)',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  String _getLocalizedMaintenanceType(String key, AppLocalizations localizations) {
    switch (key) {
      case 'maintenancePreventive':
        return localizations.maintenancePreventive;
      case 'maintenanceBattery':
        return localizations.maintenanceBattery;
      case 'maintenanceTire':
        return localizations.maintenanceTire;
      case 'maintenanceEmergency':
        return localizations.maintenanceEmergency;
      case 'maintenanceOther':
        return localizations.maintenanceOther;
      default:
        return key;
    }
  }
}
