import 'package:flutter/material.dart';
import '../../../domain/models/cart.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/custom_icons.dart';
import '../../../core/theme/design_tokens.dart';

class CartGridItem extends StatelessWidget {
  final Cart cart;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CartGridItem({
    super.key,
    required this.cart,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = DesignTokens.getStatusColor(cart.status.name);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: DesignTokens.bgSecondary,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
          border: Border.all(
            color: isSelected
                ? DesignTokens.statusMaintenance
                : DesignTokens.borderPrimary,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
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
                    child: Text(
                      cart.id,
                      style: const TextStyle(
                        fontSize: DesignTokens.fontSizeSm,
                        fontWeight: DesignTokens.fontWeightBold,
                        color: DesignTokens.textPrimary,
                        letterSpacing: DesignTokens.letterSpacingWide,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: DesignTokens.spacingSm),

              // Model
              Text(
                cart.model,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeSm,
                  fontWeight: DesignTokens.fontWeightMedium,
                  color: DesignTokens.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: DesignTokens.spacingSm),

              // Status
              CartStatusChip(status: cart.status, isCompact: true),

              const Spacer(),

              // Telemetry
              Row(
                children: [
                  Icon(
                    CustomIcons.battery,
                    size: CustomIcons.iconSm,
                    color: (cart.batteryPct ?? 0) > 50
                        ? DesignTokens.statusActive
                        : (cart.batteryPct ?? 0) > 20
                            ? DesignTokens.statusWarning
                            : DesignTokens.statusCritical,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(cart.batteryPct ?? 0).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeXs,
                      fontWeight: DesignTokens.fontWeightSemibold,
                      color: (cart.batteryPct ?? 0) > 50
                          ? DesignTokens.statusActive
                          : (cart.batteryPct ?? 0) > 20
                              ? DesignTokens.statusWarning
                              : DesignTokens.statusCritical,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    CustomIcons.activity,
                    size: CustomIcons.iconSm,
                    color: DesignTokens.textSecondary,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${(cart.speedKph ?? 0).toStringAsFixed(0)}km/h',
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeXs,
                      fontWeight: DesignTokens.fontWeightSemibold,
                      color: DesignTokens.textSecondary,
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
}
