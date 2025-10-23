import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/via_design_tokens.dart';

/// VIA Design System Priority Badge Component
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
/// - Integration with VIA design tokens

enum ViaPriority {
  p1, // Critical - Red
  p2, // High - Orange
  p3, // Normal - Blue
  p4, // Low - Green
}

enum ViaPriorityBadgeSize {
  compact,  // Small badge with just priority label
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
        return ViaDesignTokens.priorityP1;
      case ViaPriority.p2:
        return ViaDesignTokens.priorityP2;
      case ViaPriority.p3:
        return ViaDesignTokens.priorityP3;
      case ViaPriority.p4:
        return ViaDesignTokens.priorityP4;
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
        borderRadius: BorderRadius.circular(ViaDesignTokens.radiusSm),
        border: Border.all(
          color: priorityColor.withValues(alpha: 0.3),
          width: 1,
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
                    topLeft: Radius.circular(ViaDesignTokens.radiusSm),
                    bottomLeft: Radius.circular(ViaDesignTokens.radiusSm),
                  ),
                ),
              ),
            // Priority label
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: showLeftBar
                    ? ViaDesignTokens.spacingSm
                    : ViaDesignTokens.spacingMd,
                vertical: ViaDesignTokens.spacingXs,
              ),
              child: Text(
                _getPriorityLabel(),
                style: ViaDesignTokens.labelSmall.copyWith(
                  color: priorityColor,
                  fontWeight: FontWeight.w700,
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
        borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
        border: Border.all(
          color: priorityColor.withValues(alpha: 0.3),
          width: 1,
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
                    topLeft: Radius.circular(ViaDesignTokens.radiusMd),
                    bottomLeft: Radius.circular(ViaDesignTokens.radiusMd),
                  ),
                ),
              ),
            // Content
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: showLeftBar
                    ? ViaDesignTokens.spacingMd
                    : ViaDesignTokens.spacingLg,
                vertical: ViaDesignTokens.spacingSm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Icon(
                    _getPriorityIcon(),
                    size: ViaDesignTokens.iconSm,
                    color: priorityColor,
                  ),
                  const SizedBox(width: ViaDesignTokens.spacingSm),
                  // Text content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getPriorityLabel(),
                        style: ViaDesignTokens.labelMedium.copyWith(
                          color: priorityColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: ViaDesignTokens.spacingXxs),
                      Text(
                        _getPriorityDescription(),
                        style: ViaDesignTokens.bodySmall.copyWith(
                          color: ViaDesignTokens.textMuted,
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
    final priorities = ViaPriority.values;

    if (direction == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: priorities.map((priority) {
          return Padding(
            padding: const EdgeInsets.only(right: ViaDesignTokens.spacingSm),
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
            padding: const EdgeInsets.only(bottom: ViaDesignTokens.spacingSm),
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
          duration: ViaDesignTokens.durationFast,
          child: Opacity(
            opacity: enabled ? 1.0 : ViaDesignTokens.opacityDisabled,
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
