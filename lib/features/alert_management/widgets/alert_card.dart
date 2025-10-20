import 'package:flutter/material.dart';

import '../../../domain/models/alert.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/design_tokens.dart';

class AlertNotificationCard extends StatelessWidget {
  final Alert alert;
  final VoidCallback onTap;
  final VoidCallback onAcknowledge;
  final VoidCallback onViewCart;
  final VoidCallback onCreateWorkOrder;

  const AlertNotificationCard({
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
    final isUnread = alert.state == AlertStatus.triggered ||
        alert.state == AlertStatus.notified;

    return Container(
      margin: const EdgeInsets.only(bottom: 8), // Tighter spacing
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg), // Sharper corners
        border: Border.all(
          color: DesignTokens.borderPrimary, // More subtle border
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLg), // Sharper corners
        child: Padding(
          padding: const EdgeInsets.all(12), // Tighter padding
          child: Row(
            children: [
              // Severity indicator bar - Sharper corners
              Container(
                width: 3, // Thinner for cleaner look
                height: 48, // Shorter for compact design
                decoration: BoxDecoration(
                  color: severityColor,
                  borderRadius: BorderRadius.circular(1), // Sharper corners
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
                                  isUnread ? FontWeight.w700 : FontWeight.w700, // Bolder for hierarchy
                              color: Colors.white,
                              letterSpacing: DesignTokens.letterSpacingNormal, // Tighter tracking
                            ),
                          ),
                        ),
                        PriorityIndicator(priority: alert.priority),
                        if (isUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 6), // Tighter spacing

                    // Message
                    Text(
                      alert.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8), // Tighter spacing

                    // Meta information
                    Row(
                      children: [
                        if (alert.cartId != null) ...[
                          Icon(
                            Icons.directions_car,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            alert.cartId!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (alert.location != null) ...[
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              alert.location!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          _formatTimeAgo(alert.createdAt, context),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.5),
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
                    tooltip: AppLocalizations.of(context).alertAcknowledge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.directions_car, size: 20),
                    color: Colors.blue,
                    onPressed: onViewCart,
                    tooltip: AppLocalizations.of(context).alertViewCart,
                  ),
                  IconButton(
                    icon: const Icon(Icons.build, size: 20),
                    color: Colors.orange,
                    onPressed: onCreateWorkOrder,
                    tooltip: AppLocalizations.of(context).alertCreateWorkOrder,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime, BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}${localizations.alertTimeDaysAgo}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}${localizations.alertTimeHoursAgo}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}${localizations.alertTimeMinutesAgo}';
    } else {
      return localizations.alertTimeJustNow;
    }
  }
}
