import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/alert.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants/app_constants.dart';

class AlertCard extends StatelessWidget {
  final Alert alert;
  final VoidCallback onTap;
  final VoidCallback onAcknowledge;
  final VoidCallback onViewCart;
  final VoidCallback onCreateWorkOrder;

  const AlertCard({
    super.key,
    required this.alert,
    required this.onTap,
    required this.onAcknowledge,
    required this.onViewCart,
    required this.onCreateWorkOrder,
  });

  @override
  Widget build(BuildContext context) {
    final severityColor =
        AppConstants.alertColors[alert.severity] ?? Colors.grey;
    final priorityColor =
        AppConstants.priorityColors[alert.priority] ?? Colors.grey;
    final isUnread = alert.state == AlertStatus.triggered ||
        alert.state == AlertStatus.notified;

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
          child: Row(
            children: [
              // Severity indicator bar
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: severityColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(width: 12),

              // Alert content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with title and priority
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            alert.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  isUnread ? FontWeight.w700 : FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        PriorityIndicator(priority: alert.priority),
                        if (isUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Message
                    Text(
                      alert.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Meta information
                    Row(
                      children: [
                        if (alert.cartId != null) ...[
                          Icon(
                            Icons.directions_car,
                            size: 14,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            alert.cartId!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (alert.location != null) ...[
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              alert.location!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          _formatTimeAgo(alert.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Action buttons
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, size: 20),
                    color: Colors.green,
                    onPressed: onAcknowledge,
                    tooltip: 'Acknowledge',
                  ),
                  IconButton(
                    icon: const Icon(Icons.directions_car, size: 20),
                    color: Colors.blue,
                    onPressed: onViewCart,
                    tooltip: 'View Cart',
                  ),
                  IconButton(
                    icon: const Icon(Icons.build, size: 20),
                    color: Colors.orange,
                    onPressed: onCreateWorkOrder,
                    tooltip: 'Create Work Order',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
