import 'package:flutter/material.dart';
import '../../../domain/models/cart.dart';
import '../../../core/theme/design_tokens.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: DesignTokens.spacingMd),
      child: Row(
        children: [
          // Clear Filters Button
          if (selectedFilters.isNotEmpty)
            GestureDetector(
              onTap: onClearFilters,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignTokens.spacingMd,
                  vertical: DesignTokens.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: DesignTokens.bgTertiary,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  border: Border.all(
                    color: DesignTokens.borderPrimary,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.clear,
                      size: 16,
                      color: DesignTokens.textSecondary,
                    ),
                    const SizedBox(width: DesignTokens.spacingXs),
                    Text(
                      'CLEAR',
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeXs,
                        fontWeight: DesignTokens.fontWeightSemibold,
                        color: DesignTokens.textSecondary,
                        letterSpacing: DesignTokens.letterSpacingWide,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (selectedFilters.isNotEmpty)
            const SizedBox(width: DesignTokens.spacingSm),

          // Filter Chips
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allStatuses.length,
              itemBuilder: (context, index) {
                final status = allStatuses[index];
                final isSelected = selectedFilters.contains(status);
                final color = DesignTokens.getStatusColor(status.name);

                return Padding(
                  padding: EdgeInsets.only(
                    right: index < allStatuses.length - 1
                        ? DesignTokens.spacingSm
                        : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => onFilterToggle(status),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spacingMd,
                        vertical: DesignTokens.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withValues(alpha: 0.2)
                            : DesignTokens.bgTertiary,
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusMd),
                        border: Border.all(
                          color:
                              isSelected ? color : DesignTokens.borderPrimary,
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
                          const SizedBox(width: DesignTokens.spacingXs),
                          Text(
                            status.displayName.toUpperCase(),
                            style: TextStyle(
                              fontSize: DesignTokens.fontSizeXs,
                              fontWeight: isSelected
                                  ? DesignTokens.fontWeightBold
                                  : DesignTokens.fontWeightSemibold,
                              color: isSelected
                                  ? color
                                  : DesignTokens.textSecondary,
                              letterSpacing: DesignTokens.letterSpacingWide,
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
