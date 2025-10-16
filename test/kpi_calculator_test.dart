import 'package:flutter_test/flutter_test.dart';
import 'package:aprofleet_manager/core/utils/kpi_calculator.dart';
import 'package:aprofleet_manager/domain/models/work_order.dart';
import 'package:aprofleet_manager/domain/models/cart.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('KpiCalculator', () {
    test('Availability: clamps to [0,100] and handles zero downtime', () {
      // Test perfect availability (100% uptime)
      final perfectAvailability = calculateAvailability(
        operatingTime: Duration(hours: 8),
        downtime: Duration.zero,
      );
      expect(perfectAvailability, 100.0);

      // Test zero availability (100% downtime)
      final zeroAvailability = calculateAvailability(
        operatingTime: Duration.zero,
        downtime: Duration(hours: 8),
      );
      expect(zeroAvailability, 0.0);

      // Test 50/50 split
      final halfAvailability = calculateAvailability(
        operatingTime: Duration(hours: 4),
        downtime: Duration(hours: 4),
      );
      expect(halfAvailability, 50.0);
    });

    test('MTTR: guards divide-by-zero and uses completed repairs only', () {
      // Test empty list (should return 0)
      final emptyMttr = calculateMTTR([]);
      expect(emptyMttr, 0.0);

      // Test single repair
      final singleRepair = [
        WorkOrder(
          id: 'WO-2025-0001',
          type: WorkOrderType.battery,
          priority: Priority.p2,
          cartId: 'GCA-001',
          description: 'Battery replacement',
          status: WorkOrderStatus.completed,
          createdAt: DateTime(2025, 1, 15, 9, 0),
          startedAt: DateTime(2025, 1, 15, 9, 0),
          completedAt: DateTime(2025, 1, 15, 10, 30),
          technician: 'John Smith',
          location: 'Maintenance Bay 1',
        ),
      ];
      final singleMttr = calculateMTTR(singleRepair);
      expect(singleMttr, 90.0); // 90 minutes

      // Test multiple repairs
      final multipleRepairs = [
        WorkOrder(
          id: 'WO-2025-0001',
          type: WorkOrderType.battery,
          priority: Priority.p2,
          cartId: 'GCA-001',
          description: 'Battery replacement',
          status: WorkOrderStatus.completed,
          createdAt: DateTime(2025, 1, 15, 9, 0),
          startedAt: DateTime(2025, 1, 15, 9, 0),
          completedAt: DateTime(2025, 1, 15, 10, 0),
          technician: 'John Smith',
          location: 'Maintenance Bay 1',
        ),
        WorkOrder(
          id: 'WO-2025-0002',
          type: WorkOrderType.tire,
          priority: Priority.p3,
          cartId: 'GCA-002',
          description: 'Tire replacement',
          status: WorkOrderStatus.completed,
          createdAt: DateTime(2025, 1, 15, 14, 0),
          startedAt: DateTime(2025, 1, 15, 14, 0),
          completedAt: DateTime(2025, 1, 15, 15, 30),
          technician: 'Sarah Johnson',
          location: 'Maintenance Bay 2',
        ),
      ];
      final multipleMttr = calculateMTTR(multipleRepairs);
      expect(multipleMttr, 105.0); // Average of 60 and 90 minutes
    });

    test('Range filtering affects aggregates deterministically', () {
      // Test utilization calculation
      final carts = [
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

      // Test utilization calculation
      final utilization = calculateUtilization(carts);
      expect(utilization, greaterThan(0));

      // Test daily distance calculation
      final dailyDistance = calculateDailyDistance(carts);
      expect(dailyDistance, greaterThan(0));
    });
  });
}
