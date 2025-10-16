import 'package:flutter_test/flutter_test.dart';
import 'package:aprofleet_manager/core/utils/code_formatters.dart';

void main() {
  group('CodeFormatters', () {
    test('WO-YYYY-#### zero-pads and increments within year', () {
      // Test work order ID formatting
      final woId1 = formatWorkOrderId(1, 2025);
      expect(woId1, 'WO-2025-0001');

      final woId42 = formatWorkOrderId(42, 2025);
      expect(woId42, 'WO-2025-0042');

      final woId123 = formatWorkOrderId(123, 2025);
      expect(woId123, 'WO-2025-0123');

      final woId9999 = formatWorkOrderId(9999, 2025);
      expect(woId9999, 'WO-2025-9999');
    });

    test('ALT-2025-#### maintains separate space from WO', () {
      // Test alert code formatting
      final altId1 = formatAlertId(1, 2025);
      expect(altId1, 'ALT-2025-0001');

      final altId9 = formatAlertId(9, 2025);
      expect(altId9, 'ALT-2025-0009');

      final altId10 = formatAlertId(10, 2025);
      expect(altId10, 'ALT-2025-0010');

      final altId123 = formatAlertId(123, 2025);
      expect(altId123, 'ALT-2025-0123');
    });

    test('Cart ID formatting with proper zero-padding', () {
      // Test cart ID formatting
      final cartId1 = formatCartId(1, 2025);
      expect(cartId1, 'GCA-001');

      final cartId12 = formatCartId(12, 2025);
      expect(cartId12, 'GCA-012');

      final cartId123 = formatCartId(123, 2025);
      expect(cartId123, 'GCA-123');
    });

    test('Year rollover resets counter', () {
      // Test that different years maintain separate counters
      final wo2025 = formatWorkOrderId(1, 2025);
      expect(wo2025, 'WO-2025-0001');

      final wo2026 = formatWorkOrderId(1, 2026);
      expect(wo2026, 'WO-2026-0001');

      // Same counter number, different year
      final alt2025 = formatAlertId(1, 2025);
      expect(alt2025, 'ALT-2025-0001');

      final alt2026 = formatAlertId(1, 2026);
      expect(alt2026, 'ALT-2026-0001');
    });

    test('Edge cases with zero and large numbers', () {
      // Test zero counter
      final woZero = formatWorkOrderId(0, 2025);
      expect(woZero, 'WO-2025-0000');

      // Test large counter
      final woLarge = formatWorkOrderId(99999, 2025);
      expect(woLarge, 'WO-2025-99999');

      // Test negative year (edge case)
      final woNegativeYear = formatWorkOrderId(1, -1);
      expect(woNegativeYear, 'WO--1-0001');
    });
  });
}
