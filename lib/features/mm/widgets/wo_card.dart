import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/work_order.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants/app_constants.dart';

class WoCard extends StatelessWidget {
  final WorkOrder workOrder;
  final VoidCallback onTap;

  const WoCard({
    super.key,
    required this.workOrder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor =
        AppConstants.priorityColors[workOrder.priority] ?? Colors.grey;
    final statusColor = _getStatusColor(workOrder.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Priority Bar
              Row(
                children: [
                  // Priority indicator bar
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: priorityColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Work Order ID and Priority
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workOrder.id,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            PriorityIndicator(priority: workOrder.priority),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                workOrder.status.displayName,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Age indicator
                  _buildAgeIndicator(),
                ],
              ),

              const SizedBox(height: 12),

              // Type and Description
              Text(
                workOrder.type.displayName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                workOrder.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Cart and Location Info
              Row(
                children: [
                  Icon(
                    Icons.directions_car,
                    size: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    workOrder.cartId,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  if (workOrder.location != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        workOrder.location!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 8),

              // Technician and Time Info
              Row(
                children: [
                  if (workOrder.technician != null) ...[
                    Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      workOrder.technician!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const Spacer(),
                  ],

                  // Time info
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTimeInfo(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgeIndicator() {
    final now = DateTime.now();
    final age = now.difference(workOrder.createdAt);

    Color color;
    String text;

    if (age.inDays > 0) {
      color = Colors.red;
      text = '${age.inDays}d';
    } else if (age.inHours > 0) {
      color = Colors.orange;
      text = '${age.inHours}h';
    } else {
      color = Colors.green;
      text = '${age.inMinutes}m';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatTimeInfo() {
    final now = DateTime.now();
    final age = now.difference(workOrder.createdAt);

    if (age.inDays > 0) {
      return '${age.inDays}d ago';
    } else if (age.inHours > 0) {
      return '${age.inHours}h ago';
    } else {
      return '${age.inMinutes}m ago';
    }
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
