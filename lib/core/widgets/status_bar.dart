import 'package:flutter/material.dart';

import '../../domain/models/cart.dart';
import '../../core/constants/app_constants.dart';

class StatusBar extends StatelessWidget {
  final Map<CartStatus, int> statusCounts;
  final Set<CartStatus> activeFilters;
  final Function(CartStatus) onFilterTap;

  const StatusBar({
    super.key,
    required this.statusCounts,
    required this.activeFilters,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // More compact height
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6), // Tighter padding
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.04), // More subtle border
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: CartStatus.values.map((status) {
                  final count = statusCounts[status] ?? 0;
                  final isActive = activeFilters.contains(status);
                  final color =
                      AppConstants.statusColors[status] ?? Colors.grey;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8), // Tighter spacing
                    child: GestureDetector(
                      onTap: () => onFilterTap(status),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4), // Tighter padding
                        decoration: BoxDecoration(
                          color: isActive
                              ? color.withValues(
                                  alpha: 0.15) // More subtle active state
                              : Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(12), // Sharper corners
                          border: Border.all(
                            color: isActive
                                ? color
                                : Colors.white.withValues(
                                    alpha: 0.06), // More subtle border
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6, // Smaller indicator
                              height: 6,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4), // Tighter spacing
                            Text(
                              status.displayName,
                              style: TextStyle(
                                color: isActive
                                    ? color
                                    : Colors.white.withValues(alpha: 0.7),
                                fontSize: 11, // Smaller font
                                fontWeight: FontWeight.w700, // Bolder
                                letterSpacing: 0.2, // Tighter tracking
                              ),
                            ),
                            const SizedBox(width: 3), // Tighter spacing
                            Text(
                              count.toString(),
                              style: TextStyle(
                                color: isActive
                                    ? color
                                    : Colors.white.withValues(alpha: 0.5),
                                fontSize: 11, // Smaller font
                                fontWeight: FontWeight.w700,
                                letterSpacing:
                                    0.0, // Tighter tracking for numbers
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
