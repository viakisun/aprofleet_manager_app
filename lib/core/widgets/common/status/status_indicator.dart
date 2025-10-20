import 'package:flutter/material.dart';
import '../../../../domain/models/cart.dart';
import '../../../../domain/models/work_order.dart';
import '../../../../domain/models/alert.dart';
import '../../../theme/design_tokens.dart';

/// A reusable status indicator widget that displays status with color coding
class StatusIndicator extends StatelessWidget {
  final String status;
  final Color color;
  final bool showText;
  final bool isCompact;

  const StatusIndicator({
    super.key,
    required this.status,
    required this.color,
    this.showText = true,
    this.isCompact = false,
  });

  /// Factory constructor for cart status
  factory StatusIndicator.cartStatus({
    required CartStatus status,
    bool showText = true,
    bool isCompact = false,
  }) {
    final color = DesignTokens.getStatusColor(status.name);
    return StatusIndicator(
      status: status.displayName,
      color: color,
      showText: showText,
      isCompact: isCompact,
    );
  }

  /// Factory constructor for work order priority
  factory StatusIndicator.priority({
    required Priority priority,
    bool showText = true,
  }) {
    final color = DesignTokens.getPriorityColor(priority.name);
    return StatusIndicator(
      status: priority.displayName,
      color: color,
      showText: showText,
    );
  }

  /// Factory constructor for alert severity
  factory StatusIndicator.alertSeverity({
    required AlertSeverity severity,
    bool showText = true,
  }) {
    final color = DesignTokens.getAlertColor(severity.name);
    return StatusIndicator(
      status: severity.displayName,
      color: color,
      showText: showText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Color indicator bar - Sharper corners
        Container(
          width: isCompact ? 2 : 3, // Thinner for cleaner look
          height: isCompact ? 12 : 16, // Shorter for compact design
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1), // Sharper corners
          ),
        ),
        if (showText) ...[
          const SizedBox(width: DesignTokens.spacingSm),
          Text(
            status.toUpperCase(),
            style: DesignTokens.getUppercaseLabelStyle(
              fontSize:
                  isCompact ? DesignTokens.fontSizeXs : DesignTokens.fontSizeSm,
              fontWeight: DesignTokens.fontWeightBold, // Bolder for hierarchy
              color: color,
            ),
          ),
        ],
      ],
    );
  }
}
