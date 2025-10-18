import 'package:flutter/material.dart';

import '../../../../domain/models/work_order.dart';
import '../../../../core/theme/design_tokens.dart';

/// Widget for selecting work order type
class WorkOrderTypeSelector extends StatelessWidget {
  final WorkOrderType? selectedType;
  final Function(WorkOrderType) onTypeSelected;

  const WorkOrderTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: DesignTokens.spacingSm,
      runSpacing: DesignTokens.spacingSm,
      children: WorkOrderType.values.map((type) {
        final isSelected = selectedType == type;
        
        return GestureDetector(
          onTap: () => onTypeSelected(type),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingMd,
              vertical: DesignTokens.spacingSm,
            ),
            decoration: BoxDecoration(
              color: isSelected 
                  ? DesignTokens.textPrimary 
                  : DesignTokens.bgSecondary,
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              border: Border.all(
                color: isSelected 
                    ? DesignTokens.textPrimary 
                    : DesignTokens.borderPrimary,
                width: 1,
              ),
            ),
            child: Text(
              type.displayName,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeSm,
                fontWeight: DesignTokens.fontWeightMedium,
                color: isSelected 
                    ? DesignTokens.bgPrimary 
                    : DesignTokens.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
