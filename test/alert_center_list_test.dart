import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aprofleet_manager/features/alert_management/pages/alert_management_page.dart';
import 'package:aprofleet_manager/domain/models/alert.dart';
import 'package:aprofleet_manager/domain/models/work_order.dart';
import 'package:aprofleet_manager/core/services/providers.dart';

void main() {
  group('AlertCenter Widget Tests', () {
    testWidgets('Widget loads without crashing', (tester) async {
      // 더 큰 화면 크기 설정하여 오버플로우 방지
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      
      try {
        // Create mock alerts
        final mockAlerts = [
          Alert(
            id: 'ALT-2025-0001',
            code: 'ALT-2025-0001',
            severity: AlertSeverity.critical,
            priority: Priority.p1,
            state: AlertStatus.triggered,
            title: 'Critical Battery Alert',
            message: 'Cart APRO-003 battery level critical at 18%',
            cartId: 'APRO-003',
            location: 'Hole 3 - Fairway',
            createdAt: DateTime(2025, 1, 15, 8, 30),
            updatedAt: DateTime(2025, 1, 15, 8, 30),
          ),
        ];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              alertsProvider.overrideWith((ref) async => mockAlerts),
            ],
            child: const MaterialApp(
              home: AlertManagementPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify that the widget loads (basic smoke test)
        expect(find.byType(AlertManagementPage), findsOneWidget);
      } finally {
        // 화면 크기 원상복구
        await tester.binding.setSurfaceSize(null);
      }
    });

    testWidgets('Empty state displays correctly', (tester) async {
      // 더 큰 화면 크기 설정
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      
      try {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              alertsProvider.overrideWith((ref) async => []),
            ],
            child: const MaterialApp(
              home: AlertManagementPage(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify empty state
        expect(find.byIcon(Icons.notifications_none), findsOneWidget);
        expect(find.text('No alerts found'), findsOneWidget);
      } finally {
        // 화면 크기 원상복구
        await tester.binding.setSurfaceSize(null);
      }
    });
  });
}
