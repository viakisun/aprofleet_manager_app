import 'package:flutter/material.dart';
import '../../../core/theme/industrial_dark_tokens.dart';

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
        color: IndustrialDarkTokens.bgBase.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
        border: Border.all(
          color: IndustrialDarkTokens.outline,
          width: IndustrialDarkTokens.borderWidth, // 2px for Material Design 3
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
          horizontal: IndustrialDarkTokens.spacingItem,
          vertical: IndustrialDarkTokens.spacingCompact,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              id,
              style: IndustrialDarkTokens.labelStyle.copyWith(
                color: IndustrialDarkTokens.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: IndustrialDarkTokens.spacingCompact),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: IndustrialDarkTokens.spacingCompact,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _getBadgeColor(badge!),
                  borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
                ),
                child: Text(
                  badge!,
                  style: IndustrialDarkTokens.labelStyle.copyWith(
                    color: Colors.white,
                    fontSize: 10,
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
      return IndustrialDarkTokens.statusCharging;
    }

    // Battery percentage
    final percentMatch = RegExp(r'(\d+)%').firstMatch(badge);
    if (percentMatch != null) {
      final percent = int.parse(percentMatch.group(1)!);
      if (percent <= 30) {
        return IndustrialDarkTokens.error;
      }
    }

    // Default: muted
    return IndustrialDarkTokens.textSecondary;
  }
}
