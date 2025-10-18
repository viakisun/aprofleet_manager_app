import 'package:flutter/material.dart';

import '../../../../domain/models/work_order.dart';
import '../../../../core/theme/design_tokens.dart';

/// Widget for selecting work order priority
class PrioritySelector extends StatelessWidget {
  final Priority? selectedPriority;
  final Function(Priority) onPrioritySelected;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: DesignTokens.spacingSm,
      runSpacing: DesignTokens.spacingSm,
      children: Priority.values.map((priority) {
        final isSelected = selectedPriority == priority;
        final color = _getPriorityColor(priority);
        
        return GestureDetector(
          onTap: () => onPrioritySelected(priority),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingMd,
              vertical: DesignTokens.spacingSm,
            ),
            decoration: BoxDecoration(
              color: isSelected 
                  ? color 
                  : DesignTokens.bgSecondary,
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              border: Border.all(
                color: isSelected 
                    ? color 
                    : DesignTokens.borderPrimary,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? DesignTokens.textPrimary 
                        : color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: DesignTokens.spacingXs),
                Text(
                  priority.displayName,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeSm,
                    fontWeight: DesignTokens.fontWeightMedium,
                    color: isSelected 
                        ? DesignTokens.textPrimary 
                        : DesignTokens.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.p1:
        return const Color(0xFFEF4444); // Red
      case Priority.p2:
        return const Color(0xFFF97316); // Orange
      case Priority.p3:
        return const Color(0xFF3B82F6); // Blue
      case Priority.p4:
        return const Color(0xFF22C55E); // Green
    }
  }
}
