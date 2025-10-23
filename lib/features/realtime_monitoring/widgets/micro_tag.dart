import 'package:flutter/material.dart';
import '../../../core/theme/via_design_tokens.dart';

/// VIA Design System Micro Tag for Map Markers
///
/// Displays cart ID with optional battery/charging badge
class MicroTag extends StatelessWidget {
  final String id;
  final String? badge; // "25%" or "Charging"

  const MicroTag({
    super.key,
    required this.id,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ViaDesignTokens.surfacePrimary.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
        border: Border.all(
          color: ViaDesignTokens.borderPrimary,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ViaDesignTokens.spacingMd,
          vertical: ViaDesignTokens.spacingXs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              id,
              style: ViaDesignTokens.labelMedium.copyWith(
                color: ViaDesignTokens.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: ViaDesignTokens.spacingSm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ViaDesignTokens.spacingXs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _getBadgeColor(badge!),
                  borderRadius: BorderRadius.circular(ViaDesignTokens.radiusSm),
                ),
                child: Text(
                  badge!,
                  style: ViaDesignTokens.labelSmall.copyWith(
                    color: Colors.white,
                    fontSize: ViaDesignTokens.fontSizeXxs,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getBadgeColor(String badge) {
    // "Charging" -> blue
    if (badge.toLowerCase().contains('charg')) {
      return ViaDesignTokens.statusCharging;
    }

    // Battery percentage
    final percentMatch = RegExp(r'(\d+)%').firstMatch(badge);
    if (percentMatch != null) {
      final percent = int.parse(percentMatch.group(1)!);
      if (percent <= 30) {
        return ViaDesignTokens.critical;
      }
    }

    // Default: muted
    return ViaDesignTokens.textMuted;
  }
}
