import 'package:flutter/material.dart';

import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../domain/models/cart.dart';
import '../../auth/widgets/cart_icon.dart';

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
    final statusColor = IndustrialDarkTokens.getStatusColor(cart.status.name);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: scale,
        duration: IndustrialDarkTokens.durationFast,
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
                color: IndustrialDarkTokens.bgBase.withValues(alpha: 0.8),
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

              // Custom cart icon
              const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CartIcon(
                    size: 20,
                    color: Colors.white,
                    showDirection: true,
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
                    color: IndustrialDarkTokens.textPrimary,
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
    final statusColor = IndustrialDarkTokens.getStatusColor(cart.status.name);

    return Container(
      width: 280,
      decoration: IndustrialDarkTokens.getCardDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(IndustrialDarkTokens.radiusButton),
                topRight: Radius.circular(IndustrialDarkTokens.radiusButton),
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
                const SizedBox(width: IndustrialDarkTokens.spacingCompact),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cart.id,
                        style: const TextStyle(
                          fontSize: IndustrialDarkTokens.fontSizeBody,
                          fontWeight: IndustrialDarkTokens.fontWeightBold,
                          color: IndustrialDarkTokens.textPrimary,
                        ),
                      ),
                      Text(
                        cart.status.displayName,
                        style: TextStyle(
                          fontSize: IndustrialDarkTokens.fontSizeSmall,
                          color: statusColor,
                          fontWeight: IndustrialDarkTokens.fontWeightMedium,
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
            padding: const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
            child: Column(
              children: [
                // Telemetry info
                Row(
                  children: [
                    Expanded(
                      child: _buildTelemetryItem(
                        'BATTERY',
                        '${(cart.batteryLevel ?? 0).toInt()}%',
                        IndustrialDarkTokens.statusActive,
                      ),
                    ),
                    Expanded(
                      child: _buildTelemetryItem(
                        'SPEED',
                        '${(cart.speed ?? 0).toInt()} km/h',
                        IndustrialDarkTokens.statusIdle,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: IndustrialDarkTokens.spacingItem),

                // Location info
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: IndustrialDarkTokens.textSecondary,
                    ),
                    const SizedBox(width: IndustrialDarkTokens.spacingCompact),
                    Expanded(
                      child: Text(
                        cart.location ?? 'Unknown Location',
                        style: const TextStyle(
                          fontSize: IndustrialDarkTokens.fontSizeSmall,
                          color: IndustrialDarkTokens.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: IndustrialDarkTokens.spacingItem),

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
                    const SizedBox(width: IndustrialDarkTokens.spacingCompact),
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
          style: IndustrialDarkTokens.getUppercaseLabelStyle(
            fontSize: 10,
            color: IndustrialDarkTokens.textSecondary,
          ),
        ),
        const SizedBox(height: IndustrialDarkTokens.spacingMinimal),
        Text(
          value,
          style: TextStyle(
            fontSize: IndustrialDarkTokens.fontSizeBody,
            fontWeight: IndustrialDarkTokens.fontWeightBold,
            color: color,
          ),
        ),
      ],
    );
  }
}
