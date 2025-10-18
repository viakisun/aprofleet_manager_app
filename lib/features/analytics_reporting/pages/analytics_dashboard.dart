import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/kpi.dart';
import '../../../core/services/providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/professional_app_bar.dart';
import '../../../core/widgets/hamburger_menu.dart';
import '../controllers/analytics_controller.dart';
import '../widgets/export_modal.dart';
import '../widgets/sections/kpi_cards_section.dart';
import '../widgets/sections/fleet_performance_section.dart';
import '../widgets/sections/battery_health_section.dart';
import '../widgets/sections/maintenance_distribution_section.dart';
import '../widgets/sections/cost_analysis_section.dart';
import '../widgets/sections/range_selector_widget.dart';

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
      appBar: ProfessionalAppBar(
        title: localizations.navAnalytics,
        showBackButton: false,
        showMenuButton: true,
        showNotificationButton: true,
        notificationBadgeCount: 3, // Mock count
        onMenuPressed: () => _showHamburgerMenu(context),
        onNotificationPressed: () => context.go('/al/center'),
        actions: [
          AppBarActionButton(
            icon: Icons.refresh,
            onPressed: () => analyticsController.refreshData(),
          ),
          AppBarActionButton(
            icon: Icons.download,
            onPressed: () => _showExportModal(context, analyticsController),
          ),
          AppBarActionButton(
            icon: Icons.fullscreen,
            onPressed: () => _toggleFullscreen(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Range Selector
          RangeSelectorWidget(
            selectedRange: _selectedRange,
            onRangeChanged: (AnalyticsRange range) {
              setState(() {
                _selectedRange = range;
              });
              analyticsController.setRange(range);
            },
          ),

          // Content
          Expanded(
            child: analyticsState.kpis.when(
              data: (kpis) => SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    KpiCardsSection(
                      kpis: kpis,
                      controller: analyticsController,
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

                    FleetPerformanceSection(
                      controller: analyticsController,
                      range: _selectedRange,
                    ),
                    const SizedBox(height: 16),

                    BatteryHealthSection(
                      controller: analyticsController,
                      range: _selectedRange,
                    ),
                    const SizedBox(height: 16),

                    MaintenanceDistributionSection(
                      controller: analyticsController,
                    ),
                    const SizedBox(height: 16),

                    CostAnalysisSection(
                      controller: analyticsController,
                    ),
                  ],
                ),
              ),
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

  void _showHamburgerMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const HamburgerMenu(),
    );
  }
}
