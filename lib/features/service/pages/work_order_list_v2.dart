import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/work_order.dart';
import '../../../core/services/providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/professional_app_bar.dart';
import '../../../core/widgets/hamburger_menu.dart';
import '../../../core/theme/industrial_dark_tokens.dart';
import '../../../core/widgets/via/via_control_bar.dart';
import '../controllers/work_order_controller.dart';
import '../widgets/work_order_card.dart';
import '../widgets/work_order_timeline.dart';
import '../widgets/work_order_detail_modal.dart';

/// Work Order List Page - Redesigned without tabs
///
/// Changes from original:
/// - ❌ No TabController/TabBar (removed 6 tabs)
/// - ❌ No separate Stats Bar
/// - ✅ ViaControlBar with sticky positioning + integrated stats
/// - ✅ Filter/sort via dropdowns
/// - ✅ View mode toggle (List/Timeline)
class WorkOrderListV2 extends ConsumerStatefulWidget {
  const WorkOrderListV2({super.key});

  @override
  ConsumerState<WorkOrderListV2> createState() => _WorkOrderListV2State();
}

class _WorkOrderListV2State extends ConsumerState<WorkOrderListV2> {
  // Filter, sort, and view mode state
  String _currentFilter = 'all';
  String _currentSort = 'newest';
  String _currentViewMode = 'list';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final workOrderState = ref.watch(workOrderControllerProvider);
    final workOrderController = ref.read(workOrderControllerProvider.notifier);

    return Scaffold(
      appBar: ProfessionalAppBar(
        title: localizations.navMaintenance,
        showBackButton: false,
        showMenuButton: true,
        showNotificationButton: true,
        notificationBadgeCount: 3,
        onMenuPressed: () => _showHamburgerMenu(context),
        onNotificationPressed: () => context.go('/al/center'),
        actions: [
          AppBarActionButton(
            icon: Icons.add,
            onPressed: () => context.go('/mm/create'),
          ),
        ],
      ),
      body: Column(
        children: [
          // NEW: Sticky Control Bar (replaces tabs + stats bar)
          _buildControlBar(workOrderState, workOrderController),

          // Work Order List/Timeline
          Expanded(
            child: workOrderState.workOrders.when(
              data: (workOrders) =>
                  _buildContent(workOrders, workOrderController, context),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
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
                      '${localizations.woErrorLoading}: $error',
                      style: TextStyle(
                        fontSize: IndustrialDarkTokens.fontSizeDisplay,
                        color: IndustrialDarkTokens.textSecondary,
                      ),
                    ),
                    const SizedBox(height: IndustrialDarkTokens.spacingItem),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(workOrdersProvider),
                      child: Text(localizations.woRetry),
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

  Widget _buildControlBar(workOrderState, WorkOrderController controller) {
    return ViaControlBar(
      stats: _buildSummaryStats(controller),
      filterOptions: _buildFilterOptions(),
      sortOptions: _buildSortOptions(),
      viewModes: _buildViewModes(),
      currentFilter: _currentFilter,
      currentSort: _currentSort,
      currentViewMode: _currentViewMode,
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
      onViewModeChanged: (mode) {
        setState(() {
          _currentViewMode = mode;
        });
      },
      onStatTapped: (statId) {
        // Tap stat chip to filter
        setState(() {
          _currentFilter = statId;
        });
      },
    );
  }

  List<ViaStatData> _buildSummaryStats(WorkOrderController controller) {
    final stats = controller.getStats();

    return [
      ViaStatData(
        label: 'Urgent',
        count: stats['urgent'] ?? 0,
        color: IndustrialDarkTokens.error,
        isActive: _currentFilter == 'urgent',
        id: 'urgent',
      ),
      ViaStatData(
        label: 'Pending',
        count: stats['pending'] ?? 0,
        color: IndustrialDarkTokens.warning,
        isActive: _currentFilter == 'pending',
        id: 'pending',
      ),
      ViaStatData(
        label: 'Active',
        count: stats['inProgress'] ?? 0,
        color: IndustrialDarkTokens.statusActive,
        isActive: _currentFilter == 'inProgress',
        id: 'inProgress',
      ),
      ViaStatData(
        label: 'Today',
        count: stats['today'] ?? 0,
        color: IndustrialDarkTokens.statusCharging,
        isActive: _currentFilter == 'today',
        id: 'today',
      ),
    ];
  }

  List<ViaFilterOption> _buildFilterOptions() {
    return const [
      ViaFilterOption(label: 'All', value: 'all', icon: Icons.list),
      ViaFilterOption(label: 'Urgent (P1)', value: 'urgent', icon: Icons.error),
      ViaFilterOption(label: 'Pending', value: 'pending', icon: Icons.pending),
      ViaFilterOption(label: 'In Progress', value: 'inProgress', icon: Icons.play_arrow),
      ViaFilterOption(label: 'On Hold', value: 'onHold', icon: Icons.pause),
      ViaFilterOption(label: 'Completed', value: 'completed', icon: Icons.check_circle),
      ViaFilterOption(label: 'Cancelled', value: 'cancelled', icon: Icons.cancel),
      ViaFilterOption(label: 'Today', value: 'today', icon: Icons.today),
    ];
  }

  List<ViaSortOption> _buildSortOptions() {
    return const [
      ViaSortOption(label: 'Newest First', value: 'newest', icon: Icons.arrow_downward),
      ViaSortOption(label: 'Oldest First', value: 'oldest', icon: Icons.arrow_upward),
      ViaSortOption(label: 'Priority High→Low', value: 'priority_high', icon: Icons.arrow_upward),
      ViaSortOption(label: 'Priority Low→High', value: 'priority_low', icon: Icons.arrow_downward),
      ViaSortOption(label: 'Due Date', value: 'due_date', icon: Icons.calendar_today),
    ];
  }

  List<ViaViewMode> _buildViewModes() {
    return const [
      ViaViewMode(label: 'List', value: 'list', icon: Icons.list),
      ViaViewMode(label: 'Timeline', value: 'timeline', icon: Icons.timeline),
    ];
  }

  Widget _buildContent(
      List<WorkOrder> workOrders,
      WorkOrderController controller,
      BuildContext context) {
    // Apply filter
    final filteredOrders = _applyFilter(workOrders, _currentFilter);

    // Apply sort
    final sortedOrders = _applySort(filteredOrders, _currentSort);

    if (sortedOrders.isEmpty) {
      final localizations = AppLocalizations.of(context);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: IndustrialDarkTokens.spacingItem),
            Text(
              localizations.woNoWorkOrders,
              style: TextStyle(
                fontSize: IndustrialDarkTokens.fontSizeDisplay,
                color: IndustrialDarkTokens.textSecondary,
                fontWeight: IndustrialDarkTokens.fontWeightBold,
              ),
            ),
            const SizedBox(height: IndustrialDarkTokens.spacingCompact),
            Text(
              _currentFilter == 'all'
                  ? 'Create a new work order to get started'
                  : 'No work orders match the selected filter',
              style: TextStyle(
                fontSize: IndustrialDarkTokens.fontSizeSmall,
                color: IndustrialDarkTokens.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_currentViewMode == 'timeline') {
      return WoTimeline(workOrders: sortedOrders);
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
        itemCount: sortedOrders.length,
        itemBuilder: (context, index) {
          final workOrder = sortedOrders[index];
          return WorkOrderCard(
            workOrder: workOrder,
            onTap: () => _showWorkOrderDetail(context, workOrder, controller),
          );
        },
      );
    }
  }

  List<WorkOrder> _applyFilter(List<WorkOrder> workOrders, String filter) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    switch (filter) {
      case 'all':
        return workOrders;
      case 'urgent':
        return workOrders.where((wo) => wo.priority == Priority.p1).toList();
      case 'pending':
        return workOrders
            .where((wo) => wo.status == WorkOrderStatus.pending)
            .toList();
      case 'inProgress':
        return workOrders
            .where((wo) => wo.status == WorkOrderStatus.inProgress)
            .toList();
      case 'onHold':
        return workOrders
            .where((wo) => wo.status == WorkOrderStatus.onHold)
            .toList();
      case 'completed':
        return workOrders
            .where((wo) => wo.status == WorkOrderStatus.completed)
            .toList();
      case 'cancelled':
        return workOrders
            .where((wo) => wo.status == WorkOrderStatus.cancelled)
            .toList();
      case 'today':
        return workOrders
            .where((wo) =>
                wo.createdAt.isAfter(todayStart) &&
                wo.createdAt.isBefore(todayEnd))
            .toList();
      default:
        return workOrders;
    }
  }

  List<WorkOrder> _applySort(List<WorkOrder> workOrders, String sort) {
    final sortedList = List<WorkOrder>.from(workOrders);

    switch (sort) {
      case 'newest':
        sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        sortedList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'priority_high':
        sortedList.sort((a, b) => a.priority.index.compareTo(b.priority.index));
        break;
      case 'priority_low':
        sortedList.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case 'due_date':
        sortedList.sort((a, b) {
          // Sort by createdAt as fallback (WorkOrder doesn't have scheduledDate)
          return a.createdAt.compareTo(b.createdAt);
        });
        break;
    }

    return sortedList;
  }

  void _showWorkOrderDetail(BuildContext context, WorkOrder workOrder,
      WorkOrderController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WorkOrderDetailModal(
        workOrder: workOrder,
        onUpdate: (updatedWorkOrder) {
          controller.updateWorkOrder(updatedWorkOrder);
        },
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
