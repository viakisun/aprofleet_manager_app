import 'package:flutter/material.dart';

import '../../../../domain/models/work_order.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

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
      spacing: IndustrialDarkTokens.spacingCompact,
      runSpacing: IndustrialDarkTokens.spacingCompact,
      children: WorkOrderType.values.map((type) {
        final isSelected = selectedType == type;

        return GestureDetector(
          onTap: () => onTypeSelected(type),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: IndustrialDarkTokens.spacingItem,
              vertical: IndustrialDarkTokens.spacingCompact,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? IndustrialDarkTokens.textPrimary
                  : IndustrialDarkTokens.bgSurface,
              borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
              border: Border.all(
                color: isSelected
                    ? IndustrialDarkTokens.textPrimary
                    : IndustrialDarkTokens.outline,
                width: 1,
              ),
            ),
            child: Text(
              type.displayName,
              style: TextStyle(
                fontSize: IndustrialDarkTokens.fontSizeSmall,
                fontWeight: IndustrialDarkTokens.fontWeightMedium,
                color: isSelected
                    ? IndustrialDarkTokens.bgBase
                    : IndustrialDarkTokens.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
