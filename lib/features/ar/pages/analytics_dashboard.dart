import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/kpi.dart';
import '../../../core/services/providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants/app_constants.dart';
import '../controllers/analytics_controller.dart';
import '../widgets/kpi_card.dart';
import '../widgets/charts/fleet_performance_bar.dart';
import '../widgets/charts/battery_health_line.dart';
import '../widgets/charts/maintenance_pie.dart';
import '../widgets/export_modal.dart';

class AnalyticsDashboard extends ConsumerStatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  ConsumerState<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends ConsumerState<AnalyticsDashboard> {
  AnalyticsRange _selectedRange = AnalyticsRange.week;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final analyticsState = ref.watch(analyticsControllerProvider);
    final analyticsController = ref.read(analyticsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.navAnalytics),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => analyticsController.refreshData(),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _showExportModal(context, analyticsController),
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () => _toggleFullscreen(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Range Selector
          _buildRangeSelector(analyticsController),

          // Content
          Expanded(
            child: analyticsState.kpis.when(
              data: (kpis) => _buildDashboard(kpis, analyticsController),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading analytics: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(kpiProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeSelector(AnalyticsController controller) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'PERIOD:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: AnalyticsRange.values.map((range) {
                  final isSelected = _selectedRange == range;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRange = range;
                        });
                        controller.setRange(range);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          range.displayName,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(Kpi kpis, AnalyticsController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Cards
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
              KpiCard(
                title: 'Availability Rate',
                value: '${kpis.availabilityRate.toStringAsFixed(1)}%',
                trend: kpis.trend,
                color: Colors.green,
                icon: Icons.check_circle,
                sparklineData: controller.getAvailabilitySparkline(),
              ),
              KpiCard(
                title: 'MTTR',
                value: '${kpis.mttr.toStringAsFixed(0)} min',
                trend: kpis.trend,
                color: Colors.blue,
                icon: Icons.build,
                sparklineData: controller.getMTTRSparkline(),
              ),
              KpiCard(
                title: 'Utilization',
                value: '${kpis.utilization.toStringAsFixed(0)} km',
                trend: kpis.trend,
                color: Colors.orange,
                icon: Icons.speed,
                sparklineData: controller.getUtilizationSparkline(),
              ),
              KpiCard(
                title: 'Daily Distance',
                value: '${kpis.dailyDistance.toStringAsFixed(0)} km',
                trend: kpis.trend,
                color: Colors.purple,
                icon: Icons.route,
                sparklineData: controller.getDailyDistanceSparkline(),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Charts Section
          const Text(
            'PERFORMANCE CHARTS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Fleet Performance Chart
          Container(
            height: 200,
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
                const Text(
                  'Fleet Performance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: FleetPerformanceBar(
                    data: controller.getFleetPerformanceData(),
                    range: _selectedRange,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Battery Health Chart
          Container(
            height: 200,
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
                const Text(
                  'Battery Health Trend',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: BatteryHealthLine(
                    data: controller.getBatteryHealthData(),
                    range: _selectedRange,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Maintenance Distribution Chart
          Container(
            height: 200,
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
                const Text(
                  'Maintenance Distribution',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: MaintenancePie(
                    data: controller.getMaintenanceDistributionData(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Cost Analysis Chart
          Container(
            height: 200,
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
                const Text(
                  'Cost Analysis',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _buildCostAnalysisChart(controller),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostAnalysisChart(AnalyticsController controller) {
    final costData = controller.getCostAnalysisData();

    return Column(
      children: costData.entries.map((entry) {
        final percentage =
            entry.value / costData.values.reduce((a, b) => a + b) * 100;
        final color = _getCostColor(entry.key);

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: Text(
                  '\$${entry.value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getCostColor(String category) {
    switch (category.toLowerCase()) {
      case 'total':
        return Colors.blue;
      case 'labor':
        return Colors.green;
      case 'parts':
        return Colors.orange;
      case 'other':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showExportModal(BuildContext context, AnalyticsController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ExportModal(
        range: _selectedRange,
        onExport: (format) => _exportData(format, controller),
      ),
    );
  }

  void _exportData(ExportFormat format, AnalyticsController controller) {
    // TODO: Implement actual export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Exporting ${format.name} for ${_selectedRange.displayName}...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _toggleFullscreen() {
    // TODO: Implement fullscreen toggle
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fullscreen mode coming soon'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
