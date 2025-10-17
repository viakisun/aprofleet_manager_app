import 'package:flutter/material.dart';
import '../../../domain/models/work_order.dart';
import '../../../core/theme/design_tokens.dart';

class WorkOrderTypeSelector extends StatelessWidget {
  final WorkOrderType? selectedType;
  final Function(WorkOrderType) onTypeSelected;

  const WorkOrderTypeSelector({
    super.key,
    this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WORK ORDER TYPE',
          style: DesignTokens.getUppercaseLabelStyle(
            fontSize: DesignTokens.fontSizeSm,
            fontWeight: DesignTokens.fontWeightSemibold,
            color: DesignTokens.textSecondary,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        Wrap(
          spacing: DesignTokens.spacingSm,
          runSpacing: DesignTokens.spacingSm,
          children: WorkOrderType.values.map((type) {
            final isSelected = selectedType == type;
            final typeInfo = _getTypeInfo(type);

            return GestureDetector(
              onTap: () => onTypeSelected(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMd,
                  vertical: DesignTokens.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? typeInfo.color.withOpacity(0.2)
                      : DesignTokens.bgTertiary,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  border: Border.all(
                    color: isSelected
                        ? typeInfo.color
                        : DesignTokens.borderPrimary,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      typeInfo.icon,
                      size: DesignTokens.iconSm,
                      color: isSelected
                          ? typeInfo.color
                          : DesignTokens.textSecondary,
                    ),
                    const SizedBox(width: DesignTokens.spacingSm),
                    Text(
                      typeInfo.label,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeSm,
                        fontWeight: isSelected
                            ? DesignTokens.fontWeightBold
                            : DesignTokens.fontWeightMedium,
                        color: isSelected
                            ? typeInfo.color
                            : DesignTokens.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  _TypeInfo _getTypeInfo(WorkOrderType type) {
    switch (type) {
      case WorkOrderType.emergencyRepair:
        return _TypeInfo(
          label: 'EMERGENCY',
          icon: Icons.emergency,
          color: DesignTokens.statusCritical,
        );
      case WorkOrderType.preventive:
        return _TypeInfo(
          label: 'PREVENTIVE',
          icon: Icons.schedule,
          color: DesignTokens.statusActive,
        );
      case WorkOrderType.battery:
        return _TypeInfo(
          label: 'BATTERY',
          icon: Icons.battery_std,
          color: DesignTokens.statusCharging,
        );
      case WorkOrderType.tire:
        return _TypeInfo(
          label: 'TIRE',
          icon: Icons.circle,
          color: DesignTokens.statusWarning,
        );
      case WorkOrderType.safety:
        return _TypeInfo(
          label: 'SAFETY',
          icon: Icons.security,
          color: DesignTokens.statusMaintenance,
        );
      case WorkOrderType.other:
        return _TypeInfo(
          label: 'OTHER',
          icon: Icons.build,
          color: DesignTokens.statusIdle,
        );
    }
  }
}

class _TypeInfo {
  final String label;
  final IconData icon;
  final Color color;

  _TypeInfo({
    required this.label,
    required this.icon,
    required this.color,
  });
}
