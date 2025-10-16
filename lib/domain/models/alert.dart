import 'package:freezed_annotation/freezed_annotation.dart';
import 'work_order.dart';

part 'alert.freezed.dart';
part 'alert.g.dart';

@freezed
class Alert with _$Alert {
  const factory Alert({
    required String id,
    required String code,
    required AlertSeverity severity,
    required Priority priority,
    required AlertStatus state,
    required String title,
    required String message,
    String? cartId,
    String? location,
    required DateTime createdAt,
    required DateTime updatedAt,
    List<AlertAction>? actions,
    int? escalationLevel,
    DateTime? acknowledgedAt,
    String? acknowledgedBy,
    String? resolvedBy,
    DateTime? resolvedAt,
    String? notes,
  }) = _Alert;

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);
}

@freezed
class AlertAction with _$AlertAction {
  const factory AlertAction({
    required String type,
    required DateTime timestamp,
    String? userId,
    String? note,
    Map<String, dynamic>? metadata,
  }) = _AlertAction;

  factory AlertAction.fromJson(Map<String, dynamic> json) =>
      _$AlertActionFromJson(json);
}

@freezed
class AlertFilter with _$AlertFilter {
  const factory AlertFilter({
    Set<AlertSeverity>? severities,
    Set<AlertStatus>? states,
    Set<Priority>? priorities,
    Set<AlertSource>? sources,
    String? cartId,
    DateTime? fromDate,
    DateTime? toDate,
    bool? unreadOnly,
  }) = _AlertFilter;

  factory AlertFilter.fromJson(Map<String, dynamic> json) =>
      _$AlertFilterFromJson(json);
}

@freezed
class AlertRules with _$AlertRules {
  const factory AlertRules({
    required Map<AlertSource, AlertRule> rules,
    required bool notificationsEnabled,
    required Map<Priority, Duration> slaResponse,
    required Map<Priority, Duration> slaResolution,
  }) = _AlertRules;

  factory AlertRules.fromJson(Map<String, dynamic> json) =>
      _$AlertRulesFromJson(json);
}

@freezed
class AlertRule with _$AlertRule {
  const factory AlertRule({
    required bool enabled,
    required double threshold,
    required AlertSeverity severity,
    required Priority priority,
    String? message,
  }) = _AlertRule;

  factory AlertRule.fromJson(Map<String, dynamic> json) =>
      _$AlertRuleFromJson(json);
}

enum AlertSeverity {
  @JsonValue('critical')
  critical,
  @JsonValue('warning')
  warning,
  @JsonValue('info')
  info,
  @JsonValue('success')
  success,
}

enum AlertStatus {
  @JsonValue('triggered')
  triggered,
  @JsonValue('notified')
  notified,
  @JsonValue('acknowledged')
  acknowledged,
  @JsonValue('escalated')
  escalated,
  @JsonValue('resolved')
  resolved,
}

enum AlertSource {
  @JsonValue('emergency')
  emergency,
  @JsonValue('battery')
  battery,
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('geofence')
  geofence,
  @JsonValue('temperature')
  temperature,
  @JsonValue('system')
  system,
}

extension AlertSeverityExtension on AlertSeverity {
  String get displayName {
    switch (this) {
      case AlertSeverity.critical:
        return 'CRITICAL';
      case AlertSeverity.warning:
        return 'WARNING';
      case AlertSeverity.info:
        return 'INFO';
      case AlertSeverity.success:
        return 'SUCCESS';
    }
  }
}

extension AlertStatusExtension on AlertStatus {
  String get displayName {
    switch (this) {
      case AlertStatus.triggered:
        return 'TRIGGERED';
      case AlertStatus.notified:
        return 'NOTIFIED';
      case AlertStatus.acknowledged:
        return 'ACKNOWLEDGED';
      case AlertStatus.escalated:
        return 'ESCALATED';
      case AlertStatus.resolved:
        return 'RESOLVED';
    }
  }
}

extension AlertSourceExtension on AlertSource {
  String get displayName {
    switch (this) {
      case AlertSource.emergency:
        return 'EMERGENCY';
      case AlertSource.battery:
        return 'BATTERY';
      case AlertSource.maintenance:
        return 'MAINTENANCE';
      case AlertSource.geofence:
        return 'GEOFENCE';
      case AlertSource.temperature:
        return 'TEMPERATURE';
      case AlertSource.system:
        return 'SYSTEM';
    }
  }
}
