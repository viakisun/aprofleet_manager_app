import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/work_order.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants/app_constants.dart';

class WoTimeline extends StatelessWidget {
  final List<WorkOrder> workOrders;

  const WoTimeline({
    super.key,
    required this.workOrders,
  });

  @override
  Widget build(BuildContext context) {
    // Group work orders by date
    final groupedOrders = <String, List<WorkOrder>>{};
    for (final workOrder in workOrders) {
      final dateKey = DateFormat('MMM dd, yyyy').format(workOrder.createdAt);
      groupedOrders.putIfAbsent(dateKey, () => []).add(workOrder);
    }

    // Sort dates
    final sortedDates = groupedOrders.keys.toList()
      ..sort((a, b) => DateFormat('MMM dd, yyyy')
          .parse(b)
          .compareTo(DateFormat('MMM dd, yyyy').parse(a)));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final orders = groupedOrders[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            // Timeline entries
            ...orders.map((workOrder) => _buildTimelineEntry(workOrder)),

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildTimelineEntry(WorkOrder workOrder) {
    final priorityColor =
        AppConstants.priorityColors[workOrder.priority] ?? Colors.grey;
    final statusColor = _getStatusColor(workOrder.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Status dot
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      workOrder.id,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    PriorityIndicator(priority: workOrder.priority),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  workOrder.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.directions_car,
                      size: 12,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      workOrder.cartId,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('HH:mm').format(workOrder.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(WorkOrderStatus status) {
    switch (status) {
      case WorkOrderStatus.draft:
        return Colors.grey;
      case WorkOrderStatus.pending:
        return Colors.orange;
      case WorkOrderStatus.inProgress:
        return Colors.blue;
      case WorkOrderStatus.onHold:
        return Colors.purple;
      case WorkOrderStatus.completed:
        return Colors.green;
      case WorkOrderStatus.cancelled:
        return Colors.red;
    }
  }
}
