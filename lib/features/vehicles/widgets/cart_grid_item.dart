import 'package:flutter/material.dart';
import '../../../domain/models/cart.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/widgets/custom_icons.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

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
    final statusColor = IndustrialDarkTokens.getStatusColor(cart.status.name);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: IndustrialDarkTokens.bgSurface,
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          border: Border.all(
            color: isSelected
                ? IndustrialDarkTokens.statusMaintenance
                : IndustrialDarkTokens.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(IndustrialDarkTokens.spacingCard),
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
                  const SizedBox(width: IndustrialDarkTokens.spacingCompact),
                  Expanded(
                    child: Text(
                      cart.id,
                      style: const TextStyle(
                        fontSize: IndustrialDarkTokens.fontSizeSmall,
                        fontWeight: IndustrialDarkTokens.fontWeightBold,
                        color: IndustrialDarkTokens.textPrimary,
                        letterSpacing: IndustrialDarkTokens.letterSpacing,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: IndustrialDarkTokens.spacingCompact),

              // Model
              Text(
                cart.model,
                style: TextStyle(
                  fontSize: IndustrialDarkTokens.fontSizeSmall,
                  fontWeight: IndustrialDarkTokens.fontWeightMedium,
                  color: IndustrialDarkTokens.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: IndustrialDarkTokens.spacingCompact),

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
                        ? IndustrialDarkTokens.statusActive
                        : (cart.batteryPct ?? 0) > 20
                            ? IndustrialDarkTokens.warning
                            : IndustrialDarkTokens.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${(cart.batteryPct ?? 0).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: IndustrialDarkTokens.fontWeightBold,
                      color: (cart.batteryPct ?? 0) > 50
                          ? IndustrialDarkTokens.statusActive
                          : (cart.batteryPct ?? 0) > 20
                              ? IndustrialDarkTokens.warning
                              : IndustrialDarkTokens.error,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    CustomIcons.activity,
                    size: CustomIcons.iconSm,
                    color: IndustrialDarkTokens.textSecondary,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${(cart.speedKph ?? 0).toStringAsFixed(0)}km/h',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: IndustrialDarkTokens.fontWeightBold,
                      color: IndustrialDarkTokens.textSecondary,
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
