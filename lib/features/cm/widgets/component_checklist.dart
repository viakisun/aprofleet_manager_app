import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';

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
              style: DesignTokens.getUppercaseLabelStyle(
                fontSize: DesignTokens.fontSizeMd,
                fontWeight: DesignTokens.fontWeightSemibold,
                color: DesignTokens.textPrimary,
              ),
            ),
            const Spacer(),
            // Progress indicator
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingSm,
                vertical: DesignTokens.spacingXs,
              ),
              decoration: BoxDecoration(
                color: DesignTokens.statusActive.withOpacity(0.2),
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              ),
              child: Text(
                '${_getCheckedCount()}/${_components.length}',
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeSm,
                  fontWeight: DesignTokens.fontWeightSemibold,
                  color: DesignTokens.statusActive,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingMd),
        ...categories.entries.map((entry) {
          final category = entry.key;
          final components = entry.value;

          return Container(
            margin: EdgeInsets.only(
              bottom: entry.key == categories.keys.last
                  ? 0
                  : DesignTokens.spacingMd,
            ),
            decoration: BoxDecoration(
              color: DesignTokens.bgSecondary,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              border: Border.all(
                color: DesignTokens.borderPrimary,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(DesignTokens.spacingMd),
                  decoration: BoxDecoration(
                    color: DesignTokens.bgTertiary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(DesignTokens.radiusMd),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        size: DesignTokens.iconMd,
                        color: DesignTokens.statusActive,
                      ),
                      const SizedBox(width: DesignTokens.spacingSm),
                      Text(
                        category.toUpperCase(),
                        style: DesignTokens.getUppercaseLabelStyle(
                          fontSize: DesignTokens.fontSizeSm,
                          fontWeight: DesignTokens.fontWeightSemibold,
                          color: DesignTokens.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      // Category progress
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignTokens.spacingXs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryProgressColor(components)
                              .withOpacity(0.2),
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radiusSm),
                        ),
                        child: Text(
                          '${_getCategoryCheckedCount(components)}/${components.length}',
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeXs,
                            fontWeight: DesignTokens.fontWeightSemibold,
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
                          : Border(
                              bottom: BorderSide(
                                color: DesignTokens.borderPrimary,
                                width: 1,
                              ),
                            ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingMd,
                        vertical: DesignTokens.spacingXs,
                      ),
                      leading: Checkbox(
                        value: component.isChecked,
                        onChanged: (value) => _toggleComponent(component),
                        activeColor: DesignTokens.statusActive,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radiusSm),
                        ),
                      ),
                      title: Text(
                        component.name,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeMd,
                          fontWeight: component.isChecked
                              ? DesignTokens.fontWeightMedium
                              : DesignTokens.fontWeightNormal,
                          color: component.isChecked
                              ? DesignTokens.textSecondary
                              : DesignTokens.textPrimary,
                          decoration: component.isChecked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: component.description.isNotEmpty
                          ? Text(
                              component.description,
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeSm,
                                color: DesignTokens.textTertiary,
                              ),
                            )
                          : null,
                      trailing: component.isCritical
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: DesignTokens.spacingXs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: DesignTokens.statusCritical
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(
                                    DesignTokens.radiusSm),
                              ),
                              child: Text(
                                'CRITICAL',
                                style: TextStyle(
                                  fontSize: DesignTokens.fontSizeXs,
                                  fontWeight: DesignTokens.fontWeightSemibold,
                                  color: DesignTokens.statusCritical,
                                  letterSpacing: DesignTokens.letterSpacingWide,
                                ),
                              ),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }).toList(),
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
      return DesignTokens.statusActive;
    } else if (checkedCount > 0) {
      return DesignTokens.statusWarning;
    } else {
      return DesignTokens.textTertiary;
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
