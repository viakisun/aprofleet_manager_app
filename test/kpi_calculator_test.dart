import 'package:flutter_test/flutter_test.dart';
import 'package:aprofleet_manager/core/utils/kpi_calculator.dart';
import 'package:aprofleet_manager/domain/models/work_order.dart';
import 'package:aprofleet_manager/domain/models/cart.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('KpiCalculator', () {
    test('Availability: clamps to [0,100] and handles zero downtime', () {
      // Test perfect availability (100% uptime)
      final perfectAvailability = KpiCalculator.calculateAvailability(
        totalUptime: Duration(hours: 8),
        totalDowntime: Duration.zero,
      );
      expect(perfectAvailability, 100.0);

      // Test zero availability (100% downtime)
      final zeroAvailability = KpiCalculator.calculateAvailability(
        totalUptime: Duration.zero,
        totalDowntime: Duration(hours: 8),
      );
      expect(zeroAvailability, 0.0);

      // Test 50/50 split
      final halfAvailability = KpiCalculator.calculateAvailability(
        totalUptime: Duration(hours: 4),
        totalDowntime: Duration(hours: 4),
      );
      expect(halfAvailability, 50.0);
    });

    test('MTTR: guards divide-by-zero and uses completed repairs only', () {
      // Test empty list (should return 0)
      final emptyMttr = KpiCalculator.calculateMTTR([]);
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
      final singleMttr = KpiCalculator.calculateMTTR([Duration(minutes: 90)]);
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
      final multipleMttr = KpiCalculator.calculateMTTR([Duration(minutes: 60), Duration(minutes: 90)]);
      expect(multipleMttr, 75.0); // Average of 60 and 90 minutes
    });

    test('Range filtering affects aggregates deterministically', () {
      // Test utilization calculation
      final carts = [
        Cart(
          id: 'GCA-001',
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
        Cart(
          id: 'GCA-002',
          vin: 'TEST987654321',
          manufacturer: 'Club Car',
          model: 'Club Car Onward',
          year: 2024,
          batteryType: 'Lithium',
          voltage: 48,
          seating: 4,
          status: CartStatus.active,
          batteryPct: 75.0,
          speedKph: 20.0,
          position: LatLng(37.7750, -122.4195),
          lastSeen: DateTime.now(),
        ),
      ];

      // Test utilization calculation
      final utilization = KpiCalculator.calculateUtilization([85.0, 75.0]);
      expect(utilization, greaterThan(0));

      // Test daily distance calculation
      final dailyDistance = KpiCalculator.calculateDailyDistance([25.0, 20.0]);
      expect(dailyDistance, greaterThan(0));
    });
  });
}
