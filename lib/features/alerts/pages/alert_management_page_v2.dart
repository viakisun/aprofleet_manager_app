import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/alert.dart';
import '../../../domain/models/work_order.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/industrial_dark_tokens.dart';
import '../../../core/widgets/professional_app_bar.dart';
import '../../../core/widgets/hamburger_menu.dart';
import '../../../core/widgets/via/via_control_bar.dart';
import '../controllers/alert_controller.dart';
import '../widgets/alert_compact_card.dart';
import '../widgets/alert_detail_modal.dart';

/// Alert Management Page - Redesigned without tabs
///
/// Changes from original:
/// - ❌ No TabController/TabBar (removed 7 tabs)
/// - ✅ ViaControlBar with sticky positioning
/// - ✅ Compact alert cards (60-70px height)
/// - ✅ Filter/sort via dropdowns
/// - ✅ 2-3x more alerts visible on screen
class AlertManagementPageV2 extends ConsumerStatefulWidget {
  const AlertManagementPageV2({super.key});

  @override
  ConsumerState<AlertManagementPageV2> createState() =>
      _AlertManagementPageV2State();
}

class _AlertManagementPageV2State extends ConsumerState<AlertManagementPageV2> {
  // Filter and sort state
  String _currentFilter = 'all';
  String _currentSort = 'newest';

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
            icon: alertState.isMuted
                ? Icons.notifications_off
                : Icons.notifications,
            onPressed: () => alertController.toggleMute(),
          ),
          AppBarActionButton(
            icon: Icons.settings,
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          // NEW: Sticky Control Bar (replaces tabs + summary cards)
          _buildControlBar(alertState, alertController),

          // Alert List
          Expanded(
            child: alertState.alerts.when(
              data: (alerts) => _buildAlertList(alerts, alertController),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error,
                      size: 64,
                      color: IndustrialDarkTokens.error,
                    ),
                    const SizedBox(height: IndustrialDarkTokens.spacingItem),
                    Text(
                      'Error loading alerts',
                      style: TextStyle(
                        fontSize: IndustrialDarkTokens.fontSizeDisplay,
                        color: IndustrialDarkTokens.textSecondary,
                      ),
                    ),
                    const SizedBox(height: IndustrialDarkTokens.spacingCompact),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        fontSize: IndustrialDarkTokens.fontSizeSmall,
                        color: IndustrialDarkTokens.textSecondary,
                      ),
                      textAlign: TextAlign.center,
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

  Widget _buildControlBar(alertState, alertController) {
    return ViaControlBar(
      stats: _buildSummaryStats(alertState),
      filterOptions: _buildFilterOptions(),
      sortOptions: _buildSortOptions(),
      currentFilter: _currentFilter,
      currentSort: _currentSort,
      onFilterChanged: (filter) {
        setState(() {
          _currentFilter = filter;
        });
      },
      onSortChanged: (sort) {
        setState(() {
          _currentSort = sort;
        });
      },
      onStatTapped: (statId) {
        // Tap stat chip to filter by that severity/category
        setState(() {
          _currentFilter = statId;
        });
      },
    );
  }

  List<ViaStatData> _buildSummaryStats(alertState) {
    if (alertState.alerts is! AsyncData<List<Alert>>) {
      return [];
    }

    final alerts = (alertState.alerts as AsyncData<List<Alert>>).value;

    // Count by severity
    final criticalCount = alerts
        .where((a) => a.severity == AlertSeverity.critical)
        .length;
    final warningCount = alerts
        .where((a) => a.severity == AlertSeverity.warning)
        .length;
    final infoCount = alerts
        .where((a) => a.severity == AlertSeverity.info)
        .length;

    // Count unread
    final unreadCount = alerts
        .where((a) =>
            a.state == AlertStatus.triggered ||
            a.state == AlertStatus.notified)
        .length;

    return [
      ViaStatData(
        label: 'Critical',
        count: criticalCount,
        color: IndustrialDarkTokens.error,
        isActive: _currentFilter == 'critical',
        id: 'critical',
      ),
      ViaStatData(
        label: 'Warning',
        count: warningCount,
        color: IndustrialDarkTokens.warning,
        isActive: _currentFilter == 'warning',
        id: 'warning',
      ),
      ViaStatData(
        label: 'Info',
        count: infoCount,
        color: IndustrialDarkTokens.statusCharging,
        isActive: _currentFilter == 'info',
        id: 'info',
      ),
      ViaStatData(
        label: 'Unread',
        count: unreadCount,
        color: IndustrialDarkTokens.accentPrimary,
        isActive: _currentFilter == 'unread',
        id: 'unread',
      ),
    ];
  }

  List<ViaFilterOption> _buildFilterOptions() {
    return const [
      ViaFilterOption(label: 'All', value: 'all', icon: Icons.list),
      ViaFilterOption(label: 'Unread', value: 'unread', icon: Icons.mark_email_unread),
      ViaFilterOption(label: 'Critical', value: 'critical', icon: Icons.error),
      ViaFilterOption(label: 'Warning', value: 'warning', icon: Icons.warning),
      ViaFilterOption(label: 'Info', value: 'info', icon: Icons.info),
      ViaFilterOption(label: 'Cart', value: 'cart', icon: Icons.directions_car),
      ViaFilterOption(label: 'Battery', value: 'battery', icon: Icons.battery_alert),
      ViaFilterOption(label: 'Maintenance', value: 'maintenance', icon: Icons.build),
      ViaFilterOption(label: 'Geofence', value: 'geofence', icon: Icons.location_on),
      ViaFilterOption(label: 'System', value: 'system', icon: Icons.settings),
    ];
  }

  List<ViaSortOption> _buildSortOptions() {
    return const [
      ViaSortOption(label: 'Newest First', value: 'newest', icon: Icons.arrow_downward),
      ViaSortOption(label: 'Oldest First', value: 'oldest', icon: Icons.arrow_upward),
      ViaSortOption(label: 'Priority High→Low', value: 'priority_high', icon: Icons.arrow_upward),
      ViaSortOption(label: 'Priority Low→High', value: 'priority_low', icon: Icons.arrow_downward),
    ];
  }

  Widget _buildAlertList(List<Alert> alerts, alertController) {
    // Apply filter
    final filteredAlerts = _applyFilter(alerts, _currentFilter);

    // Apply sort
    final sortedAlerts = _applySort(filteredAlerts, _currentSort);

    if (sortedAlerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: IndustrialDarkTokens.textSecondary,
            ),
            const SizedBox(height: IndustrialDarkTokens.spacingItem),
            Text(
              'No alerts found',
              style: TextStyle(
                fontSize: IndustrialDarkTokens.fontSizeDisplay,
                color: IndustrialDarkTokens.textSecondary,
                fontWeight: IndustrialDarkTokens.fontWeightBold,
              ),
            ),
            const SizedBox(height: IndustrialDarkTokens.spacingCompact),
            Text(
              _currentFilter == 'all'
                  ? 'All alerts are resolved'
                  : 'No alerts match the selected filter',
              style: TextStyle(
                fontSize: IndustrialDarkTokens.fontSizeSmall,
                color: IndustrialDarkTokens.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
      itemCount: sortedAlerts.length,
      itemBuilder: (context, index) {
        final alert = sortedAlerts[index];
        return AlertCompactCard(
          alert: alert,
          onTap: () => _showAlertDetail(alert, alertController),
        );
      },
    );
  }

  List<Alert> _applyFilter(List<Alert> alerts, String filter) {
    switch (filter) {
      case 'all':
        return alerts;
      case 'unread':
        return alerts
            .where((a) =>
                a.state == AlertStatus.triggered ||
                a.state == AlertStatus.notified)
            .toList();
      case 'critical':
        return alerts
            .where((a) => a.severity == AlertSeverity.critical)
            .toList();
      case 'warning':
        return alerts
            .where((a) => a.severity == AlertSeverity.warning)
            .toList();
      case 'info':
        return alerts
            .where((a) => a.severity == AlertSeverity.info)
            .toList();
      case 'cart':
        return alerts
            .where((a) => a.category == AlertCategory.cart)
            .toList();
      case 'battery':
        return alerts
            .where((a) => a.category == AlertCategory.battery)
            .toList();
      case 'maintenance':
        return alerts
            .where((a) => a.category == AlertCategory.maintenance)
            .toList();
      case 'geofence':
        return alerts
            .where((a) => a.category == AlertCategory.geofence)
            .toList();
      case 'system':
        return alerts
            .where((a) => a.category == AlertCategory.system)
            .toList();
      default:
        return alerts;
    }
  }

  List<Alert> _applySort(List<Alert> alerts, String sort) {
    final sortedList = List<Alert>.from(alerts);

    switch (sort) {
      case 'newest':
        sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        sortedList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'priority_high':
        sortedList.sort((a, b) => a.priority.index - b.priority.index);
        break;
      case 'priority_low':
        sortedList.sort((a, b) => b.priority.index - a.priority.index);
        break;
    }

    return sortedList;
  }

  void _showAlertDetail(Alert alert, alertController) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlertDetailModal(
        alert: alert,
        onAcknowledge: () {
          alertController.acknowledgeAlert(alert.id);
          Navigator.of(context).pop();
        },
        onEscalate: (level) {
          alertController.escalateAlert(alert.id, level);
        },
        onResolve: () {
          alertController.resolveAlert(alert.id);
          Navigator.of(context).pop();
        },
        onCreateWorkOrder: () {
          Navigator.of(context).pop();
          context.go('/mm/create?cart=${alert.cartId}');
        },
        onViewCart: alert.cartId != null
            ? () {
                Navigator.of(context).pop();
                context.go('/rt/cart/${alert.cartId}');
              }
            : null,
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
}
