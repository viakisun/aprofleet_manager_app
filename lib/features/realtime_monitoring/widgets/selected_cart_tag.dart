import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/pulse_effect.dart';
import '../../../domain/models/cart.dart';

class SelectedCartTag extends StatelessWidget {
  final Cart selectedCart;
  final VoidCallback onClose;

  const SelectedCartTag({
    super.key,
    required this.selectedCart,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: DesignTokens.bgSecondary.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          border: Border.all(
            color: DesignTokens.statusActive,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Status icon with pulse effect
            PulseEffect(
              pulseColor: _getCartStatusColor(selectedCart.status),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getCartStatusColor(selectedCart.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                ),
                child: Icon(
                  _getCartStatusIcon(selectedCart.status),
                  size: 20,
                  color: _getCartStatusColor(selectedCart.status),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Cart info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCart.id,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: DesignTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        selectedCart.model ?? 'Unknown Model',
                        style: TextStyle(
                          fontSize: 14,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        LucideIcons.battery,
                        size: 14,
                        color: _getBatteryColor(selectedCart.batteryPct),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${selectedCart.batteryPct?.toStringAsFixed(0) ?? '0'}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: _getBatteryColor(selectedCart.batteryPct),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        LucideIcons.gauge,
                        size: 14,
                        color: DesignTokens.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${selectedCart.speedKph?.toStringAsFixed(0) ?? '0'}km/h',
                        style: TextStyle(
                          fontSize: 14,
                          color: DesignTokens.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Close button
            GestureDetector(
              onTap: onClose,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: DesignTokens.bgTertiary.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
                child: Icon(
                  LucideIcons.x,
                  size: 16,
                  color: DesignTokens.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCartStatusIcon(CartStatus status) {
    switch (status) {
      case CartStatus.active:
        return LucideIcons.playCircle;
      case CartStatus.idle:
        return LucideIcons.pauseCircle;
      case CartStatus.charging:
        return LucideIcons.batteryCharging;
      case CartStatus.maintenance:
        return LucideIcons.wrench;
      case CartStatus.offline:
        return LucideIcons.wifiOff;
      default:
        return LucideIcons.helpCircle;
    }
  }

  Color _getCartStatusColor(CartStatus status) {
    switch (status) {
      case CartStatus.active:
        return Colors.green;
      case CartStatus.idle:
        return Colors.orange;
      case CartStatus.charging:
        return Colors.blue;
      case CartStatus.maintenance:
        return Colors.purple;
      case CartStatus.offline:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getBatteryColor(double? batteryPct) {
    if (batteryPct == null) return Colors.grey;
    if (batteryPct > 50) return Colors.green;
    if (batteryPct > 20) return Colors.orange;
    return Colors.red;
  }
}
