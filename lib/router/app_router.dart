import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/rt/pages/live_map_view.dart';
import '../features/rt/pages/cart_detail_monitor.dart';
import '../features/cm/pages/cart_inventory_list.dart';
import '../features/cm/pages/cart_registration.dart';
import '../features/mm/pages/work_order_list.dart';
import '../features/mm/pages/create_work_order.dart';
import '../features/al/pages/alert_center.dart';
import '../features/ar/pages/analytics_dashboard.dart';
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
              final cartId = state.uri.queryParameters['cart'];
              return CustomTransitionPage(
                child: const CreateWorkOrder(),
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
              child: const AlertCenter(),
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
