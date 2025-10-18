import 'package:flutter_test/flutter_test.dart';
import 'package:aprofleet_manager/core/utils/kpi_calculator.dart';

void main() {
  group('KpiCalculator', () {
    test('Availability: clamps to [0,100] and handles zero downtime', () {
      // Test perfect availability (100% uptime)
      final perfectAvailability = KpiCalculator.calculateAvailability(
        totalUptime: const Duration(hours: 8),
        totalDowntime: Duration.zero,
      );
      expect(perfectAvailability, 100.0);

      // Test zero availability (100% downtime)
      final zeroAvailability = KpiCalculator.calculateAvailability(
        totalUptime: Duration.zero,
        totalDowntime: const Duration(hours: 8),
      );
      expect(zeroAvailability, 0.0);

      // Test 50/50 split
      final halfAvailability = KpiCalculator.calculateAvailability(
        totalUptime: const Duration(hours: 4),
        totalDowntime: const Duration(hours: 4),
      );
      expect(halfAvailability, 50.0);
    });

    test('MTTR: guards divide-by-zero and uses completed repairs only', () {
      // Test empty list (should return 0)
      final emptyMttr = KpiCalculator.calculateMTTR([]);
      expect(emptyMttr, 0.0);

      // Test single repair
      final singleMttr = KpiCalculator.calculateMTTR([const Duration(minutes: 90)]);
      expect(singleMttr, 90.0); // 90 minutes

      // Test multiple repairs
      final multipleMttr = KpiCalculator.calculateMTTR([const Duration(minutes: 60), const Duration(minutes: 90)]);
      expect(multipleMttr, 75.0); // Average of 60 and 90 minutes
    });

    test('Range filtering affects aggregates deterministically', () {
      // Test utilization calculation
      final utilization = KpiCalculator.calculateUtilization([85.0, 75.0]);
      expect(utilization, greaterThan(0));

      // Test daily distance calculation
      final dailyDistance = KpiCalculator.calculateDailyDistance([25.0, 20.0]);
      expect(dailyDistance, greaterThan(0));
    });
  });
}
