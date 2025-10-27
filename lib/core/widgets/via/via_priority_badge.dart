import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

/// Industrial Dark Priority Badge Component
///
/// Priority indicators for tasks/alerts (P1-P4):
/// - P1: Critical (Red) - Immediate action required
/// - P2: High (Orange) - Urgent attention needed
/// - P3: Normal (Blue) - Standard priority
/// - P4: Low (Green) - Can be deferred
///
/// Features:
/// - Colored left bar indicator
/// - Icon support
/// - Compact and expanded sizes
/// - Outline-based depth (no shadows)

enum ViaPriority {
  p1, // Critical - Red
  p2, // High - Orange
  p3, // Normal - Blue
  p4, // Low - Green
}

enum ViaPriorityBadgeSize {
  compact, // Small badge with just priority label
  expanded, // Larger badge with icon and description
}

class ViaPriorityBadge extends StatelessWidget {
  final ViaPriority priority;
  final ViaPriorityBadgeSize size;
  final String? customLabel;
  final String? description;
  final IconData? customIcon;
  final bool showLeftBar;

  const ViaPriorityBadge({
    super.key,
    required this.priority,
    this.size = ViaPriorityBadgeSize.compact,
    this.customLabel,
    this.description,
    this.customIcon,
    this.showLeftBar = true,
  });

  /// P1 - Critical priority badge (Red)
  const ViaPriorityBadge.p1({
    super.key,
    this.size = ViaPriorityBadgeSize.compact,
    this.customLabel,
    this.description,
    this.customIcon,
    this.showLeftBar = true,
  }) : priority = ViaPriority.p1;

  /// P2 - High priority badge (Orange)
  const ViaPriorityBadge.p2({
    super.key,
    this.size = ViaPriorityBadgeSize.compact,
    this.customLabel,
    this.description,
    this.customIcon,
    this.showLeftBar = true,
  }) : priority = ViaPriority.p2;

  /// P3 - Normal priority badge (Blue)
  const ViaPriorityBadge.p3({
    super.key,
    this.size = ViaPriorityBadgeSize.compact,
    this.customLabel,
    this.description,
    this.customIcon,
    this.showLeftBar = true,
  }) : priority = ViaPriority.p3;

  /// P4 - Low priority badge (Green)
  const ViaPriorityBadge.p4({
    super.key,
    this.size = ViaPriorityBadgeSize.compact,
    this.customLabel,
    this.description,
    this.customIcon,
    this.showLeftBar = true,
  }) : priority = ViaPriority.p4;

  Color _getPriorityColor() {
    switch (priority) {
      case ViaPriority.p1:
        return IndustrialDarkTokens.priorityP1;
      case ViaPriority.p2:
        return IndustrialDarkTokens.priorityP2;
      case ViaPriority.p3:
        return IndustrialDarkTokens.priorityP3;
      case ViaPriority.p4:
        return IndustrialDarkTokens.priorityP4;
    }
  }

  IconData _getPriorityIcon() {
    if (customIcon != null) {
      return customIcon!;
    }

    switch (priority) {
      case ViaPriority.p1:
        return Icons.priority_high;
      case ViaPriority.p2:
        return Icons.warning_amber_outlined;
      case ViaPriority.p3:
        return Icons.info_outline;
      case ViaPriority.p4:
        return Icons.low_priority;
    }
  }

  String _getPriorityLabel() {
    if (customLabel != null) {
      return customLabel!;
    }

    switch (priority) {
      case ViaPriority.p1:
        return 'P1';
      case ViaPriority.p2:
        return 'P2';
      case ViaPriority.p3:
        return 'P3';
      case ViaPriority.p4:
        return 'P4';
    }
  }

  String _getPriorityDescription() {
    if (description != null) {
      return description!;
    }

    switch (priority) {
      case ViaPriority.p1:
        return 'Critical';
      case ViaPriority.p2:
        return 'High';
      case ViaPriority.p3:
        return 'Normal';
      case ViaPriority.p4:
        return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor();

    if (size == ViaPriorityBadgeSize.compact) {
      return _buildCompactBadge(priorityColor);
    } else {
      return _buildExpandedBadge(priorityColor);
    }
  }

  Widget _buildCompactBadge(Color priorityColor) {
    return Container(
      decoration: BoxDecoration(
        color: priorityColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
        border: Border.all(
          color: priorityColor.withValues(alpha: 0.3),
          width: IndustrialDarkTokens.borderWidthThin,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Left color bar
            if (showLeftBar)
              Container(
                width: 3,
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(IndustrialDarkTokens.radiusSmall),
                    bottomLeft:
                        Radius.circular(IndustrialDarkTokens.radiusSmall),
                  ),
                ),
              ),
            // Priority label
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: showLeftBar
                    ? IndustrialDarkTokens.spacingCompact
                    : IndustrialDarkTokens.spacingItem,
                vertical: IndustrialDarkTokens.spacingMinimal,
              ),
              child: Text(
                _getPriorityLabel(),
                style: IndustrialDarkTokens.labelStyle.copyWith(
                  fontSize: IndustrialDarkTokens.fontSizeSmall,
                  color: priorityColor,
                  fontWeight: IndustrialDarkTokens.fontWeightBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedBadge(Color priorityColor) {
    return Container(
      decoration: BoxDecoration(
        color: priorityColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
        border: Border.all(
          color: priorityColor.withValues(alpha: 0.3),
          width: IndustrialDarkTokens.borderWidthThin,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Left color bar
            if (showLeftBar)
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(IndustrialDarkTokens.radiusButton),
                    bottomLeft:
                        Radius.circular(IndustrialDarkTokens.radiusButton),
                  ),
                ),
              ),
            // Content
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: showLeftBar
                    ? IndustrialDarkTokens.spacingItem
                    : IndustrialDarkTokens.spacingCard,
                vertical: IndustrialDarkTokens.spacingCompact,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Icon(
                    _getPriorityIcon(),
                    size: 20.0,
                    color: priorityColor,
                  ),
                  const SizedBox(width: IndustrialDarkTokens.spacingCompact),
                  // Text content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getPriorityLabel(),
                        style: IndustrialDarkTokens.labelStyle.copyWith(
                          fontSize: IndustrialDarkTokens.fontSizeLabel,
                          color: priorityColor,
                          fontWeight: IndustrialDarkTokens.fontWeightBold,
                        ),
                      ),
                      const SizedBox(
                          height: IndustrialDarkTokens.spacingMinimal),
                      Text(
                        _getPriorityDescription(),
                        style: IndustrialDarkTokens.bodyStyle.copyWith(
                          fontSize: IndustrialDarkTokens.fontSizeSmall,
                          color: IndustrialDarkTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// VIA Priority Selector - Allows selecting priority level
class ViaPrioritySelector extends StatelessWidget {
  final ViaPriority selectedPriority;
  final ValueChanged<ViaPriority>? onPriorityChanged;
  final bool enabled;
  final Axis direction;

  const ViaPrioritySelector({
    super.key,
    required this.selectedPriority,
    this.onPriorityChanged,
    this.enabled = true,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    const priorities = ViaPriority.values;

    if (direction == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: priorities.map((priority) {
          return Padding(
            padding: const EdgeInsets.only(
                right: IndustrialDarkTokens.spacingCompact),
            child: _buildPriorityOption(priority),
          );
        }).toList(),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: priorities.map((priority) {
          return Padding(
            padding: const EdgeInsets.only(
                bottom: IndustrialDarkTokens.spacingCompact),
            child: _buildPriorityOption(priority),
          );
        }).toList(),
      );
    }
  }

  Widget _buildPriorityOption(ViaPriority priority) {
    final isSelected = priority == selectedPriority;

    return GestureDetector(
      onTap: enabled && onPriorityChanged != null
          ? () => onPriorityChanged!(priority)
          : null,
      child: Transform.scale(
        scale: isSelected ? 1.05 : 1.0,
        child: AnimatedContainer(
          duration: IndustrialDarkTokens.durationFast,
          child: Opacity(
            opacity: enabled ? 1.0 : 0.3,
            child: ViaPriorityBadge(
              priority: priority,
              size: isSelected
                  ? ViaPriorityBadgeSize.expanded
                  : ViaPriorityBadgeSize.compact,
            ),
          ),
        ),
      ),
    );
  }
}
