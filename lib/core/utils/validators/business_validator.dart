import '../../../domain/models/work_order.dart';
import '../../../domain/models/cart.dart';
import '../../../domain/models/alert.dart';

/// Utility class for business logic validation
class BusinessValidator {
  /// Validate work order creation data
  static List<String> validateWorkOrderCreation({
    required WorkOrderType? type,
    required Priority? priority,
    required String description,
    required String cartId,
    required DateTime? scheduledAt,
    required String? technician,
  }) {
    final errors = <String>[];

    if (type == null) {
      errors.add('Work order type is required');
    }

    if (priority == null) {
      errors.add('Priority is required');
    }

    if (description.trim().length < 10) {
      errors.add('Description must be at least 10 characters');
    }

    if (cartId.isEmpty) {
      errors.add('Cart ID is required');
    }

    if (scheduledAt == null) {
      errors.add('Scheduled date/time is required');
    } else if (scheduledAt.isBefore(DateTime.now())) {
      errors.add('Scheduled time cannot be in the past');
    }

    if (technician == null || technician.trim().isEmpty) {
      errors.add('Assigned technician is required');
    }

    return errors;
  }

  /// Validate cart registration data
  static List<String> validateCartRegistration({
    required String vinNumber,
    required String manufacturer,
    required String model,
    required int? year,
    required String color,
    required String batteryType,
    required double? voltage,
    required int? seating,
    required double? maxSpeed,
  }) {
    final errors = <String>[];

    if (vinNumber.trim().isEmpty) {
      errors.add('VIN number is required');
    } else if (vinNumber.length < 17) {
      errors.add('VIN number must be at least 17 characters');
    }

    if (manufacturer.trim().isEmpty) {
      errors.add('Manufacturer is required');
    }

    if (model.trim().isEmpty) {
      errors.add('Model is required');
    }

    if (year == null || year < 1900 || year > DateTime.now().year + 1) {
      errors.add('Valid year is required');
    }

    if (color.trim().isEmpty) {
      errors.add('Color is required');
    }

    if (batteryType.trim().isEmpty) {
      errors.add('Battery type is required');
    }

    if (voltage == null || voltage <= 0) {
      errors.add('Valid voltage is required');
    }

    if (seating == null || seating <= 0) {
      errors.add('Valid seating capacity is required');
    }

    if (maxSpeed == null || maxSpeed <= 0) {
      errors.add('Valid maximum speed is required');
    }

    return errors;
  }

  /// Validate alert escalation
  static List<String> validateAlertEscalation({
    required Alert alert,
    required int escalationLevel,
  }) {
    final errors = <String>[];

    if (alert.state != AlertStatus.acknowledged) {
      errors.add('Alert must be acknowledged before escalation');
    }

    if (escalationLevel < 1 || escalationLevel > 5) {
      errors.add('Escalation level must be between 1 and 5');
    }

    if (alert.escalationLevel != null &&
        escalationLevel <= alert.escalationLevel!) {
      errors.add('New escalation level must be higher than current level');
    }

    return errors;
  }

  /// Validate maintenance schedule
  static List<String> validateMaintenanceSchedule({
    required DateTime scheduledDate,
    required Duration estimatedDuration,
    required String cartId,
    required List<String> requiredParts,
  }) {
    final errors = <String>[];

    if (scheduledDate.isBefore(DateTime.now())) {
      errors.add('Scheduled date cannot be in the past');
    }

    if (estimatedDuration.inMinutes < 30) {
      errors.add('Estimated duration must be at least 30 minutes');
    }

    if (cartId.isEmpty) {
      errors.add('Cart ID is required');
    }

    if (requiredParts.isEmpty) {
      errors.add('At least one part is required for maintenance');
    }

    return errors;
  }

  /// Validate cart status change
  static List<String> validateCartStatusChange({
    required Cart cart,
    required CartStatus newStatus,
  }) {
    final errors = <String>[];

    // Cannot change to the same status
    if (cart.status == newStatus) {
      errors.add('Cart is already in the specified status');
    }

    // Business rules for status transitions
    switch (cart.status) {
      case CartStatus.maintenance:
        if (newStatus == CartStatus.active) {
          // Check if maintenance is completed
          // This would require checking work orders
        }
        break;
      case CartStatus.charging:
        if (newStatus == CartStatus.active) {
          // Note: Battery level check would require telemetry data
          // For now, we'll skip this validation
          // TODO: Implement battery level check when telemetry is available
        }
        break;
      default:
        // Other transitions are generally allowed
        break;
    }

    return errors;
  }

  /// Validate technician assignment
  static List<String> validateTechnicianAssignment({
    required String technicianId,
    required DateTime scheduledTime,
    required Duration estimatedDuration,
    required List<String> technicianWorkload,
  }) {
    final errors = <String>[];

    if (technicianId.isEmpty) {
      errors.add('Technician ID is required');
    }

    if (scheduledTime.isBefore(DateTime.now())) {
      errors.add('Scheduled time cannot be in the past');
    }

    if (estimatedDuration.inMinutes < 15) {
      errors.add('Estimated duration must be at least 15 minutes');
    }

    // Check for scheduling conflicts
    // TODO: Implement scheduling conflict detection
    // final endTime = scheduledTime.add(estimatedDuration);
    // for (final workload in technicianWorkload) {
    //   // This would require parsing workload data to check for conflicts
    //   // Implementation depends on workload data structure
    // }

    return errors;
  }

  /// Validate inventory levels
  static List<String> validateInventoryLevels({
    required Map<String, int> requiredParts,
    required Map<String, int> availableInventory,
  }) {
    final errors = <String>[];

    for (final entry in requiredParts.entries) {
      final partId = entry.key;
      final requiredQuantity = entry.value;
      final availableQuantity = availableInventory[partId] ?? 0;

      if (availableQuantity < requiredQuantity) {
        errors.add(
            'Insufficient inventory for part $partId. Required: $requiredQuantity, Available: $availableQuantity');
      }
    }

    return errors;
  }
}
