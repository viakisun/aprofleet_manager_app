import 'package:flutter/material.dart';
import '../../theme/industrial_dark_tokens.dart';

/// Industrial Dark - Stat Chip Component
///
/// A compact chip displaying a statistic with a colored indicator.
/// Used in control bars to show summary counts and allow filtering.
///
/// Example:
/// ```dart
/// ViaStatChip(
///   label: 'Critical',
///   count: 3,
///   color: IndustrialDarkTokens.error,
///   isActive: true,
///   onTap: () => controller.setFilter('critical'),
/// )
/// ```
class ViaStatChip extends StatelessWidget {
  /// The label text (e.g., "Critical", "Pending")
  final String label;

  /// The count to display
  final int count;

  /// The color for the indicator dot and text
  final Color color;

  /// Whether this chip is in active/selected state
  final bool isActive;

  /// Callback when chip is tapped
  final VoidCallback? onTap;

  /// Size variant
  final ViaStatChipSize size;

  const ViaStatChip({
    super.key,
    required this.label,
    required this.count,
    required this.color,
    this.isActive = false,
    this.onTap,
    this.size = ViaStatChipSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final chipPadding = _getPadding();
    final labelFontSize = _getLabelFontSize();
    final countFontSize = _getCountFontSize();
    final dotSize = _getDotSize();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: chipPadding,
        decoration: BoxDecoration(
          color: isActive
              ? color.withValues(alpha: 0.18) // VIA elegant: 0.25 → 0.18
              : color.withValues(alpha: 0.10), // VIA elegant: 0.15 → 0.10
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusChip),
          border: Border.all(
            color: isActive
                ? color.withValues(alpha: 0.35) // VIA elegant: 0.50 → 0.35
                : color.withValues(alpha: 0.20), // VIA elegant: 0.30 → 0.20
            width: isActive
                ? IndustrialDarkTokens.borderWidth
                : IndustrialDarkTokens.borderWidthThin,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color indicator dot
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: size == ViaStatChipSize.small ? 4 : 6),

            // Label
            Text(
              label,
              style: TextStyle(
                color: isActive ? color : color.withValues(alpha: 0.8),
                fontSize: labelFontSize,
                fontWeight: isActive
                    ? IndustrialDarkTokens.fontWeightBold
                    : IndustrialDarkTokens.fontWeightMedium,
                letterSpacing: IndustrialDarkTokens.letterSpacing,
              ),
            ),
            SizedBox(width: size == ViaStatChipSize.small ? 4 : 6),

            // Count
            Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontSize: countFontSize,
                fontWeight: IndustrialDarkTokens.fontWeightBold,
                letterSpacing: IndustrialDarkTokens.letterSpacing,
              ),
            ),
          ],
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ViaStatChipSize.small:
        return const EdgeInsets.symmetric(
          horizontal: IndustrialDarkTokens.spacingCompact,
          vertical: 4,
        );
      case ViaStatChipSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: IndustrialDarkTokens.spacingCompact,
          vertical: IndustrialDarkTokens.spacingMinimal,
        );
      case ViaStatChipSize.large:
        return const EdgeInsets.symmetric(
          horizontal: IndustrialDarkTokens.spacingItem,
          vertical: IndustrialDarkTokens.spacingCompact,
        );
    }
  }

  double _getLabelFontSize() {
    switch (size) {
      case ViaStatChipSize.small:
        return 10; // Smaller label
      case ViaStatChipSize.medium:
        return 11; // 12 → 11 (smaller)
      case ViaStatChipSize.large:
        return IndustrialDarkTokens.fontSizeLabel;
    }
  }

  double _getCountFontSize() {
    switch (size) {
      case ViaStatChipSize.small:
        return IndustrialDarkTokens.fontSizeLabel;
      case ViaStatChipSize.medium:
        return 18; // 14 → 18 (bigger)
      case ViaStatChipSize.large:
        return 20; // Bigger count
    }
  }

  double _getDotSize() {
    switch (size) {
      case ViaStatChipSize.small:
        return 6;
      case ViaStatChipSize.medium:
        return IndustrialDarkTokens.spacingCompact;
      case ViaStatChipSize.large:
        return 10;
    }
  }
}

/// Size variants for ViaStatChip
enum ViaStatChipSize {
  small,
  medium,
  large,
}
