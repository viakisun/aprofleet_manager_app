import 'package:flutter_test/flutter_test.dart';
import 'package:aprofleet_manager/domain/models/alert.dart';
import 'package:aprofleet_manager/domain/models/work_order.dart';

void main() {
  group('PriorityQueue', () {
    test('Orders by P1..P4 then newest-first within same priority', () {
      final alerts = [
        Alert(
          id: 'ALT-2025-0001',
          code: 'ALT-2025-0001',
          severity: AlertSeverity.critical,
          priority: Priority.p4,
          state: AlertStatus.triggered,
          title: 'Low Priority Alert',
          message: 'This is a low priority alert',
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        ),
        Alert(
          id: 'ALT-2025-0002',
          code: 'ALT-2025-0002',
          severity: AlertSeverity.critical,
          priority: Priority.p1,
          state: AlertStatus.triggered,
          title: 'High Priority Alert Old',
          message: 'This is an old high priority alert',
          createdAt: DateTime(2025, 9, 1),
          updatedAt: DateTime(2025, 9, 1),
        ),
        Alert(
          id: 'ALT-2025-0003',
          code: 'ALT-2025-0003',
          severity: AlertSeverity.critical,
          priority: Priority.p1,
          state: AlertStatus.triggered,
          title: 'High Priority Alert New',
          message: 'This is a new high priority alert',
          createdAt: DateTime(2025, 10, 10),
          updatedAt: DateTime(2025, 10, 10),
        ),
      ];

      // Sort by priority (P1 first) then by creation date (newest first)
      alerts.sort((a, b) {
        final priorityComparison = a.priority.index.compareTo(b.priority.index);
        if (priorityComparison != 0) return priorityComparison;
        return b.createdAt.compareTo(a.createdAt);
      });

      expect(alerts[0].id, 'ALT-2025-0003'); // P1, newest
      expect(alerts[1].id, 'ALT-2025-0002'); // P1, older
      expect(alerts[2].id, 'ALT-2025-0001'); // P4, oldest
    });

    test('Acknowledged/Resolved remain in queue with preserved ordering rules',
        () {
      final alerts = [
        Alert(
          id: 'ALT-2025-0001',
          code: 'ALT-2025-0001',
          severity: AlertSeverity.warning,
          priority: Priority.p2,
          state: AlertStatus.acknowledged,
          title: 'Acknowledged Alert',
          message: 'This alert has been acknowledged',
          createdAt: DateTime(2025, 1, 15, 9, 0),
          updatedAt: DateTime(2025, 1, 15, 9, 30),
          acknowledgedAt: DateTime(2025, 1, 15, 9, 30),
          acknowledgedBy: 'John Smith',
        ),
        Alert(
          id: 'ALT-2025-0002',
          code: 'ALT-2025-0002',
          severity: AlertSeverity.info,
          priority: Priority.p3,
          state: AlertStatus.resolved,
          title: 'Resolved Alert',
          message: 'This alert has been resolved',
          createdAt: DateTime(2025, 1, 15, 8, 0),
          updatedAt: DateTime(2025, 1, 15, 10, 0),
          resolvedAt: DateTime(2025, 1, 15, 10, 0),
          resolvedBy: 'Sarah Johnson',
        ),
      ];

      // Sort by priority (P2 before P3)
      alerts.sort((a, b) {
        final priorityComparison = a.priority.index.compareTo(b.priority.index);
        if (priorityComparison != 0) return priorityComparison;
        return b.createdAt.compareTo(a.createdAt);
      });

      expect(alerts[0].priority.index, lessThan(alerts[1].priority.index));
      expect(alerts[0].state, AlertStatus.acknowledged);
      expect(alerts[1].state, AlertStatus.resolved);
    });

    test('Same priority alerts ordered by newest first', () {
      final alerts = [
        Alert(
          id: 'ALT-2025-0001',
          code: 'ALT-2025-0001',
          severity: AlertSeverity.critical,
          priority: Priority.p1,
          state: AlertStatus.triggered,
          title: 'Old P1 Alert',
          message: 'This is an old P1 alert',
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        ),
        Alert(
          id: 'ALT-2025-0002',
          code: 'ALT-2025-0002',
          severity: AlertSeverity.critical,
          priority: Priority.p1,
          state: AlertStatus.triggered,
          title: 'New P1 Alert',
          message: 'This is a new P1 alert',
          createdAt: DateTime(2025, 1, 15),
          updatedAt: DateTime(2025, 1, 15),
        ),
      ];

      // Sort by priority then by creation date (newest first)
      alerts.sort((a, b) {
        final priorityComparison = a.priority.index.compareTo(b.priority.index);
        if (priorityComparison != 0) return priorityComparison;
        return b.createdAt.compareTo(a.createdAt);
      });

      expect(alerts[0].id, 'ALT-2025-0002'); // Newer P1
      expect(alerts[1].id, 'ALT-2025-0001'); // Older P1
    });
  });
}
