import 'package:flutter/material.dart';

import '../../../domain/models/work_order.dart';
import '../../../core/widgets/via/via_card.dart';
import '../../../core/widgets/via/via_priority_badge.dart';
import '../../../core/widgets/via/via_status_badge.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

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
                        fontSize: IndustrialDarkTokens.fontSizeBody,
                        fontWeight: IndustrialDarkTokens.fontWeightBold,
                        color: IndustrialDarkTokens.textPrimary,
                        letterSpacing: IndustrialDarkTokens.letterSpacing,
                      ),
                    ),
                    const SizedBox(height: IndustrialDarkTokens.spacingMinimal),
                    Row(
                      children: [
                        ViaPriorityBadge(
                            priority:
                                _mapPriorityToViaPriority(workOrder.priority)),
                        const SizedBox(
                            width: IndustrialDarkTokens.spacingCompact),
                        ViaStatusBadge(
                          status:
                              _mapWorkOrderStatusToViaStatus(workOrder.status),
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

          const SizedBox(height: IndustrialDarkTokens.spacingItem),

          // Type and Description
          Text(
            workOrder.type.getDisplayName(context),
            style: const TextStyle(
              fontSize: IndustrialDarkTokens.fontSizeLabel,
              fontWeight: IndustrialDarkTokens.fontWeightBold,
              color: IndustrialDarkTokens.textPrimary,
              letterSpacing: IndustrialDarkTokens.letterSpacing,
            ),
          ),
          const SizedBox(height: IndustrialDarkTokens.spacingMinimal),
          Text(
            workOrder.description,
            style: const TextStyle(
              fontSize: IndustrialDarkTokens.fontSizeSmall,
              color: IndustrialDarkTokens.textSecondary,
              letterSpacing: IndustrialDarkTokens.letterSpacing,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingItem),

          // Cart and Location Info
          Row(
            children: [
              const Icon(
                Icons.directions_car,
                size: 16,
                color: IndustrialDarkTokens.textSecondary,
              ),
              const SizedBox(width: IndustrialDarkTokens.spacingMinimal),
              Text(
                workOrder.cartId,
                style: const TextStyle(
                  fontSize: IndustrialDarkTokens.fontSizeSmall,
                  fontWeight: IndustrialDarkTokens.fontWeightBold,
                  color: IndustrialDarkTokens.textSecondary,
                  letterSpacing: IndustrialDarkTokens.letterSpacing,
                ),
              ),
              if (workOrder.location != null) ...[
                const SizedBox(width: IndustrialDarkTokens.spacingCompact),
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: IndustrialDarkTokens.textSecondary,
                ),
                const SizedBox(width: IndustrialDarkTokens.spacingMinimal),
                Expanded(
                  child: Text(
                    workOrder.location!,
                    style: const TextStyle(
                      fontSize: IndustrialDarkTokens.fontSizeSmall,
                      color: IndustrialDarkTokens.textSecondary,
                      letterSpacing: IndustrialDarkTokens.letterSpacing,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: IndustrialDarkTokens.spacingCompact),

          // Technician and Time Info
          Row(
            children: [
              if (workOrder.technician != null) ...[
                const Icon(
                  Icons.person,
                  size: 16,
                  color: IndustrialDarkTokens.textSecondary,
                ),
                const SizedBox(width: IndustrialDarkTokens.spacingMinimal),
                Text(
                  workOrder.technician!,
                  style: const TextStyle(
                    fontSize: IndustrialDarkTokens.fontSizeSmall,
                    color: IndustrialDarkTokens.textSecondary,
                    letterSpacing: IndustrialDarkTokens.letterSpacing,
                  ),
                ),
                const Spacer(),
              ],

              // Time info
              const Icon(
                Icons.access_time,
                size: 16,
                color: IndustrialDarkTokens.textSecondary,
              ),
              const SizedBox(width: IndustrialDarkTokens.spacingMinimal),
              Text(
                _formatTimeInfo(context),
                style: const TextStyle(
                  fontSize: IndustrialDarkTokens.fontSizeSmall,
                  color: IndustrialDarkTokens.textSecondary,
                  letterSpacing: IndustrialDarkTokens.letterSpacing,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ViaPriority _mapPriorityToViaPriority(Priority priority) {
    switch (priority) {
      case Priority.p1:
        return ViaPriority.p1;
      case Priority.p2:
        return ViaPriority.p2;
      case Priority.p3:
        return ViaPriority.p3;
      case Priority.p4:
        return ViaPriority.p4;
    }
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
