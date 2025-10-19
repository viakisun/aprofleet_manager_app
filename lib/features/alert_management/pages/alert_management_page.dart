import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/alert.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/professional_app_bar.dart';
import '../../../core/widgets/hamburger_menu.dart';
import '../controllers/alert_controller.dart';
import '../widgets/alert_card.dart';
import '../widgets/alert_filters.dart';
import '../widgets/alert_detail_modal.dart';
import '../widgets/alert_rules_panel.dart';
import '../widgets/alert_summary_cards.dart';

/// Main alert management page with tabbed interface
class AlertManagementPage extends ConsumerStatefulWidget {
  const AlertManagementPage({super.key});

  @override
  ConsumerState<AlertManagementPage> createState() =>
      _AlertManagementPageState();
}

class _AlertManagementPageState extends ConsumerState<AlertManagementPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

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
      appBar: ProfessionalAppBar(
        title: localizations.navAlerts,
        showBackButton: false,
        showMenuButton: true,
        showNotificationButton: false,
        onMenuPressed: () => _showHamburgerMenu(context),
        actions: [
          AppBarActionButton(
            icon: Icons.search,
            onPressed: () => _showSearchDialog(context, alertController),
          ),
          AppBarActionButton(
            icon: Icons.filter_list,
            onPressed: () =>
                _showFilterSheet(context, alertController, alertState),
          ),
          AppBarActionButton(
            icon: Icons.done_all,
            onPressed: () => alertController.markAllRead(),
          ),
          AppBarActionButton(
            icon: alertState.isMuted
                ? Icons.notifications_off
                : Icons.notifications,
            onPressed: () => alertController.toggleMute(),
          ),
          AppBarActionButton(
            icon: Icons.settings,
            onPressed: () => _showSettingsPanel(context, alertController),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          AlertSummaryCards(
            alertsAsync: alertState.alerts,
          ),

          // Tab Bar
          Container(
            color: DesignTokens.bgPrimary,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [
                Tab(text: localizations.alertTabAll),
                Tab(text: localizations.alertTabUnread),
                Tab(text: localizations.alertTabCart),
                Tab(text: localizations.alertTabBattery),
                Tab(text: localizations.alertTabMaintenance),
                Tab(text: localizations.alertTabGeofence),
                Tab(text: localizations.alertTabSystem),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAlertList(
                    AlertFilterType.all, alertState, alertController),
                _buildAlertList(
                    AlertFilterType.unread, alertState, alertController),
                _buildAlertList(
                    AlertFilterType.cart, alertState, alertController),
                _buildAlertList(
                    AlertFilterType.battery, alertState, alertController),
                _buildAlertList(
                    AlertFilterType.maintenance, alertState, alertController),
                _buildAlertList(
                    AlertFilterType.geofence, alertState, alertController),
                _buildAlertList(
                    AlertFilterType.system, alertState, alertController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertList(
      AlertFilterType filterType, alertState, alertController) {
    if (alertState.alerts is AsyncData<List<Alert>>) {
      final data = alertState.alerts as AsyncData<List<Alert>>;
      final filteredAlerts = _getFilteredAlerts(data.value, filterType);
      return _buildAlertListContent(filteredAlerts, alertController);
    } else if (alertState.alerts is AsyncLoading<List<Alert>>) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (alertState.alerts is AsyncError<List<Alert>>) {
      final error = alertState.alerts as AsyncError<List<Alert>>;
      return Center(
        child: Text(
          'Error loading alerts: ${error.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildAlertListContent(List<Alert> filteredAlerts, alertController) {
    if (filteredAlerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: DesignTokens.textTertiary,
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            Text(
              'No alerts found',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeLg,
                color: DesignTokens.textSecondary,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingSm),
            Text(
              'All alerts are resolved or filtered out',
              style: TextStyle(
                fontSize: DesignTokens.fontSizeSm,
                color: DesignTokens.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      itemCount: filteredAlerts.length,
      itemBuilder: (context, index) {
        final alert = filteredAlerts[index];
        return AlertNotificationCard(
          alert: alert,
          onTap: () => _showAlertDetail(alert, alertController),
          onAcknowledge: () => alertController.acknowledgeAlert(alert.id),
          onViewCart: () => context.go('/rt/cart/${alert.cartId}'),
          onCreateWorkOrder: () =>
              context.go('/mm/create?cart=${alert.cartId}'),
        );
      },
    );
  }

  List<Alert> _getFilteredAlerts(
      List<Alert> alerts, AlertFilterType filterType) {
    switch (filterType) {
      case AlertFilterType.all:
        return alerts;
      case AlertFilterType.unread:
        return alerts
            .where((alert) =>
                alert.state == AlertStatus.triggered ||
                alert.state == AlertStatus.notified)
            .toList();
      case AlertFilterType.cart:
        return alerts
            .where((alert) => alert.category == AlertCategory.cart)
            .toList();
      case AlertFilterType.battery:
        return alerts
            .where((alert) => alert.category == AlertCategory.battery)
            .toList();
      case AlertFilterType.maintenance:
        return alerts
            .where((alert) => alert.category == AlertCategory.maintenance)
            .toList();
      case AlertFilterType.geofence:
        return alerts
            .where((alert) => alert.category == AlertCategory.geofence)
            .toList();
      case AlertFilterType.system:
        return alerts
            .where((alert) => alert.category == AlertCategory.system)
            .toList();
    }
  }

  void _showAlertDetail(Alert alert, alertController) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlertDetailModal(
        alert: alert,
        onAcknowledge: () => alertController.acknowledgeAlert(alert.id),
        onEscalate: (level) => alertController.escalateAlert(alert.id, level),
        onResolve: () => alertController.resolveAlert(alert.id),
        onCreateWorkOrder: () {
          Navigator.of(context).pop();
          context.go('/mm/create?cart=${alert.cartId}');
        },
      ),
    );
  }

  void _showHamburgerMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const HamburgerMenu(),
    );
  }

  void _showSearchDialog(BuildContext context, alertController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Alerts'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Search by cart ID, description...',
          ),
          onChanged: (query) {
            // Implement search logic
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context, alertController, alertState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AlertFilters(
        activeFilter: const AlertFilter(),
        onFilterChanged: (filter) {
          // Handle filter change
          Navigator.of(context).pop();
        },
        onClearFilters: () {
          // Handle clear filters
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showSettingsPanel(BuildContext context, alertController) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlertRulesPanel(
        onExportAlerts: () {
          // Implement export logic
          Navigator.of(context).pop();
        },
        onClearResolved: () {
          // Implement clear resolved alerts logic
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
