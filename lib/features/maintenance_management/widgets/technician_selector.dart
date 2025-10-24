import 'package:flutter/material.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/via/via_input.dart';
import '../../../../core/widgets/via/via_card.dart';

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
        ViaInput(
          label: 'Search',
          placeholder: 'Search technicians...',
          prefixIcon: Icons.search,
        ),

        const SizedBox(height: DesignTokens.spacingMd),

        // Technician list
        ...technicians.map((technician) {
          final isSelected = selectedTechnician == technician;

          return Padding(
            padding: const EdgeInsets.only(bottom: DesignTokens.spacingSm),
            child: ViaCard(
              onTap: () => onTechnicianSelected(technician),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
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
              ),
            ),
          );
        }),
      ],
    );
  }
}
