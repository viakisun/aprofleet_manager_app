import 'package:flutter/material.dart';

import '../../domain/models/cart.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/shared_widgets.dart';
import '../../core/constants/app_constants.dart';

class FilterSheet extends StatelessWidget {
  final Set<CartStatus> activeFilters;
  final Function(CartStatus) onFilterToggle;
  final VoidCallback onClearFilters;

  const FilterSheet({
    super.key,
    required this.activeFilters,
    required this.onFilterToggle,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BaseModal(
      title: 'FILTER CARTS',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.filter,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (activeFilters.isNotEmpty)
                  TextButton(
                    onPressed: onClearFilters,
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Filter options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: CartStatus.values.map((status) {
                final isActive = activeFilters.contains(status);
                final color = AppConstants.statusColors[status] ?? Colors.grey;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => onFilterToggle(status),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isActive
                            ? color.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isActive
                              ? color.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              status.displayName,
                              style: TextStyle(
                                color: isActive ? color : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isActive)
                            Icon(
                              Icons.check,
                              color: color,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Apply button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ActionButton(
                text: 'Apply Filters',
                onPressed: () => Navigator.of(context).pop(),
                type: ActionButtonType.primary,
              ),
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
