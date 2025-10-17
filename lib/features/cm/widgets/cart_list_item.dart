import 'package:flutter/material.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/custom_icons.dart';
import '../../../domain/models/cart.dart';

class CartListItem extends StatelessWidget {
  final Cart cart;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final List<Widget>? actions;

  const CartListItem({
    super.key,
    required this.cart,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = DesignTokens.getStatusColor(cart.status.name);

    return Container(
      margin: const EdgeInsets.only(bottom: DesignTokens.spacingLg),
      decoration: BoxDecoration(
        color: isSelected ? DesignTokens.bgQuaternary : DesignTokens.bgTertiary,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
        border: Border.all(
          color: isSelected
              ? statusColor.withOpacity(0.3)
              : DesignTokens.borderPrimary,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    // Status indicator stripe
                    Container(
                      width: 6,
                      height: 48,
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: DesignTokens.spacingMd),

                    // Cart info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cart.id,
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeLg,
                              fontWeight: DesignTokens.fontWeightBold,
                              color: DesignTokens.textPrimary,
                            ),
                          ),
                          const SizedBox(height: DesignTokens.spacingXs),
                          Text(
                            '${cart.manufacturer} ${cart.model}',
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeSm,
                              color: DesignTokens.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status chip
                    CartStatusChip(
                      status: cart.status,
                      isCompact: true,
                    ),

                    if (actions != null) ...[
                      const SizedBox(width: DesignTokens.spacingSm),
                      ...actions!,
                    ],
                  ],
                ),

                const SizedBox(height: DesignTokens.spacingLg),

                // Metrics row
                Row(
                  children: [
                    // Battery level
                    Expanded(
                      child: _buildMetricItem(
                        icon: CustomIcons.battery,
                        label: 'BATTERY',
                        value: '${(cart.batteryLevel ?? 0).toInt()}%',
                        color: _getBatteryColor(cart.batteryLevel ?? 0),
                      ),
                    ),

                    // Speed
                    Expanded(
                      child: _buildMetricItem(
                        icon: CustomIcons.activity,
                        label: 'SPEED',
                        value: '${(cart.speed ?? 0).toInt()} km/h',
                        color: DesignTokens.statusIdle,
                      ),
                    ),

                    // Odometer
                    Expanded(
                      child: _buildMetricItem(
                        icon: CustomIcons.activity,
                        label: 'ODOMETER',
                        value: '${(cart.odometer ?? 0).toInt()} km',
                        color: DesignTokens.textSecondary,
                      ),
                    ),
                  ],
                ),

                if (cart.location != null) ...[
                  const SizedBox(height: DesignTokens.spacingSm),
                  Row(
                    children: [
                      Icon(
                        CustomIcons.location,
                        size: CustomIcons.iconSm,
                        color: DesignTokens.textSecondary,
                      ),
                      const SizedBox(width: DesignTokens.spacingXs),
                      Expanded(
                        child: Text(
                          cart.location!,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeSm,
                            color: DesignTokens.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingSm,
        vertical: DesignTokens.spacingXs,
      ),
      decoration: BoxDecoration(
        color: DesignTokens.bgSecondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        border: Border.all(
          color: DesignTokens.borderPrimary.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: CustomIcons.iconMd,
            color: color,
          ),
          const SizedBox(width: DesignTokens.spacingXs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: DesignTokens.getUppercaseLabelStyle(
                    fontSize: DesignTokens.fontSizeXs,
                    color: DesignTokens.textTertiary,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    fontWeight: DesignTokens.fontWeightSemibold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBatteryColor(double batteryLevel) {
    if (batteryLevel > 50) {
      return DesignTokens.statusActive;
    } else if (batteryLevel > 20) {
      return DesignTokens.statusIdle;
    } else {
      return DesignTokens.statusMaintenance;
    }
  }
}
