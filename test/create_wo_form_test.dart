import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aprofleet_manager/features/service/pages/work_order_creation_page.dart';
import 'package:aprofleet_manager/domain/models/cart.dart';
import 'package:aprofleet_manager/core/services/providers.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('CreateWorkOrder Widget Tests', () {
    testWidgets('Widget loads without crashing', (tester) async {
      // 더 큰 화면 크기 설정하여 오버플로우 방지
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      try {
        // Mock carts for the dropdown
        final mockCarts = [
          Cart(
            id: 'APRO-001',
            vin: 'TEST123456789',
            manufacturer: 'E-Z-GO',
            model: 'E-Z-GO RXV',
            year: 2024,
            batteryType: 'Lithium',
            voltage: 48,
            seating: 4,
            status: CartStatus.active,
            batteryPct: 85.0,
            speedKph: 25.0,
            position: LatLng(37.7749, -122.4194),
            lastSeen: DateTime.now(),
          ),
        ];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              cartsProvider.overrideWith((ref) => Future.value(mockCarts)),
            ],
            child: const MaterialApp(
              home: WorkOrderCreationPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify that the widget loads (basic smoke test)
        expect(find.byType(WorkOrderCreationPage), findsOneWidget);
      } finally {
        // 화면 크기 원상복구
        await tester.binding.setSurfaceSize(null);
      }
    });
  });
}
