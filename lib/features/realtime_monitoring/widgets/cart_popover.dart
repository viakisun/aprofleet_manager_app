import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../domain/models/cart.dart';
import '../../../core/constants/app_constants.dart';

class CartPopover extends StatelessWidget {
  final Cart cart;
  final bool cartListOnRight;
  final VoidCallback onClose;
  final VoidCallback onDetails;
  final VoidCallback onTrack;

  const CartPopover({
    super.key,
    required this.cart,
    required this.cartListOnRight,
    required this.onClose,
    required this.onDetails,
    required this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final statusColor = AppConstants.statusColors[cart.status] ?? Colors.grey;

    return Positioned(
      top: 100,
      left: cartListOnRight ? 16 : 260,
      right: cartListOnRight ? 260 : 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          border: Border.all(
            color: DesignTokens.borderPrimary,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    cart.id,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: DesignTokens.letterSpacingNormal,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: onClose,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Cart Info
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cart.model,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: DesignTokens.letterSpacingNormal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cart.location?.toString() ?? 'Unknown Location',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                CartStatusChip(status: cart.status),
              ],
            ),
            const SizedBox(height: 12),
            // Telemetry Info
            Row(
              children: [
                Expanded(
                  child: TelemetryWidget(
                    label: 'Battery',
                    value: cart.batteryPct ?? 0.0,
                    unit: '%',
                    color: (cart.batteryPct ?? 0) > 50
                        ? Colors.green
                        : (cart.batteryPct ?? 0) > 20
                            ? Colors.orange
                            : Colors.red,
                    isCompact: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TelemetryWidget(
                    label: 'Speed',
                    value: cart.speedKph ?? 0.0,
                    unit: 'km/h',
                    isCompact: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    text: localizations.details,
                    onPressed: () {
                      context.go('/rt/cart/${cart.id}');
                      onClose();
                    },
                    type: ActionButtonType.secondary,
                    icon: Icons.info_outline,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ActionButton(
                    text: localizations.track,
                    onPressed: () {
                      onTrack();
                      onClose();
                    },
                    type: ActionButtonType.primary,
                    icon: Icons.my_location,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

