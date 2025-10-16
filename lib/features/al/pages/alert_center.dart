import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/alert.dart';
import '../../../domain/models/work_order.dart';
import '../../../core/services/providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/code_formatters.dart';
import '../controllers/alert_controller.dart';
import '../widgets/alert_card.dart';
import '../widgets/alert_filters.dart';
import '../widgets/alert_detail_modal.dart';
import '../widgets/alert_rules_panel.dart';

class AlertCenter extends ConsumerStatefulWidget {
  const AlertCenter({super.key});

  @override
  ConsumerState<AlertCenter> createState() => _AlertCenterState();
}

class _AlertCenterState extends ConsumerState<AlertCenter>
    with TickerProviderStateMixin {
  late TabController _tabController;
  AlertFilterType _currentFilter = AlertFilterType.all;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final alertState = ref.watch(alertControllerProvider);
    final alertController = ref.read(alertControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.navAlerts),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, alertController),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () =>
                _showFilterSheet(context, alertController, alertState),
          ),
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () => alertController.markAllRead(),
          ),
          IconButton(
            icon: Icon(alertState.isMuted
                ? Icons.notifications_off
                : Icons.notifications),
            onPressed: () => alertController.toggleMute(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsPanel(context, alertController),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Unread'),
            Tab(text: 'Cart'),
            Tab(text: 'Battery'),
            Tab(text: 'Maintenance'),
            Tab(text: 'Geofence'),
            Tab(text: 'System'),
          ],
          onTap: (index) {
            _currentFilter = AlertFilterType.values[index];
            alertController.setFilter(_getFilterForTab(_currentFilter));
          },
        ),
      ),
      body: Column(
        children: [
          // Summary Bar
          _buildSummaryBar(alertController),

          // Content
          Expanded(
            child: alertState.alerts.when(
              data: (alerts) => _buildAlertList(alerts, alertController),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading alerts: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(alertsProvider),
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

  Widget _buildSummaryBar(AlertController controller) {
    final summary = controller.getSummary();

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
          _buildSummaryChip('Critical', summary['critical'] ?? 0, Colors.red),
          const SizedBox(width: 12),
          _buildSummaryChip('Warning', summary['warning'] ?? 0, Colors.orange),
          const SizedBox(width: 12),
          _buildSummaryChip('Info', summary['info'] ?? 0, Colors.blue),
          const SizedBox(width: 12),
          _buildSummaryChip('Resolved', summary['resolved'] ?? 0, Colors.green),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertList(List<Alert> alerts, AlertController controller) {
    final filteredAlerts = controller.getFilteredAlerts(alerts);

    if (filteredAlerts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No alerts found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredAlerts.length,
      itemBuilder: (context, index) {
        final alert = filteredAlerts[index];
        return AlertCard(
          alert: alert,
          onTap: () => _showAlertDetail(context, alert, controller),
          onAcknowledge: () => controller.acknowledgeAlert(alert.id),
          onViewCart: () => context.go('/rt/cart/${alert.cartId}'),
          onCreateWorkOrder: () => _createWorkOrderFromAlert(alert),
        );
      },
    );
  }

  AlertFilter _getFilterForTab(AlertFilterType filterType) {
    switch (filterType) {
      case AlertFilterType.all:
        return const AlertFilter();
      case AlertFilterType.unread:
        return const AlertFilter(unreadOnly: true);
      case AlertFilterType.cart:
        return const AlertFilter(sources: {AlertSource.emergency});
      case AlertFilterType.battery:
        return const AlertFilter(sources: {AlertSource.battery});
      case AlertFilterType.maintenance:
        return const AlertFilter(sources: {AlertSource.maintenance});
      case AlertFilterType.geofence:
        return const AlertFilter(sources: {AlertSource.geofence});
      case AlertFilterType.system:
        return const AlertFilter(sources: {AlertSource.system});
    }
  }

  void _showAlertDetail(
      BuildContext context, Alert alert, AlertController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlertDetailModal(
        alert: alert,
        onAcknowledge: () => controller.acknowledgeAlert(alert.id),
        onEscalate: (level) => controller.escalateAlert(alert.id, level),
        onResolve: () => controller.resolveAlert(alert.id),
        onCreateWorkOrder: () => _createWorkOrderFromAlert(alert),
      ),
    );
  }

  void _createWorkOrderFromAlert(Alert alert) {
    // Map alert source to work order type
    WorkOrderType woType;
    switch (alert.title.toLowerCase()) {
      case 'critical battery level':
      case 'battery charging issue':
        woType = WorkOrderType.battery;
        break;
      case 'emergency stop activated':
        woType = WorkOrderType.emergencyRepair;
        break;
      case 'maintenance due':
      case 'maintenance completed':
        woType = WorkOrderType.preventive;
        break;
      case 'high temperature warning':
        woType = WorkOrderType.other;
        break;
      default:
        woType = WorkOrderType.other;
    }

    // Navigate to create work order with prefilled data
    context.go('/mm/create?cart=${alert.cartId}&type=${woType.name}');
  }

  void _showSearchDialog(BuildContext context, AlertController controller) {
    final searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Search Alerts',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search by title, message, or cart ID...',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: controller.setSearchQuery,
        ),
        actions: [
          TextButton(
            onPressed: () {
              searchController.clear();
              controller.setSearchQuery('');
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(
      BuildContext context, AlertController controller, alertState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AlertFilters(
        activeFilter: alertState.filter,
        onFilterChanged: controller.setFilter,
        onClearFilters: controller.clearFilter,
      ),
    );
  }

  void _showSettingsPanel(BuildContext context, AlertController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AlertRulesPanel(
        onExportAlerts: () => _exportAlerts(controller),
        onClearResolved: () => controller.clearResolved(),
      ),
    );
  }

  void _exportAlerts(AlertController controller) {
    // TODO: Implement CSV export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality coming soon'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

enum AlertFilterType {
  all,
  unread,
  cart,
  battery,
  maintenance,
  geofence,
  system,
}
