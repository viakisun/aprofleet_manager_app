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
            builder: (context, state) => const LiveMapView(),
          ),
          GoRoute(
            path: '/rt/cart/:id',
            name: 'cart-detail',
            builder: (context, state) {
              final cartId = state.pathParameters['id']!;
              return CartDetailMonitor(cartId: cartId);
            },
          ),

          // Cart Management Module
          GoRoute(
            path: '/cm/list',
            name: 'cart-inventory',
            builder: (context, state) => const CartInventoryList(),
          ),
          GoRoute(
            path: '/cm/register',
            name: 'cart-registration',
            builder: (context, state) => const CartRegistration(),
          ),

          // Maintenance Module
          GoRoute(
            path: '/mm/list',
            name: 'work-order-list',
            builder: (context, state) => const WorkOrderList(),
          ),
          GoRoute(
            path: '/mm/create',
            name: 'create-work-order',
            builder: (context, state) {
              final cartId = state.uri.queryParameters['cart'];
              return CreateWorkOrder(selectedCartId: cartId);
            },
          ),

          // Alert Management Module
          GoRoute(
            path: '/al/center',
            name: 'alert-center',
            builder: (context, state) => const AlertCenter(),
          ),

          // Analytics Module
          GoRoute(
            path: '/ar/dashboard',
            name: 'analytics-dashboard',
            builder: (context, state) => const AnalyticsDashboard(),
          ),

          // System Settings (Stub)
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const Scaffold(
              body: Center(
                child: Text('Settings - Coming Soon'),
              ),
            ),
          ),
        ],
      ),
    ],
  );
});
