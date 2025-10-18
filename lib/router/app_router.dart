import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/realtime_monitoring/pages/live_map_view.dart';
import '../features/realtime_monitoring/pages/cart_detail_monitor.dart';
import '../features/cart_management/pages/cart_inventory_list.dart';
import '../features/cart_management/pages/cart_registration.dart';
import '../features/maintenance_management/pages/work_order_list.dart';
import '../features/maintenance_management/pages/work_order_creation_page.dart';
import '../features/alert_management/pages/alert_management_page.dart';
import '../features/analytics_reporting/pages/analytics_dashboard.dart';
import '../features/settings/pages/settings_page.dart';
import '../core/widgets/navigation_bar.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/rt/map',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: const AppNavigationBar(),
          );
        },
        routes: [
          // Real-Time Module
          GoRoute(
            path: '/rt/map',
            name: 'live-map',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const LiveMapView(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                );
              },
            ),
          ),
          GoRoute(
            path: '/rt/cart/:id',
            name: 'cart-detail',
            pageBuilder: (context, state) {
              final cartId = state.pathParameters['id']!;
              return CustomTransitionPage(
                child: CartDetailMonitor(cartId: cartId),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.easeInOut)),
                    ),
                    child: child,
                  );
                },
              );
            },
          ),

          // Cart Management Module
          GoRoute(
            path: '/cm/list',
            name: 'cart-inventory',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const CartInventoryList(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                );
              },
            ),
          ),
          GoRoute(
            path: '/cm/register',
            name: 'cart-registration',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const CartRegistrationPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                );
              },
            ),
          ),

          // Maintenance Module
          GoRoute(
            path: '/mm/list',
            name: 'work-order-list',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const WorkOrderList(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                );
              },
            ),
          ),
          GoRoute(
            path: '/mm/create',
            name: 'create-work-order',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                child: const WorkOrderCreationPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                          .chain(CurveTween(curve: Curves.easeInOut)),
                    ),
                    child: child,
                  );
                },
              );
            },
          ),

          // Alert Management Module
          GoRoute(
            path: '/al/center',
            name: 'alert-center',
            pageBuilder: (context, state) => CustomTransitionPage(
                child: const AlertManagementPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                );
              },
            ),
          ),

          // Analytics Module
          GoRoute(
            path: '/ar/dashboard',
            name: 'analytics-dashboard',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const AnalyticsDashboard(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                );
              },
            ),
          ),

          // System Settings
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: const SettingsPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
    ],
  );
});

// Alias for main.dart compatibility
final routerProvider = appRouterProvider;
