import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

class ComponentChecklist extends StatefulWidget {
  final List<ComponentItem> components;
  final Function(List<ComponentItem>) onComponentsChanged;

  const ComponentChecklist({
    super.key,
    required this.components,
    required this.onComponentsChanged,
  });

  @override
  State<ComponentChecklist> createState() => _ComponentChecklistState();
}

class _ComponentChecklistState extends State<ComponentChecklist> {
  late List<ComponentItem> _components;

  @override
  void initState() {
    super.initState();
    _components = List.from(widget.components);
  }

  @override
  Widget build(BuildContext context) {
    final categories = _groupComponentsByCategory(_components);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'COMPONENT CHECKLIST',
              style: IndustrialDarkTokens.getUppercaseLabelStyle(
                fontSize: IndustrialDarkTokens.fontSizeLabel,
                fontWeight: IndustrialDarkTokens.fontWeightBold,
                color: IndustrialDarkTokens.textPrimary,
              ),
            ),
            const Spacer(),
            // Progress indicator
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: IndustrialDarkTokens.spacingCompact,
                vertical: IndustrialDarkTokens.spacingMinimal,
              ),
              decoration: BoxDecoration(
                color: IndustrialDarkTokens.statusActive.withValues(alpha: 0.2),
                borderRadius:
                    BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
              ),
              child: Text(
                '${_getCheckedCount()}/${_components.length}',
                style: const TextStyle(
                  fontSize: IndustrialDarkTokens.fontSizeSmall,
                  fontWeight: IndustrialDarkTokens.fontWeightBold,
                  color: IndustrialDarkTokens.statusActive,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: IndustrialDarkTokens.spacingItem),
        ...categories.entries.map((entry) {
          final category = entry.key;
          final components = entry.value;

          return Container(
            margin: EdgeInsets.only(
              bottom: entry.key == categories.keys.last
                  ? 0
                  : IndustrialDarkTokens.spacingItem,
            ),
            decoration: BoxDecoration(
              color: IndustrialDarkTokens.bgSurface,
              borderRadius:
                  BorderRadius.circular(IndustrialDarkTokens.radiusButton),
              border: Border.all(
                color: IndustrialDarkTokens.outline,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category header
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(IndustrialDarkTokens.spacingItem),
                  decoration: const BoxDecoration(
                    color: IndustrialDarkTokens.bgSurface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(IndustrialDarkTokens.radiusButton),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        size: 20,
                        color: IndustrialDarkTokens.statusActive,
                      ),
                      const SizedBox(
                          width: IndustrialDarkTokens.spacingCompact),
                      Text(
                        category.toUpperCase(),
                        style: IndustrialDarkTokens.getUppercaseLabelStyle(
                          fontSize: IndustrialDarkTokens.fontSizeSmall,
                          fontWeight: IndustrialDarkTokens.fontWeightBold,
                          color: IndustrialDarkTokens.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      // Category progress
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: IndustrialDarkTokens.spacingMinimal,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryProgressColor(components)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                              IndustrialDarkTokens.radiusSmall),
                        ),
                        child: Text(
                          '${_getCategoryCheckedCount(components)}/${components.length}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: IndustrialDarkTokens.fontWeightBold,
                            color: _getCategoryProgressColor(components),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Components list
                ...components.asMap().entries.map((entry) {
                  final index = entry.key;
                  final component = entry.value;
                  final isLast = index == components.length - 1;

                  return Container(
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : const Border(
                              bottom: BorderSide(
                                color: IndustrialDarkTokens.outline,
                                width: 1,
                              ),
                            ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: IndustrialDarkTokens.spacingItem,
                        vertical: IndustrialDarkTokens.spacingMinimal,
                      ),
                      leading: Checkbox(
                        value: component.isChecked,
                        onChanged: (value) => _toggleComponent(component),
                        activeColor: IndustrialDarkTokens.statusActive,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              IndustrialDarkTokens.radiusSmall),
                        ),
                      ),
                      title: Text(
                        component.name,
                        style: TextStyle(
                          fontSize: IndustrialDarkTokens.fontSizeLabel,
                          fontWeight: component.isChecked
                              ? IndustrialDarkTokens.fontWeightMedium
                              : IndustrialDarkTokens.fontWeightRegular,
                          color: component.isChecked
                              ? IndustrialDarkTokens.textSecondary
                              : IndustrialDarkTokens.textPrimary,
                          decoration: component.isChecked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: component.description.isNotEmpty
                          ? Text(
                              component.description,
                              style: const TextStyle(
                                fontSize: IndustrialDarkTokens.fontSizeSmall,
                                color: IndustrialDarkTokens.textSecondary,
                              ),
                            )
                          : null,
                      trailing: component.isCritical
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: IndustrialDarkTokens.spacingMinimal,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: IndustrialDarkTokens.error
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(
                                    IndustrialDarkTokens.radiusSmall),
                              ),
                              child: const Text(
                                'CRITICAL',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight:
                                      IndustrialDarkTokens.fontWeightBold,
                                  color: IndustrialDarkTokens.error,
                                  letterSpacing:
                                      IndustrialDarkTokens.letterSpacing,
                                ),
                              ),
                            )
                          : null,
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _toggleComponent(ComponentItem component) {
    setState(() {
      final index = _components.indexWhere((c) => c.id == component.id);
      if (index != -1) {
        _components[index] = ComponentItem(
          id: component.id,
          name: component.name,
          description: component.description,
          category: component.category,
          isCritical: component.isCritical,
          isChecked: !component.isChecked,
        );
      }
    });
    widget.onComponentsChanged(_components);
  }

  Map<String, List<ComponentItem>> _groupComponentsByCategory(
      List<ComponentItem> components) {
    final Map<String, List<ComponentItem>> grouped = {};
    for (final component in components) {
      grouped.putIfAbsent(component.category, () => []).add(component);
    }
    return grouped;
  }

  int _getCheckedCount() {
    return _components.where((c) => c.isChecked).length;
  }

  int _getCategoryCheckedCount(List<ComponentItem> components) {
    return components.where((c) => c.isChecked).length;
  }

  Color _getCategoryProgressColor(List<ComponentItem> components) {
    final checkedCount = _getCategoryCheckedCount(components);
    final totalCount = components.length;

    if (checkedCount == totalCount) {
      return IndustrialDarkTokens.statusActive;
    } else if (checkedCount > 0) {
      return IndustrialDarkTokens.warning;
    } else {
      return IndustrialDarkTokens.textSecondary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'battery':
        return Icons.battery_std;
      case 'motor':
        return Icons.electric_car;
      case 'brakes':
        return Icons.stop_circle;
      case 'tires':
        return Icons.circle;
      case 'electronics':
        return Icons.electrical_services;
      case 'safety':
        return Icons.security;
      case 'body':
        return Icons.directions_car;
      default:
        return Icons.build;
    }
  }
}

class ComponentItem {
  final String id;
  final String name;
  final String description;
  final String category;
  final bool isCritical;
  final bool isChecked;

  const ComponentItem({
    required this.id,
    required this.name,
    this.description = '',
    required this.category,
    this.isCritical = false,
    this.isChecked = false,
  });
}

class ComponentChecklistBuilder {
  static List<ComponentItem> buildDefaultComponents() {
    return [
      // Battery System
      const ComponentItem(
        id: 'battery-01',
        name: 'Main Battery Pack',
        description: 'Primary power source',
        category: 'Battery',
        isCritical: true,
      ),
      const ComponentItem(
        id: 'battery-02',
        name: 'Battery Management System',
        description: 'BMS monitoring unit',
        category: 'Battery',
        isCritical: true,
      ),
      const ComponentItem(
        id: 'battery-03',
        name: 'Charging Port',
        description: 'External charging connector',
        category: 'Battery',
        isCritical: true,
      ),

      // Motor System
      const ComponentItem(
        id: 'motor-01',
        name: 'Electric Motor',
        description: 'Main propulsion motor',
        category: 'Motor',
        isCritical: true,
      ),
      const ComponentItem(
        id: 'motor-02',
        name: 'Motor Controller',
        description: 'Speed and torque control',
        category: 'Motor',
        isCritical: true,
      ),
      const ComponentItem(
        id: 'motor-03',
        name: 'Transmission',
        description: 'Power transfer system',
        category: 'Motor',
      ),

      // Brakes
      const ComponentItem(
        id: 'brake-01',
        name: 'Brake Pads',
        description: 'Friction material',
        category: 'Brakes',
        isCritical: true,
      ),
      const ComponentItem(
        id: 'brake-02',
        name: 'Brake Discs',
        description: 'Rotating brake surface',
        category: 'Brakes',
      ),
      const ComponentItem(
        id: 'brake-03',
        name: 'Brake Lines',
        description: 'Hydraulic brake lines',
        category: 'Brakes',
        isCritical: true,
      ),

      // Tires
      const ComponentItem(
        id: 'tire-01',
        name: 'Front Tires',
        description: 'Front wheel tires',
        category: 'Tires',
        isCritical: true,
      ),
      const ComponentItem(
        id: 'tire-02',
        name: 'Rear Tires',
        description: 'Rear wheel tires',
        category: 'Tires',
        isCritical: true,
      ),
      const ComponentItem(
        id: 'tire-03',
        name: 'Tire Pressure Monitoring',
        description: 'TPMS sensors',
        category: 'Tires',
      ),

      // Electronics
      const ComponentItem(
        id: 'elec-01',
        name: 'Main Control Unit',
        description: 'Central processing unit',
        category: 'Electronics',
        isCritical: true,
      ),
      const ComponentItem(
        id: 'elec-02',
        name: 'Display Panel',
        description: 'Driver information display',
        category: 'Electronics',
      ),
      const ComponentItem(
        id: 'elec-03',
        name: 'Lighting System',
        description: 'Headlights and taillights',
        category: 'Electronics',
      ),

      // Safety
      const ComponentItem(
        id: 'safety-01',
        name: 'Seat Belts',
        description: 'Safety restraint system',
        category: 'Safety',
        isCritical: true,
      ),
      const ComponentItem(
        id: 'safety-02',
        name: 'Emergency Brake',
        description: 'Parking brake system',
        category: 'Safety',
        isCritical: true,
      ),
      const ComponentItem(
        id: 'safety-03',
        name: 'Horn',
        description: 'Warning sound system',
        category: 'Safety',
      ),

      // Body
      const ComponentItem(
        id: 'body-01',
        name: 'Chassis',
        description: 'Main structural frame',
        category: 'Body',
        isCritical: true,
      ),
      const ComponentItem(
        id: 'body-02',
        name: 'Body Panels',
        description: 'External body panels',
        category: 'Body',
      ),
      const ComponentItem(
        id: 'body-03',
        name: 'Windshield',
        description: 'Front windshield glass',
        category: 'Body',
      ),
    ];
  }
}
