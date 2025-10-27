import 'package:flutter/material.dart';
import '../../../domain/models/cart.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

class CartFilterChips extends StatelessWidget {
  final Set<CartStatus> selectedFilters;
  final Function(CartStatus) onFilterToggle;
  final VoidCallback onClearFilters;

  const CartFilterChips({
    super.key,
    required this.selectedFilters,
    required this.onFilterToggle,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    const allStatuses = CartStatus.values;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(
          horizontal: IndustrialDarkTokens.spacingItem),
      child: Row(
        children: [
          // Clear Filters Button
          if (selectedFilters.isNotEmpty)
            GestureDetector(
              onTap: onClearFilters,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: IndustrialDarkTokens.spacingItem,
                  vertical: IndustrialDarkTokens.spacingMinimal,
                ),
                decoration: BoxDecoration(
                  color: IndustrialDarkTokens.bgSurface,
                  borderRadius:
                      BorderRadius.circular(IndustrialDarkTokens.radiusButton),
                  border: Border.all(
                    color: IndustrialDarkTokens.outline,
                    width: 1.0,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.clear,
                      size: 16,
                      color: IndustrialDarkTokens.textSecondary,
                    ),
                    SizedBox(width: IndustrialDarkTokens.spacingMinimal),
                    Text(
                      'CLEAR',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: IndustrialDarkTokens.fontWeightBold,
                        color: IndustrialDarkTokens.textSecondary,
                        letterSpacing: IndustrialDarkTokens.letterSpacing,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (selectedFilters.isNotEmpty)
            const SizedBox(width: IndustrialDarkTokens.spacingCompact),

          // Filter Chips
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allStatuses.length,
              itemBuilder: (context, index) {
                final status = allStatuses[index];
                final isSelected = selectedFilters.contains(status);
                final color = IndustrialDarkTokens.getStatusColor(status.name);

                return Padding(
                  padding: EdgeInsets.only(
                    right: index < allStatuses.length - 1
                        ? IndustrialDarkTokens.spacingCompact
                        : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => onFilterToggle(status),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: IndustrialDarkTokens.spacingItem,
                        vertical: IndustrialDarkTokens.spacingMinimal,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withValues(alpha: 0.2)
                            : IndustrialDarkTokens.bgSurface,
                        borderRadius: BorderRadius.circular(
                            IndustrialDarkTokens.radiusButton),
                        border: Border.all(
                          color:
                              isSelected ? color : IndustrialDarkTokens.outline,
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                              width: IndustrialDarkTokens.spacingMinimal),
                          Text(
                            status.displayName.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? IndustrialDarkTokens.fontWeightBold
                                  : IndustrialDarkTokens.fontWeightBold,
                              color: isSelected
                                  ? color
                                  : IndustrialDarkTokens.textSecondary,
                              letterSpacing: IndustrialDarkTokens.letterSpacing,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
