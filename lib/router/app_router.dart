import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/pages/splash_screen.dart';
import '../features/auth/pages/onboarding_screen.dart';
import '../features/auth/pages/login_screen.dart';
import '../features/fleet/pages/live_map_view.dart';
import '../features/fleet/pages/cart_detail_monitor.dart';
import '../features/vehicles/pages/cart_inventory_list.dart';
import '../features/vehicles/pages/cart_registration.dart';
import '../features/service/pages/work_order_list_v2.dart';
import '../features/service/pages/work_order_creation_page.dart';
import '../features/alerts/pages/alert_management_page_v2.dart';
import '../features/analytics/pages/analytics_dashboard.dart';
import '../features/settings/pages/settings_page.dart';
import '../core/widgets/navigation_bar.dart';
import '../features/auth/controllers/auth_controller.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);

      // If still loading, stay on splash
      if (authState.isLoading) {
        return '/splash';
      }

      // If hasn't seen onboarding, go to onboarding
      if (!authState.hasSeenOnboarding) {
        return '/onboarding';
      }

      // If not logged in, go to login
      if (!authState.isLoggedIn) {
        return '/login';
      }

      // If logged in, allow access to main app
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Main app shell route
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
            pageBuilder: (context, state) {
              final cartId = state.uri.queryParameters['cartId'];
              return CustomTransitionPage(
                child: LiveMapView(initialCartId: cartId),
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

          // Cart Management Module (VEHICLES)
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
            path: '/cm/profile/:id',
            name: 'cart-profile',
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
              child: const WorkOrderListV2(),
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
              child: const AlertManagementPageV2(),
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
