import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../localization/app_localizations.dart';
import '../theme/via_design_tokens.dart';
import 'custom_icons.dart';

class AppNavigationBar extends ConsumerWidget {
  const AppNavigationBar({super.key});

  // Bottom navigation bar with VIA design tokens

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final currentLocation = GoRouterState.of(context).uri.path;

    return Container(
      decoration: BoxDecoration(
        color: ViaDesignTokens.surfacePrimary,
        border: Border(
          top: BorderSide(
            color: ViaDesignTokens.borderPrimary,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 65, // Height for icon + label
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context,
                icon: CustomIcons.live,
                activeIcon: CustomIcons.liveFilled,
                label: localizations.navRealTime,
                route: '/rt/map',
                isActive: currentLocation.startsWith('/rt'),
              ),
              _buildNavItem(
                context,
                icon: CustomIcons.carts,
                activeIcon: CustomIcons.cartsFilled,
                label: localizations.navCartManagement,
                route: '/cm/list',
                isActive: currentLocation.startsWith('/cm'),
              ),
              _buildNavItem(
                context,
                icon: CustomIcons.work,
                activeIcon: CustomIcons.workFilled,
                label: localizations.navMaintenance,
                route: '/mm/list',
                isActive: currentLocation.startsWith('/mm'),
              ),
              _buildNavItem(
                context,
                icon: CustomIcons.alerts,
                activeIcon: CustomIcons.alertsFilled,
                label: localizations.navAlerts,
                route: '/al/center',
                isActive: currentLocation.startsWith('/al'),
                badge: 3, // Mock unread count
              ),
              _buildNavItem(
                context,
                icon: CustomIcons.analytics,
                activeIcon: CustomIcons.analyticsFilled,
                label: localizations.navAnalytics,
                route: '/ar/dashboard',
                isActive: currentLocation.startsWith('/ar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
    required bool isActive,
    int? badge,
    Widget? customActiveIcon,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.go(route),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                isActive && customActiveIcon != null
                    ? customActiveIcon
                    : Icon(
                        isActive ? activeIcon : icon,
                        color: isActive
                            ? ViaDesignTokens.primary
                            : ViaDesignTokens.textMuted,
                        size: 26,
                      ),
                // Badge
                if (badge != null && badge > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: ViaDesignTokens.critical,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ViaDesignTokens.surfacePrimary,
                          width: 1.5,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        badge > 9 ? '9+' : badge.toString(),
                        style: const TextStyle(
                          color: ViaDesignTokens.textPrimary,
                          fontSize: 9,
                          fontWeight: ViaDesignTokens.fontWeightBold,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive
                    ? ViaDesignTokens.fontWeightSemibold
                    : ViaDesignTokens.fontWeightMedium,
                color: isActive
                    ? ViaDesignTokens.textPrimary
                    : ViaDesignTokens.textMuted,
                letterSpacing: -0.3,
                height: 1.0,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
