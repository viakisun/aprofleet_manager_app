import 'package:flutter/material.dart';
import '../../../domain/models/alert.dart';
import '../../../domain/models/work_order.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/industrial_dark_tokens.dart';
import '../../../core/widgets/via/via_priority_badge.dart';

/// Compact Alert Card - Redesigned for maximum information density
///
/// Height: ~60-70px (vs original ~140-160px)
/// Action buttons moved to detail bottom sheet
/// Single-row layout with chevron for expansion
class AlertCompactCard extends StatelessWidget {
  final Alert alert;
  final VoidCallback onTap;

  const AlertCompactCard({
    super.key,
    required this.alert,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final severityColor = AppConstants.alertColors[alert.severity] ?? IndustrialDarkTokens.textSecondary;
    final isUnread = alert.state == AlertStatus.triggered || alert.state == AlertStatus.notified;

    return Container(
      margin: const EdgeInsets.only(bottom: IndustrialDarkTokens.spacingCompact),
      decoration: BoxDecoration(
        color: IndustrialDarkTokens.bgBase,
        borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
        border: Border.all(
          color: isUnread
              ? severityColor.withValues(alpha: 0.3)
              : IndustrialDarkTokens.outline,
          width: isUnread ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: IndustrialDarkTokens.spacingItem,
              vertical: IndustrialDarkTokens.spacingCompact,
            ),
            child: Row(
              children: [
                // Severity indicator bar
                Container(
                  width: 3,
                  height: 48,
                  decoration: BoxDecoration(
                    color: severityColor,
                    borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
                  ),
                ),

                const SizedBox(width: IndustrialDarkTokens.spacingCompact),

                // Priority badge
                ViaPriorityBadge(
                  priority: _mapAlertPriorityToViaPriority(alert.priority),
                  size: ViaPriorityBadgeSize.compact,
                ),

                const SizedBox(width: IndustrialDarkTokens.spacingCompact),

                // Alert content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              alert.title,
                              style: TextStyle(
                                fontSize: IndustrialDarkTokens.fontSizeBody,
                                fontWeight: isUnread
                                    ? IndustrialDarkTokens.fontWeightBold
                                    : IndustrialDarkTokens.fontWeightBold,
                                color: IndustrialDarkTokens.textPrimary,
                                letterSpacing: IndustrialDarkTokens.letterSpacing,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isUnread) ...[
                            const SizedBox(width: IndustrialDarkTokens.spacingCompact),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: severityColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 2),

                      // Meta information row
                      Row(
                        children: [
                          if (alert.cartId != null) ...[
                            Icon(
                              Icons.directions_car,
                              size: 12,
                              color: IndustrialDarkTokens.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              alert.cartId!,
                              style: TextStyle(
                                fontSize: IndustrialDarkTokens.fontSizeSmall,
                                color: IndustrialDarkTokens.textSecondary,
                                letterSpacing: IndustrialDarkTokens.letterSpacing,
                              ),
                            ),
                          ],
                          if (alert.cartId != null && alert.location != null) ...[
                            const SizedBox(width: IndustrialDarkTokens.spacingCompact),
                            Text(
                              '•',
                              style: TextStyle(
                                fontSize: IndustrialDarkTokens.fontSizeSmall,
                                color: IndustrialDarkTokens.textSecondary,
                              ),
                            ),
                            const SizedBox(width: IndustrialDarkTokens.spacingCompact),
                          ],
                          if (alert.location != null)
                            Expanded(
                              child: Text(
                                alert.location!,
                                style: TextStyle(
                                  fontSize: IndustrialDarkTokens.fontSizeSmall,
                                  color: IndustrialDarkTokens.textSecondary,
                                  letterSpacing: IndustrialDarkTokens.letterSpacing,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: IndustrialDarkTokens.spacingCompact),

                // Time ago
                Text(
                  _formatTimeAgo(alert.createdAt, context),
                  style: TextStyle(
                    fontSize: IndustrialDarkTokens.fontSizeSmall,
                    color: IndustrialDarkTokens.textSecondary,
                    letterSpacing: IndustrialDarkTokens.letterSpacing,
                  ),
                ),

                const SizedBox(width: IndustrialDarkTokens.spacingCompact),

                // Chevron
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: IndustrialDarkTokens.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ViaPriority _mapAlertPriorityToViaPriority(Priority priority) {
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
