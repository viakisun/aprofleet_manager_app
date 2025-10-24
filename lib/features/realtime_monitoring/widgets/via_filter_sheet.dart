import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/widgets/via/via_bottom_sheet.dart';
import 'package:aprofleet_manager/core/widgets/via/via_chip.dart';
import 'package:aprofleet_manager/core/widgets/via/via_button.dart';
import 'package:aprofleet_manager/core/theme/via_design_tokens.dart';
import 'package:aprofleet_manager/domain/models/cart.dart';
import 'package:aprofleet_manager/core/localization/app_localizations.dart';

/// VIA Design System Filter Sheet for Cart Status
class ViaFilterSheet {
  static Future<void> show({
    required BuildContext context,
    required Set<CartStatus> activeFilters,
    required Function(CartStatus) onFilterToggle,
    required VoidCallback onClearFilters,
  }) {
    return ViaBottomSheet.show(
      context: context,
      snapPoints: [0.6, 0.9],
      header: Row(
        children: [
          Text(
            AppLocalizations.of(context).filter,
            style: ViaDesignTokens.headingMedium,
          ),
          const Spacer(),
          if (activeFilters.isNotEmpty)
            ViaButton.ghost(
              text: 'Clear All',
              onPressed: () {
                onClearFilters();
              },
              size: ViaButtonSize.small,
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter description
          Text(
            'Select cart status to filter',
            style: ViaDesignTokens.bodyMedium.copyWith(
              color: ViaDesignTokens.textMuted,
            ),
          ),
          const SizedBox(height: ViaDesignTokens.spacingLg),

          // Filter chips
          ...CartStatus.values.map((status) {
            final isActive = activeFilters.contains(status);
            final color = _getStatusColor(status);

            return Padding(
              padding: const EdgeInsets.only(bottom: ViaDesignTokens.spacingSm),
              child: GestureDetector(
                onTap: () => onFilterToggle(status),
                child: AnimatedContainer(
                  duration: ViaDesignTokens.durationFast,
                  padding: const EdgeInsets.symmetric(
                    horizontal: ViaDesignTokens.spacingLg,
                    vertical: ViaDesignTokens.spacingMd,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? color.withValues(alpha: 0.15)
                        : ViaDesignTokens.surfaceSecondary,
                    borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
                    border: Border.all(
                      color: isActive
                          ? color
                          : ViaDesignTokens.borderPrimary,
                      width: isActive ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Status dot
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.4),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(width: ViaDesignTokens.spacingMd),
                      // Status name
                      Expanded(
                        child: Text(
                          status.displayName,
                          style: ViaDesignTokens.bodyMedium.copyWith(
                            color: isActive ? color : ViaDesignTokens.textPrimary,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ),
                      // Check icon
                      if (isActive)
                        Icon(
                          Icons.check_circle,
                          color: color,
                          size: ViaDesignTokens.iconSm,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
      footer: ViaButton.primary(
        text: 'Apply Filters',
        onPressed: () => Navigator.of(context).pop(),
        isFullWidth: true,
      ),
    );
  }

  static Color _getStatusColor(CartStatus status) {
    switch (status) {
      case CartStatus.active:
        return ViaDesignTokens.statusActive;
      case CartStatus.idle:
        return ViaDesignTokens.statusIdle;
      case CartStatus.charging:
        return ViaDesignTokens.statusCharging;
      case CartStatus.maintenance:
        return ViaDesignTokens.statusMaintenance;
      case CartStatus.offline:
        return ViaDesignTokens.statusOffline;
    }
  }
}
