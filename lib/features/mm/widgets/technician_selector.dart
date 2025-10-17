import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

class Technician {
  final String id;
  final String name;
  final String avatar;
  final bool isAvailable;
  final int currentWorkOrders;

  const Technician({
    required this.id,
    required this.name,
    required this.avatar,
    required this.isAvailable,
    required this.currentWorkOrders,
  });
}

class TechnicianSelector extends StatelessWidget {
  final Technician? selectedTechnician;
  final Function(Technician) onTechnicianSelected;

  const TechnicianSelector({
    super.key,
    this.selectedTechnician,
    required this.onTechnicianSelected,
  });

  @override
  Widget build(BuildContext context) {
    final technicians = _getMockTechnicians();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ASSIGN TECHNICIAN',
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
          children: technicians.map((technician) {
            final isSelected = selectedTechnician?.id == technician.id;
            final statusColor = technician.isAvailable
                ? DesignTokens.statusActive
                : DesignTokens.statusOffline;

            return GestureDetector(
              onTap: () => onTechnicianSelected(technician),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(DesignTokens.spacingMd),
                decoration: BoxDecoration(
                  color: isSelected
                      ? statusColor.withOpacity(0.2)
                      : DesignTokens.bgTertiary,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  border: Border.all(
                    color:
                        isSelected ? statusColor : DesignTokens.borderPrimary,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar with status indicator
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: DesignTokens.bgSecondary,
                          child: Text(
                            technician.avatar,
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeMd,
                              fontWeight: DesignTokens.fontWeightBold,
                              color: DesignTokens.textPrimary,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: DesignTokens.bgTertiary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignTokens.spacingSm),
                    // Name
                    Text(
                      technician.name,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeSm,
                        fontWeight: isSelected
                            ? DesignTokens.fontWeightBold
                            : DesignTokens.fontWeightMedium,
                        color:
                            isSelected ? statusColor : DesignTokens.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DesignTokens.spacingXs),
                    // Work orders count
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingXs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: technician.currentWorkOrders > 0
                            ? DesignTokens.statusWarning.withOpacity(0.2)
                            : DesignTokens.bgSecondary,
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusSm),
                      ),
                      child: Text(
                        '${technician.currentWorkOrders} WO',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeXs,
                          fontWeight: DesignTokens.fontWeightSemibold,
                          color: technician.currentWorkOrders > 0
                              ? DesignTokens.statusWarning
                              : DesignTokens.textSecondary,
                        ),
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

  List<Technician> _getMockTechnicians() {
    return [
      const Technician(
        id: 'tech-001',
        name: 'John Smith',
        avatar: 'JS',
        isAvailable: true,
        currentWorkOrders: 2,
      ),
      const Technician(
        id: 'tech-002',
        name: 'Sarah Johnson',
        avatar: 'SJ',
        isAvailable: true,
        currentWorkOrders: 0,
      ),
      const Technician(
        id: 'tech-003',
        name: 'Mike Chen',
        avatar: 'MC',
        isAvailable: false,
        currentWorkOrders: 3,
      ),
      const Technician(
        id: 'tech-004',
        name: 'Lisa Brown',
        avatar: 'LB',
        isAvailable: true,
        currentWorkOrders: 1,
      ),
    ];
  }
}
