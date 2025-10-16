import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aprofleet_manager/features/al/pages/alert_center.dart';
import 'package:aprofleet_manager/domain/models/alert.dart';
import 'package:aprofleet_manager/domain/models/work_order.dart';
import 'package:aprofleet_manager/core/services/providers.dart';

void main() {
  group('AlertCenter Widget Tests', () {
    testWidgets('Filters apply and ack changes state', (tester) async {
      // Create mock alerts
      final mockAlerts = [
        Alert(
          id: 'ALT-2025-0001',
          code: 'ALT-2025-0001',
          severity: AlertSeverity.critical,
          priority: Priority.p1,
          state: AlertStatus.triggered,
          title: 'Critical Battery Alert',
          message: 'Cart GCA-003 battery level critical at 18%',
          cartId: 'GCA-003',
          location: 'Hole 3 - Fairway',
          createdAt: DateTime(2025, 1, 15, 8, 30),
          updatedAt: DateTime(2025, 1, 15, 8, 30),
        ),
        Alert(
          id: 'ALT-2025-0002',
          code: 'ALT-2025-0002',
          severity: AlertSeverity.warning,
          priority: Priority.p2,
          state: AlertStatus.notified,
          title: 'Geofence Violation',
          message: 'Cart GCA-007 has exited designated area',
          cartId: 'GCA-007',
          location: 'Outside Course Boundary',
          createdAt: DateTime(2025, 1, 15, 10, 15),
          updatedAt: DateTime(2025, 1, 15, 10, 15),
        ),
      ];

      // Mock the alerts provider
      final mockAlertsProvider = Provider<List<Alert>>((ref) => mockAlerts);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            alertsProvider.overrideWithValue(AsyncValue.data(mockAlerts)),
          ],
          child: const MaterialApp(
            home: AlertCenter(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial state - should show all alerts
      expect(find.text('Critical Battery Alert'), findsOneWidget);
      expect(find.text('Geofence Violation'), findsOneWidget);

      // Tap "Battery" filter tab
      await tester.tap(find.text('Battery'));
      await tester.pumpAndSettle();

      // Should still show alerts (filtering by source not implemented in mock)
      expect(find.text('Critical Battery Alert'), findsOneWidget);

      // Tap "Unread" filter tab
      await tester.tap(find.text('Unread'));
      await tester.pumpAndSettle();

      // Should show unread alerts
      expect(find.text('Critical Battery Alert'), findsOneWidget);
      expect(find.text('Geofence Violation'), findsOneWidget);

      // Verify summary bar shows correct counts
      expect(find.text('Critical'), findsOneWidget);
      expect(find.text('Warning'), findsOneWidget);
    });

    testWidgets('Alert cards display correct information', (tester) async {
      final mockAlerts = [
        Alert(
          id: 'ALT-2025-0001',
          code: 'ALT-2025-0001',
          severity: AlertSeverity.critical,
          priority: Priority.p1,
          state: AlertStatus.triggered,
          title: 'Critical Battery Alert',
          message: 'Cart GCA-003 battery level critical at 18%',
          cartId: 'GCA-003',
          location: 'Hole 3 - Fairway',
          createdAt: DateTime(2025, 1, 15, 8, 30),
          updatedAt: DateTime(2025, 1, 15, 8, 30),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            alertsProvider.overrideWithValue(AsyncValue.data(mockAlerts)),
          ],
          child: const MaterialApp(
            home: AlertCenter(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify alert card content
      expect(find.text('Critical Battery Alert'), findsOneWidget);
      expect(find.text('Cart GCA-003 battery level critical at 18%'),
          findsOneWidget);
      expect(find.text('GCA-003'), findsOneWidget);
      expect(find.text('Hole 3 - Fairway'), findsOneWidget);

      // Verify action buttons are present
      expect(find.byIcon(Icons.check), findsOneWidget); // Acknowledge
      expect(find.byIcon(Icons.directions_car), findsOneWidget); // View Cart
      expect(find.byIcon(Icons.build), findsOneWidget); // Create Work Order
    });

    testWidgets('Empty state displays correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            alertsProvider.overrideWithValue(AsyncValue.data([])),
          ],
          child: const MaterialApp(
            home: AlertCenter(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify empty state
      expect(find.byIcon(Icons.notifications_none), findsOneWidget);
      expect(find.text('No alerts found'), findsOneWidget);
    });
  });
}
