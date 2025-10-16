import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/work_order.dart';
import '../../core/services/providers.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/shared_widgets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/code_formatters.dart';
import '../controllers/work_order_controller.dart';
import '../widgets/wo_card.dart';
import '../widgets/wo_timeline.dart';
import '../widgets/wo_detail_modal.dart';

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
      appBar: AppBar(
        title: Text(localizations.navMaintenance),
        actions: [
          IconButton(
            icon: Icon(_viewMode == WorkOrderViewMode.list
                ? Icons.timeline
                : Icons.list),
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == WorkOrderViewMode.list
                    ? WorkOrderViewMode.timeline
                    : WorkOrderViewMode.list;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/mm/create'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Urgent'),
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Completed'),
            Tab(text: 'Timeline'),
          ],
          onTap: (index) {
            workOrderController.setFilter(_getFilterForTab(index));
          },
        ),
      ),
      body: Column(
        children: [
          // Stats Bar
          _buildStatsBar(workOrderController),

          // Content
          Expanded(
            child: workOrderState.workOrders.when(
              data: (workOrders) =>
                  _buildContent(workOrders, workOrderController),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading work orders: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(workOrdersProvider),
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

  Widget _buildStatsBar(WorkOrderController controller) {
    final stats = controller.getStats();

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
          _buildStatChip('Urgent', stats['urgent'] ?? 0, Colors.red),
          const SizedBox(width: 12),
          _buildStatChip('Pending', stats['pending'] ?? 0, Colors.orange),
          const SizedBox(width: 12),
          _buildStatChip('In Progress', stats['inProgress'] ?? 0, Colors.blue),
          const SizedBox(width: 12),
          _buildStatChip('Today', stats['today'] ?? 0, Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
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

  Widget _buildContent(
      List<WorkOrder> workOrders, WorkOrderController controller) {
    final filteredOrders = controller.getFilteredWorkOrders(workOrders);

    if (filteredOrders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No work orders found',
              style: TextStyle(
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
          return WoCard(
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
      builder: (context) => WoDetailModal(
        workOrder: workOrder,
        onUpdate: (updatedWorkOrder) {
          controller.updateWorkOrder(updatedWorkOrder);
        },
      ),
    );
  }
}

enum WorkOrderViewMode { list, timeline }
