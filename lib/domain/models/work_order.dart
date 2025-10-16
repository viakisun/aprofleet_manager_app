import 'package:freezed_annotation/freezed_annotation.dart';

part 'work_order.freezed.dart';
part 'work_order.g.dart';

enum Priority {
  @JsonValue('p1')
  p1,
  @JsonValue('p2')
  p2,
  @JsonValue('p3')
  p3,
  @JsonValue('p4')
  p4,
}

extension PriorityExtension on Priority {
  String get displayName {
    switch (this) {
      case Priority.p1:
        return 'P1 (Critical)';
      case Priority.p2:
        return 'P2 (High)';
      case Priority.p3:
        return 'P3 (Normal)';
      case Priority.p4:
        return 'P4 (Low)';
    }
  }

  String get fullName {
    switch (this) {
      case Priority.p1:
        return 'P1 - Critical';
      case Priority.p2:
        return 'P2 - High';
      case Priority.p3:
        return 'P3 - Normal';
      case Priority.p4:
        return 'P4 - Low';
    }
  }
}

@freezed
class WoPart with _$WoPart {
  const factory WoPart({
    required String id,
    required String name,
    required int quantity,
    String? notes,
    String? serialNumber,
  }) = _WoPart;

  factory WoPart.fromJson(Map<String, dynamic> json) => _$WoPartFromJson(json);
}

@freezed
class WorkOrder with _$WorkOrder {
  const factory WorkOrder({
    required String id,
    required WorkOrderType type,
    required Priority priority,
    required String cartId,
    required String description,
    required WorkOrderStatus status,
    required DateTime createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    String? technician,
    List<WoPart>? parts,
    String? location,
    String? notes,
    Map<String, bool>? checklist,
  }) = _WorkOrder;

  factory WorkOrder.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderFromJson(json);
}

@freezed
class WorkOrderDraft with _$WorkOrderDraft {
  const factory WorkOrderDraft({
    required WorkOrderType type,
    required Priority priority,
    required String description,
    required String cartId,
    String? location,
    DateTime? scheduledAt,
    Duration? estimatedDuration,
    String? technician,
    List<WoPart>? parts,
    Map<String, bool>? checklist,
    String? notes,
  }) = _WorkOrderDraft;

  factory WorkOrderDraft.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderDraftFromJson(json);
}

@freezed
class WorkOrderFilter with _$WorkOrderFilter {
  const factory WorkOrderFilter({
    Set<WorkOrderStatus>? statuses,
    Set<Priority>? priorities,
    Set<WorkOrderType>? types,
    String? cartId,
    String? technician,
    DateTime? fromDate,
    DateTime? toDate,
  }) = _WorkOrderFilter;

  factory WorkOrderFilter.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderFilterFromJson(json);
}

enum WorkOrderType {
  @JsonValue('emergencyRepair')
  emergencyRepair,
  @JsonValue('preventive')
  preventive,
  @JsonValue('battery')
  battery,
  @JsonValue('tire')
  tire,
  @JsonValue('safety')
  safety,
  @JsonValue('other')
  other,
}

enum WorkOrderStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('pending')
  pending,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('on_hold')
  onHold,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

extension WorkOrderTypeExtension on WorkOrderType {
  String get displayName {
    switch (this) {
      case WorkOrderType.emergencyRepair:
        return 'EMERGENCY REPAIR';
      case WorkOrderType.preventive:
        return 'PREVENTIVE';
      case WorkOrderType.battery:
        return 'BATTERY';
      case WorkOrderType.tire:
        return 'TIRE';
      case WorkOrderType.safety:
        return 'SAFETY';
      case WorkOrderType.other:
        return 'OTHER';
    }
  }
}

extension WorkOrderStatusExtension on WorkOrderStatus {
  String get displayName {
    switch (this) {
      case WorkOrderStatus.draft:
        return 'DRAFT';
      case WorkOrderStatus.pending:
        return 'PENDING';
      case WorkOrderStatus.inProgress:
        return 'IN PROGRESS';
      case WorkOrderStatus.onHold:
        return 'ON HOLD';
      case WorkOrderStatus.completed:
        return 'COMPLETED';
      case WorkOrderStatus.cancelled:
        return 'CANCELLED';
    }
  }
}
