import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/work_order.dart';
import '../../core/services/providers.dart';

class WorkOrderController extends StateNotifier<WorkOrderState> {
  WorkOrderController(this.ref) : super(WorkOrderState.initial()) {
    _initialize();
  }

  final Ref ref;

  void _initialize() {
    // Load initial work orders
    ref.read(workOrdersProvider.future).then((workOrders) {
      state = state.copyWith(
          workOrders: AsyncValue.data(workOrders), isLoading: false);
    });
  }

  void setFilter(WorkOrderFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void clearFilter() {
    state = state.copyWith(filter: const WorkOrderFilter());
  }

  List<WorkOrder> getFilteredWorkOrders(List<WorkOrder> workOrders) {
    var filtered = workOrders;

    // Apply status filter
    if (state.filter.statuses != null && state.filter.statuses!.isNotEmpty) {
      filtered = filtered
          .where((wo) => state.filter.statuses!.contains(wo.status))
          .toList();
    }

    // Apply priority filter
    if (state.filter.priorities != null &&
        state.filter.priorities!.isNotEmpty) {
      filtered = filtered
          .where((wo) => state.filter.priorities!.contains(wo.priority))
          .toList();
    }

    // Apply type filter
    if (state.filter.types != null && state.filter.types!.isNotEmpty) {
      filtered = filtered
          .where((wo) => state.filter.types!.contains(wo.type))
          .toList();
    }

    // Apply cart filter
    if (state.filter.cartId != null && state.filter.cartId!.isNotEmpty) {
      filtered =
          filtered.where((wo) => wo.cartId == state.filter.cartId).toList();
    }

    // Apply technician filter
    if (state.filter.technician != null &&
        state.filter.technician!.isNotEmpty) {
      filtered = filtered
          .where((wo) => wo.technician == state.filter.technician)
          .toList();
    }

    // Apply date range filter
    if (state.filter.fromDate != null) {
      filtered = filtered
          .where((wo) => wo.createdAt.isAfter(state.filter.fromDate!))
          .toList();
    }
    if (state.filter.toDate != null) {
      filtered = filtered
          .where((wo) => wo.createdAt.isBefore(state.filter.toDate!))
          .toList();
    }

    // Sort by priority and creation date
    filtered.sort((a, b) {
      final priorityComparison = a.priority.index.compareTo(b.priority.index);
      if (priorityComparison != 0) return priorityComparison;
      return b.createdAt.compareTo(a.createdAt);
    });

    return filtered;
  }

  Map<String, int> getStats() {
    final workOrders = state.workOrders.valueOrNull ?? [];
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    final stats = <String, int>{
      'urgent': workOrders.where((wo) => wo.priority == Priority.p1).length,
      'pending':
          workOrders.where((wo) => wo.status == WorkOrderStatus.pending).length,
      'inProgress': workOrders
          .where((wo) => wo.status == WorkOrderStatus.inProgress)
          .length,
      'today': workOrders
          .where((wo) =>
              wo.status == WorkOrderStatus.completed &&
              wo.completedAt != null &&
              wo.completedAt!.isAfter(todayStart))
          .length,
    };
    return stats;
  }

  Future<void> updateWorkOrder(WorkOrder workOrder) async {
    try {
      // Update in repository
      await ref.read(workOrderRepositoryProvider).update(workOrder);

      // Update local state
      final currentWorkOrders = state.workOrders.valueOrNull ?? [];
      final updatedWorkOrders = currentWorkOrders
          .map((wo) => wo.id == workOrder.id ? workOrder : wo)
          .toList();

      state = state.copyWith(workOrders: AsyncValue.data(updatedWorkOrders));
    } catch (e) {
      // Handle error
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateWorkOrderStatus(
      String workOrderId, WorkOrderStatus status) async {
    try {
      await ref
          .read(workOrderRepositoryProvider)
          .updateStatus(workOrderId, status);

      // Update local state
      final currentWorkOrders = state.workOrders.valueOrNull ?? [];
      final updatedWorkOrders = currentWorkOrders
          .map((wo) => wo.id == workOrderId ? wo.copyWith(status: status) : wo)
          .toList();

      state = state.copyWith(workOrders: AsyncValue.data(updatedWorkOrders));
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<WorkOrder> createWorkOrder(WorkOrderDraft draft) async {
    try {
      final workOrder =
          await ref.read(workOrderRepositoryProvider).create(draft);

      // Add to local state
      final currentWorkOrders = state.workOrders.valueOrNull ?? [];
      final updatedWorkOrders = [workOrder, ...currentWorkOrders];

      state = state.copyWith(workOrders: AsyncValue.data(updatedWorkOrders));

      return workOrder;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}

class WorkOrderState {
  final AsyncValue<List<WorkOrder>> workOrders;
  final WorkOrderFilter filter;
  final bool isLoading;
  final String? error;

  const WorkOrderState({
    required this.workOrders,
    required this.filter,
    required this.isLoading,
    this.error,
  });

  factory WorkOrderState.initial() {
    return const WorkOrderState(
      workOrders: AsyncValue.loading(),
      filter: WorkOrderFilter(),
      isLoading: true,
    );
  }

  WorkOrderState copyWith({
    AsyncValue<List<WorkOrder>>? workOrders,
    WorkOrderFilter? filter,
    bool? isLoading,
    String? error,
  }) {
    return WorkOrderState(
      workOrders: workOrders ?? this.workOrders,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final workOrderControllerProvider =
    StateNotifierProvider<WorkOrderController, WorkOrderState>((ref) {
  return WorkOrderController(ref);
});
