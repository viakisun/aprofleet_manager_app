import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import '../localization/app_localizations.dart';

class AppNavigationBar extends ConsumerWidget {
  const AppNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final currentLocation = GoRouterState.of(context).uri.path;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context,
            icon: Icons.location_on_outlined,
            activeIcon: Icons.location_on,
            label: localizations.navRealTime,
            route: '/rt/map',
            isActive: currentLocation.startsWith('/rt'),
          ),
          _buildNavItem(
            context,
            icon: Icons.directions_car_outlined,
            activeIcon: Icons.directions_car,
            label: localizations.navCartManagement,
            route: '/cm/list',
            isActive: currentLocation.startsWith('/cm'),
          ),
          _buildNavItem(
            context,
            icon: Icons.build_outlined,
            activeIcon: Icons.build,
            label: localizations.navMaintenance,
            route: '/mm/list',
            isActive: currentLocation.startsWith('/mm'),
          ),
          _buildNavItem(
            context,
            icon: Icons.notifications_outlined,
            activeIcon: Icons.notifications,
            label: localizations.navAlerts,
            route: '/al/center',
            isActive: currentLocation.startsWith('/al'),
            badge: 3, // Mock unread count
          ),
          _buildNavItem(
            context,
            icon: Icons.analytics_outlined,
            activeIcon: Icons.analytics,
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
  }) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? Colors.white : const Color(0xFF666666),
                  size: 24,
                ),
                if (badge != null && badge > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        badge.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
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
                color: isActive ? Colors.white : const Color(0xFF666666),
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
