import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../localization/app_localizations.dart';
import '../theme/design_tokens.dart';
import 'custom_icons.dart';
import '../../features/auth/widgets/cart_icon.dart';

class AppNavigationBar extends ConsumerWidget {
  const AppNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final currentLocation = GoRouterState.of(context).uri.path;

    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: DesignTokens.bgPrimary,
        border: Border(
          top: BorderSide(
            color: DesignTokens.borderPrimary,
            width: 1,
          ),
        ),
      ),
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
            customActiveIcon: const CartIcon(
              size: 20,
              color: DesignTokens.statusActive,
              showDirection: true,
            ),
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
    return GestureDetector(
      onTap: () => context.go(route),
      child: AnimatedContainer(
        duration: DesignTokens.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingSm,
          vertical: DesignTokens.spacingSm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                isActive && customActiveIcon != null
                    ? customActiveIcon
                    : Icon(
                        isActive ? activeIcon : icon,
                        color: isActive
                            ? DesignTokens.textPrimary
                            : DesignTokens.textTertiary,
                        size: CustomIcons.iconLg, // Larger icons
                      ),
                if (badge != null && badge > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: DesignTokens.alertCritical,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        badge.toString(),
                        style: const TextStyle(
                          color: DesignTokens.textPrimary,
                          fontSize: DesignTokens.fontSizeXs,
                          fontWeight: DesignTokens.fontWeightSemibold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: DesignTokens.spacingXs),
            Text(
              label,
              style: DesignTokens.getUppercaseLabelStyle(
                fontSize: DesignTokens.fontSizeXs,
                fontWeight: DesignTokens.fontWeightMedium,
                color: isActive
                    ? DesignTokens.textPrimary
                    : DesignTokens.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
