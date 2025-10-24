import 'package:flutter/material.dart';

import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';
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

        const SizedBox(height: IndustrialDarkTokens.spacingItem),

        // Technician list
        ...technicians.map((technician) {
          final isSelected = selectedTechnician == technician;

          return Padding(
            padding: const EdgeInsets.only(bottom: IndustrialDarkTokens.spacingCompact),
            child: ViaCard(
              onTap: () => onTechnicianSelected(technician),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: IndustrialDarkTokens.textPrimary,
                child: Text(
                  technician.split(' ').map((name) => name[0]).join(),
                  style: const TextStyle(
                    color: IndustrialDarkTokens.bgBase,
                    fontWeight: IndustrialDarkTokens.fontWeightBold,
                  ),
                ),
              ),
              title: Text(
                technician,
                style: const TextStyle(
                  color: IndustrialDarkTokens.textPrimary,
                  fontSize: IndustrialDarkTokens.fontSizeLabel,
                  fontWeight: IndustrialDarkTokens.fontWeightMedium,
                ),
              ),
              subtitle: Text(
                'Available',
                style: TextStyle(
                  color: IndustrialDarkTokens.textSecondary,
                  fontSize: IndustrialDarkTokens.fontSizeSmall,
                ),
              ),
              trailing: isSelected
                  ? const Icon(
                      Icons.check_circle,
                      color: IndustrialDarkTokens.textPrimary,
                      size: 20,
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
