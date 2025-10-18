import 'package:flutter/material.dart';

import '../../../../core/theme/design_tokens.dart';

/// Widget for selecting technician
class TechnicianSelector extends StatelessWidget {
  final String? selectedTechnician;
  final Function(String) onTechnicianSelected;

  const TechnicianSelector({
    super.key,
    required this.selectedTechnician,
    required this.onTechnicianSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Mock technician list - in real app this would come from a provider
    final technicians = [
      'John Smith',
      'Sarah Johnson',
      'Mike Wilson',
      'Lisa Brown',
      'David Lee',
    ];

    return Column(
      children: [
        // Search field
        TextField(
          decoration: InputDecoration(
            hintText: 'Search technicians...',
            hintStyle: TextStyle(
              color: DesignTokens.textTertiary,
              fontSize: DesignTokens.fontSizeMd,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: DesignTokens.textSecondary,
              size: DesignTokens.iconMd,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              borderSide: BorderSide(color: DesignTokens.borderPrimary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              borderSide: BorderSide(color: DesignTokens.borderPrimary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              borderSide: const BorderSide(color: DesignTokens.textPrimary),
            ),
            contentPadding: const EdgeInsets.all(DesignTokens.spacingMd),
          ),
        ),
        
        const SizedBox(height: DesignTokens.spacingMd),
        
        // Technician list
        ...technicians.map((technician) {
          final isSelected = selectedTechnician == technician;
          
          return Container(
            margin: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
            decoration: BoxDecoration(
              color: isSelected 
                  ? DesignTokens.bgSecondary 
                  : DesignTokens.bgTertiary,
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              border: Border.all(
                color: isSelected 
                    ? DesignTokens.textPrimary 
                    : DesignTokens.borderPrimary,
                width: 1,
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: DesignTokens.textPrimary,
                child: Text(
                  technician.split(' ').map((name) => name[0]).join(),
                  style: const TextStyle(
                    color: DesignTokens.bgPrimary,
                    fontWeight: DesignTokens.fontWeightSemibold,
                  ),
                ),
              ),
              title: Text(
                technician,
                style: const TextStyle(
                  color: DesignTokens.textPrimary,
                  fontSize: DesignTokens.fontSizeMd,
                  fontWeight: DesignTokens.fontWeightMedium,
                ),
              ),
              subtitle: Text(
                'Available',
                style: TextStyle(
                  color: DesignTokens.textSecondary,
                  fontSize: DesignTokens.fontSizeSm,
                ),
              ),
              trailing: isSelected
                  ? const Icon(
                      Icons.check_circle,
                      color: DesignTokens.textPrimary,
                      size: DesignTokens.iconMd,
                    )
                  : null,
              onTap: () => onTechnicianSelected(technician),
            ),
          );
        }),
      ],
    );
  }
}
