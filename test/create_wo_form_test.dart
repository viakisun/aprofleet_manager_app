import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aprofleet_manager/features/mm/pages/create_work_order.dart';
import 'package:aprofleet_manager/domain/models/cart.dart';
import 'package:aprofleet_manager/core/services/providers.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('CreateWorkOrder Widget Tests', () {
    testWidgets('Step validation and auto-priority by type', (tester) async {
      // Mock carts for the dropdown
      final mockCarts = [
        Cart(
          id: 'GCA-001',
          model: 'E-Z-GO RXV',
          status: CartStatus.active,
          batteryPct: 85.0,
          speedKph: 25.0,
          position: const LatLng(37.7749, -122.4194),
          lastSeenAt: DateTime.now(),
        ),
        Cart(
          id: 'GCA-002',
          model: 'Club Car Onward',
          status: CartStatus.active,
          batteryPct: 75.0,
          speedKph: 20.0,
          position: const LatLng(37.7750, -122.4195),
          lastSeenAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cartsProvider.overrideWithValue(AsyncValue.data(mockCarts)),
          ],
          child: const MaterialApp(
            home: CreateWorkOrder(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial state - Next button should be disabled
      expect(find.text('Next'), findsOneWidget);
      final nextButton = tester.widget<ActionButton>(find.text('Next'));
      expect(nextButton.onPressed, isNull);

      // Step 1: Select work order type
      await tester.tap(find.text('PREVENTIVE'));
      await tester.pump();

      // Verify auto-priority selection (Preventive should be P3)
      expect(find.text('P3'), findsOneWidget);

      // Enter description
      await tester.enterText(
        find.byType(TextFormField).first,
        'Replace low battery pack',
      );
      await tester.pump();

      // Next button should now be enabled
      final nextButtonEnabled = tester.widget<ActionButton>(find.text('Next'));
      expect(nextButtonEnabled.onPressed, isNotNull);

      // Tap Next to go to step 2
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Verify we're on step 2 (Cart & Location)
      expect(find.text('CART SELECTION'), findsOneWidget);

      // Select a cart
      await tester.tap(find.text('GCA-001 - E-Z-GO RXV'));
      await tester.pump();

      // Next button should be enabled for step 2
      final nextButtonStep2 = tester.widget<ActionButton>(find.text('Next'));
      expect(nextButtonStep2.onPressed, isNotNull);

      // Tap Next to go to step 3
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Verify we're on step 3 (Schedule & Tech)
      expect(find.text('SCHEDULE'), findsOneWidget);

      // Select date
      await tester.tap(find.text('Date'));
      await tester.pump();
      await tester.tap(find.text('OK'));
      await tester.pump();

      // Select time
      await tester.tap(find.text('Time'));
      await tester.pump();
      await tester.tap(find.text('OK'));
      await tester.pump();

      // Next button should be enabled for step 3
      final nextButtonStep3 = tester.widget<ActionButton>(find.text('Next'));
      expect(nextButtonStep3.onPressed, isNotNull);

      // Tap Next to go to step 4
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Verify we're on step 4 (Parts & Review)
      expect(find.text('WORK ORDER SUMMARY'), findsOneWidget);

      // Verify Create Work Order button is enabled
      final createButton =
          tester.widget<ActionButton>(find.text('Create Work Order'));
      expect(createButton.onPressed, isNotNull);
    });

    testWidgets('Auto-priority selection by work order type', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(
            home: CreateWorkOrder(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test Emergency Repair -> P1
      await tester.tap(find.text('EMERGENCY REPAIR'));
      await tester.pump();
      expect(find.text('P1'), findsOneWidget);

      // Test Battery -> P2
      await tester.tap(find.text('BATTERY'));
      await tester.pump();
      expect(find.text('P2'), findsOneWidget);

      // Test Preventive -> P3
      await tester.tap(find.text('PREVENTIVE'));
      await tester.pump();
      expect(find.text('P3'), findsOneWidget);

      // Test Other -> P4
      await tester.tap(find.text('OTHER'));
      await tester.pump();
      expect(find.text('P4'), findsOneWidget);
    });

    testWidgets('Draft save functionality', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(
            home: CreateWorkOrder(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Fill in basic information
      await tester.tap(find.text('PREVENTIVE'));
      await tester.pump();

      await tester.enterText(
        find.byType(TextFormField).first,
        'Test work order description',
      );
      await tester.pump();

      // Save Draft button should be enabled
      final saveDraftButton =
          tester.widget<TextButton>(find.text('Save Draft'));
      expect(saveDraftButton.onPressed, isNotNull);

      // Tap Save Draft
      await tester.tap(find.text('Save Draft'));
      await tester.pump();

      // Should show success message
      expect(find.text('Draft saved'), findsOneWidget);
    });
  });
}
