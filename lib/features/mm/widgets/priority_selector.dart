import 'package:flutter/material.dart';
import '../../../domain/models/work_order.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/localization/app_localizations.dart';

class PrioritySelector extends StatelessWidget {
  final Priority? selectedPriority;
  final Function(Priority) onPrioritySelected;

  const PrioritySelector({
    super.key,
    this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.priorityLevel,
          style: DesignTokens.getUppercaseLabelStyle(
            fontSize: DesignTokens.fontSizeSm,
            fontWeight: DesignTokens.fontWeightSemibold,
            color: DesignTokens.textSecondary,
          ),
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        Row(
          children: Priority.values.map((priority) {
            final isSelected = selectedPriority == priority;
            final priorityInfo = _getPriorityInfo(priority, localizations);

            return Expanded(
              child: GestureDetector(
                onTap: () => onPrioritySelected(priority),
                child: Container(
                  margin: EdgeInsets.only(
                    right: priority == Priority.p4 ? 0 : DesignTokens.spacingSm,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingSm,
                    vertical: DesignTokens.spacingMd,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? priorityInfo.color.withOpacity(0.2)
                        : DesignTokens.bgTertiary,
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                    border: Border.all(
                      color: isSelected
                          ? priorityInfo.color
                          : DesignTokens.borderPrimary,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Priority indicator
                      Container(
                        width: 20,
                        height: 4,
                        decoration: BoxDecoration(
                          color: priorityInfo.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: DesignTokens.spacingXs),
                      // Priority label
                      Text(
                        priorityInfo.label,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeXs,
                          fontWeight: isSelected
                              ? DesignTokens.fontWeightBold
                              : DesignTokens.fontWeightMedium,
                          color: isSelected
                              ? priorityInfo.color
                              : DesignTokens.textSecondary,
                          letterSpacing: DesignTokens.letterSpacingWide,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: DesignTokens.spacingXs),
                      // Priority number
                      Text(
                        priorityInfo.number,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeLg,
                          fontWeight: DesignTokens.fontWeightBold,
                          color: isSelected
                              ? priorityInfo.color
                              : DesignTokens.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  _PriorityInfo _getPriorityInfo(Priority priority, AppLocalizations localizations) {
    switch (priority) {
      case Priority.p1:
        return _PriorityInfo(
          label: localizations.critical,
          number: 'P1',
          color: DesignTokens.priorityP1,
        );
      case Priority.p2:
        return _PriorityInfo(
          label: localizations.high,
          number: 'P2',
          color: DesignTokens.priorityP2,
        );
      case Priority.p3:
        return _PriorityInfo(
          label: localizations.normal,
          number: 'P3',
          color: DesignTokens.priorityP3,
        );
      case Priority.p4:
        return _PriorityInfo(
          label: localizations.low,
          number: 'P4',
          color: DesignTokens.priorityP4,
        );
    }
  }
}

class _PriorityInfo {
  final String label;
  final String number;
  final Color color;

  _PriorityInfo({
    required this.label,
    required this.number,
    required this.color,
  });
}
