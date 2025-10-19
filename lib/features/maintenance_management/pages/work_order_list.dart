import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/work_order.dart';
import '../../../core/services/providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/professional_app_bar.dart';
import '../../../core/widgets/hamburger_menu.dart';
import '../../../core/theme/design_tokens.dart';
import '../controllers/work_order_controller.dart';
import '../widgets/work_order_card.dart';
import '../widgets/work_order_timeline.dart';
import '../widgets/work_order_detail_modal.dart';

class WorkOrderList extends ConsumerStatefulWidget {
  const WorkOrderList({super.key});

  @override
  ConsumerState<WorkOrderList> createState() => _WorkOrderListState();
}

class _WorkOrderListState extends ConsumerState<WorkOrderList>
    with TickerProviderStateMixin {
  late TabController _tabController;
  WorkOrderViewMode _viewMode = WorkOrderViewMode.list;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        notificationBadgeCount: 3, // Mock count
        onMenuPressed: () => _showHamburgerMenu(context),
        onNotificationPressed: () => context.go('/al/center'),
        actions: [
          AppBarActionButton(
            icon: _viewMode == WorkOrderViewMode.list
                ? Icons.timeline
                : Icons.list,
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == WorkOrderViewMode.list
                    ? WorkOrderViewMode.timeline
                    : WorkOrderViewMode.list;
              });
            },
          ),
          AppBarActionButton(
            icon: Icons.add,
            onPressed: () => context.go('/mm/create'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: DesignTokens.bgPrimary,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [
                Tab(text: localizations.woFilterAll),
                Tab(text: localizations.woFilterUrgent),
                Tab(text: localizations.woFilterPending),
                Tab(text: localizations.woFilterInProgress),
                Tab(text: localizations.woFilterCompleted),
                Tab(text: localizations.woFilterTimeline),
              ],
              onTap: (index) {
                workOrderController.setFilter(_getFilterForTab(index));
              },
            ),
          ),

          // Stats Bar
          _buildStatsBar(workOrderController, context),

          // Content
          Expanded(
            child: workOrderState.workOrders.when(
              data: (workOrders) =>
                  _buildContent(workOrders, workOrderController, context),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('${localizations.woErrorLoading}: $error'),
                    const SizedBox(height: 16),
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

  Widget _buildStatsBar(WorkOrderController controller, BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final stats = controller.getStats();

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingMd, vertical: DesignTokens.spacingSm),
      decoration: BoxDecoration(
        color: DesignTokens.bgSecondary,
        border: Border(
          bottom: BorderSide(
            color: DesignTokens.borderPrimary,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildStatChip(localizations.woStatsUrgent, stats['urgent'] ?? 0,
              DesignTokens.statusCritical),
          const SizedBox(width: DesignTokens.spacingSm),
          _buildStatChip(localizations.woStatsPending, stats['pending'] ?? 0,
              DesignTokens.statusWarning),
          const SizedBox(width: DesignTokens.spacingSm),
          _buildStatChip(localizations.woStatsInProgress,
              stats['inProgress'] ?? 0, DesignTokens.statusActive),
          const SizedBox(width: DesignTokens.spacingSm),
          _buildStatChip(localizations.woStatsToday, stats['today'] ?? 0,
              DesignTokens.statusCharging),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingSm, vertical: DesignTokens.spacingXs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: DesignTokens.spacingSm,
            height: DesignTokens.spacingSm,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: DesignTokens.spacingXs),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: DesignTokens.fontSizeSm,
              fontWeight: DesignTokens.fontWeightSemibold,
            ),
          ),
          const SizedBox(width: DesignTokens.spacingXs),
          Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontSize: DesignTokens.fontSizeSm,
              fontWeight: DesignTokens.fontWeightBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<WorkOrder> workOrders,
      WorkOrderController controller, BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final filteredOrders = controller.getFilteredWorkOrders(workOrders);

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              localizations.woNoWorkOrders,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (_viewMode == WorkOrderViewMode.timeline) {
      return WoTimeline(workOrders: filteredOrders);
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final workOrder = filteredOrders[index];
          return WorkOrderCard(
            workOrder: workOrder,
            onTap: () => _showWorkOrderDetail(context, workOrder, controller),
          );
        },
      );
    }
  }

  WorkOrderFilter _getFilterForTab(int index) {
    switch (index) {
      case 0: // All
        return const WorkOrderFilter();
      case 1: // Urgent
        return const WorkOrderFilter(priorities: {Priority.p1});
      case 2: // Pending
        return const WorkOrderFilter(statuses: {WorkOrderStatus.pending});
      case 3: // In Progress
        return const WorkOrderFilter(statuses: {WorkOrderStatus.inProgress});
      case 4: // Completed
        return const WorkOrderFilter(statuses: {WorkOrderStatus.completed});
      case 5: // Timeline
        return const WorkOrderFilter();
      default:
        return const WorkOrderFilter();
    }
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

enum WorkOrderViewMode { list, timeline }
