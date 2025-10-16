import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/cart.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/shared_widgets.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/code_formatters.dart';

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
    final localizations = AppLocalizations.of(context);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.06),
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
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => onFilterTap(status),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive
                              ? color.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isActive
                                ? color
                                : Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              status.displayName,
                              style: TextStyle(
                                color: isActive
                                    ? color
                                    : Colors.white.withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              count.toString(),
                              style: TextStyle(
                                color: isActive
                                    ? color
                                    : Colors.white.withOpacity(0.5),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
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
