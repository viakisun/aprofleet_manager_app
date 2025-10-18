import 'package:flutter/material.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/custom_icons.dart';
import '../../../domain/models/cart.dart';

class InventoryStatsBar extends StatelessWidget {
  final List<Cart> carts;
  final VoidCallback? onTap;

  const InventoryStatsBar({
    super.key,
    required this.carts,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final stats = _calculateStats(carts);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingMd,
        vertical: DesignTokens.spacingMd,
      ),
      decoration: BoxDecoration(
        color: DesignTokens.bgSecondary,
        border: Border(
          bottom: BorderSide(color: DesignTokens.borderPrimary),
        ),
      ),
      child: Row(
        children: [
          Expanded(
              child: _buildStatItem(
            label: localizations.total,
            count: stats['total'] ?? 0,
            color: DesignTokens.textPrimary,
            icon: CustomIcons.car,
          )),
          Expanded(
              child: _buildStatItem(
            label: localizations.active,
            count: stats['active'] ?? 0,
            color: DesignTokens.statusActive,
            icon: CustomIcons.success,
          )),
          Expanded(
              child: _buildStatItem(
            label: localizations.charging,
            count: stats['charging'] ?? 0,
            color: DesignTokens.statusCharging,
            icon: CustomIcons.batteryCharging,
          )),
          Expanded(
              child: _buildStatItem(
            label: localizations.maintenance,
            count: stats['maintenance'] ?? 0,
            color: DesignTokens.statusMaintenance,
            icon: CustomIcons.work,
          )),
          Expanded(
              child: _buildStatItem(
            label: localizations.offline,
            count: stats['offline'] ?? 0,
            color: DesignTokens.statusOffline,
            icon: CustomIcons.wifiOff,
          )),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spacingSm,
            vertical: DesignTokens.spacingMd,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: CustomIcons.iconMd,
                color: color,
              ),
              const SizedBox(width: DesignTokens.spacingXs),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeLg,
                  fontWeight: DesignTokens.fontWeightBold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, int> _calculateStats(List<Cart> carts) {
    final stats = <String, int>{
      'total': carts.length,
      'active': 0,
      'charging': 0,
      'maintenance': 0,
      'offline': 0,
    };

    for (final cart in carts) {
      switch (cart.status) {
        case CartStatus.active:
          stats['active'] = (stats['active'] ?? 0) + 1;
          break;
        case CartStatus.charging:
          stats['charging'] = (stats['charging'] ?? 0) + 1;
          break;
        case CartStatus.maintenance:
          stats['maintenance'] = (stats['maintenance'] ?? 0) + 1;
          break;
        case CartStatus.offline:
          stats['offline'] = (stats['offline'] ?? 0) + 1;
          break;
        default:
          stats['offline'] = (stats['offline'] ?? 0) + 1;
          break;
      }
    }

    return stats;
  }
}
