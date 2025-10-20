import 'package:flutter/material.dart';

import '../../domain/models/cart.dart';
import '../../core/constants/app_constants.dart';
import '../theme/status_colors.dart';

class StatusBar extends StatelessWidget {
  final Map<CartStatus, int> statusCounts;
  final Set<CartStatus> activeFilters;
  final Function(CartStatus) onFilterTap;
  // Optional trailing controls
  final VoidCallback? onOpenFilter; // Opens filter sheet

  const StatusBar({
    super.key,
    required this.statusCounts,
    required this.activeFilters,
    required this.onFilterTap,
    this.onOpenFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // Compact height
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Tighter padding
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B), // Pure black base
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.12), // Subtle divider
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
                  final color = _getStatusColor(status);

                  return Padding(
                    padding: const EdgeInsets.only(right: 6), // Tighter spacing
                    child: GestureDetector(
                      onTap: () => onFilterTap(status),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), // Compact padding
                        decoration: BoxDecoration(
                          color: isActive
                              ? color.withValues(alpha: 0.1) // Subtle active state
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10), // Smaller radius
                          border: Border.all(
                            color: isActive
                                ? color.withValues(alpha: 0.3)
                                : Colors.white.withValues(alpha: 0.08),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5, // Smaller dot
                              height: 5,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              status.displayName,
                              style: TextStyle(
                                color: isActive
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.7),
                                fontSize: 10, // Smaller font
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              count.toString(),
                              style: TextStyle(
                                color: isActive
                                    ? Colors.white.withValues(alpha: 0.8)
                                    : Colors.white.withValues(alpha: 0.5),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.0,
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
          // Filter icon chip
          if (onOpenFilter != null) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onOpenFilter,
              child: Tooltip(
                message: 'Filter',
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.filter_list,
                    size: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(CartStatus status) {
    switch (status) {
      case CartStatus.active:
        return StatusColors.active;
      case CartStatus.idle:
        return StatusColors.idle;
      case CartStatus.charging:
        return StatusColors.idle; // Use same as idle for charging
      case CartStatus.maintenance:
        return StatusColors.maint;
      case CartStatus.offline:
        return StatusColors.offline;
      default:
        return Colors.grey;
    }
  }
}
