import 'package:flutter/material.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../domain/models/cart.dart';

class MapCartMarker extends StatelessWidget {
  final Cart cart;
  final double scale;
  final VoidCallback? onTap;

  const MapCartMarker({
    super.key,
    required this.cart,
    this.scale = 1.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = DesignTokens.getStatusColor(cart.status.name);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: scale,
        duration: DesignTokens.animationFast,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: statusColor.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: DesignTokens.bgPrimary.withValues(alpha: 0.8),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Outer ring for glow effect
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
              ),

              // Inner circle
              Center(
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: DesignTokens.textPrimary,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      cart.id.split('-').last,
                      style: const TextStyle(
                        color: DesignTokens.textPrimary,
                        fontSize: DesignTokens.fontSizeXs,
                        fontWeight: DesignTokens.fontWeightBold,
                      ),
                    ),
                  ),
                ),
              ),

              // Status indicator dot
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: DesignTokens.textPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: statusColor,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapCartPopup extends StatelessWidget {
  final Cart cart;
  final VoidCallback? onDetail;
  final VoidCallback? onTrack;

  const MapCartPopup({
    super.key,
    required this.cart,
    this.onDetail,
    this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = DesignTokens.getStatusColor(cart.status.name);

    return Container(
      width: 280,
      decoration: DesignTokens.getCardDecoration(
        elevation: DesignTokens.elevationLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(DesignTokens.radiusMd),
                topRight: Radius.circular(DesignTokens.radiusMd),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cart.id,
                        style: const TextStyle(
                          fontSize: DesignTokens.fontSizeLg,
                          fontWeight: DesignTokens.fontWeightBold,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                      Text(
                        cart.status.displayName,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: statusColor,
                          fontWeight: DesignTokens.fontWeightMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMd),
            child: Column(
              children: [
                // Telemetry info
                Row(
                  children: [
                    Expanded(
                      child: _buildTelemetryItem(
                        'BATTERY',
                        '${(cart.batteryLevel ?? 0).toInt()}%',
                        DesignTokens.statusActive,
                      ),
                    ),
                    Expanded(
                      child: _buildTelemetryItem(
                        'SPEED',
                        '${(cart.speed ?? 0).toInt()} km/h',
                        DesignTokens.statusIdle,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: DesignTokens.spacingMd),

                // Location info
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: DesignTokens.iconSm,
                      color: DesignTokens.textSecondary,
                    ),
                    const SizedBox(width: DesignTokens.spacingSm),
                    Expanded(
                      child: Text(
                        cart.location ?? 'Unknown Location',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: DesignTokens.spacingMd),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        text: 'Detail',
                        type: ActionButtonType.secondary,
                        icon: Icons.info_outline,
                        onPressed: onDetail,
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingSm),
                    Expanded(
                      child: ActionButton(
                        text: 'Track',
                        type: ActionButtonType.primary,
                        icon: Icons.my_location,
                        onPressed: onTrack,
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

  Widget _buildTelemetryItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: DesignTokens.getUppercaseLabelStyle(
            fontSize: DesignTokens.fontSizeXs,
            color: DesignTokens.textTertiary,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingXs),
        Text(
          value,
          style: TextStyle(
            fontSize: DesignTokens.fontSizeLg,
            fontWeight: DesignTokens.fontWeightBold,
            color: color,
          ),
        ),
      ],
    );
  }
}
