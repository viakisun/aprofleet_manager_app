import 'package:flutter/material.dart';

import '../../../domain/models/work_order.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/via/via_card.dart';
import '../../../core/widgets/via/via_priority_badge.dart';
import '../../../core/widgets/via/via_status_badge.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/design_tokens.dart';

class WorkOrderCard extends StatelessWidget {
  final WorkOrder workOrder;
  final VoidCallback onTap;

  const WorkOrderCard({
    super.key,
    required this.workOrder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor =
        AppConstants.priorityColors[workOrder.priority] ?? Colors.grey;

    return ViaCard(
      onTap: onTap,
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
                            ViaPriorityBadge(priority: workOrder.priority),
                            const SizedBox(width: 8),
                            ViaStatusBadge(
                              status: _mapWorkOrderStatusToViaStatus(workOrder.status),
                              customText: workOrder.status.getDisplayName(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Age indicator
                  _buildAgeIndicator(context),
                ],
              ),

              const SizedBox(height: 12),

              // Type and Description
              Text(
                workOrder.type.getDisplayName(context),
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
                  color: Colors.white.withValues(alpha: 0.7),
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
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    workOrder.cartId,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  if (workOrder.location != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        workOrder.location!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
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
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      workOrder.technician!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const Spacer(),
                  ],

                  // Time info
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTimeInfo(context),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  ViaStatus _mapWorkOrderStatusToViaStatus(WorkOrderStatus status) {
    switch (status) {
      case WorkOrderStatus.draft:
        return ViaStatus.idle;
      case WorkOrderStatus.pending:
        return ViaStatus.idle;
      case WorkOrderStatus.inProgress:
        return ViaStatus.active;
      case WorkOrderStatus.onHold:
        return ViaStatus.maintenance;
      case WorkOrderStatus.completed:
        return ViaStatus.active;
      case WorkOrderStatus.cancelled:
        return ViaStatus.offline;
    }
  }

  Widget _buildAgeIndicator(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final now = DateTime.now();
    final age = now.difference(workOrder.createdAt);

    Color color;
    String text;

    if (age.inDays > 0) {
      color = Colors.red;
      text = '${age.inDays}${localizations.woTimeDays}';
    } else if (age.inHours > 0) {
      color = Colors.orange;
      text = '${age.inHours}${localizations.woTimeHours}';
    } else {
      color = Colors.green;
      text = '${age.inMinutes}${localizations.woTimeMinutes}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
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

  String _formatTimeInfo(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final now = DateTime.now();
    final age = now.difference(workOrder.createdAt);

    if (age.inDays > 0) {
      return '${age.inDays}${localizations.woTimeDays} ${localizations.woTimeAgo}';
    } else if (age.inHours > 0) {
      return '${age.inHours}${localizations.woTimeHours} ${localizations.woTimeAgo}';
    } else {
      return '${age.inMinutes}${localizations.woTimeMinutes} ${localizations.woTimeAgo}';
    }
  }

}
