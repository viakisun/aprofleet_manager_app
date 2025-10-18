import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'work_order.dart';
import '../../core/localization/app_localizations.dart';

part 'alert.freezed.dart';
part 'alert.g.dart';

enum AlertFilterType {
  all,
  unread,
  cart,
  battery,
  maintenance,
  geofence,
  system,
}

enum AlertCategory {
  cart,
  battery,
  maintenance,
  geofence,
  system,
  other,
}

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
    AlertCategory? category,
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
        return 'Critical';
      case AlertSeverity.warning:
        return 'Warning';
      case AlertSeverity.info:
        return 'Info';
      case AlertSeverity.success:
        return 'Success';
    }
  }

  String getDisplayName(BuildContext context) {
    final loc = AppLocalizations.of(context);
    switch (this) {
      case AlertSeverity.critical:
        return loc.alertSeverityCritical;
      case AlertSeverity.warning:
        return loc.alertSeverityWarning;
      case AlertSeverity.info:
        return loc.alertSeverityInfo;
      case AlertSeverity.success:
        return loc.alertSeveritySuccess;
    }
  }
}

extension AlertStatusExtension on AlertStatus {
  String getDisplayName(BuildContext context) {
    final loc = AppLocalizations.of(context);
    switch (this) {
      case AlertStatus.triggered:
        return loc.alertStatusTriggered;
      case AlertStatus.notified:
        return loc.alertStatusNotified;
      case AlertStatus.acknowledged:
        return loc.alertStatusAcknowledged;
      case AlertStatus.escalated:
        return loc.alertStatusEscalated;
      case AlertStatus.resolved:
        return loc.alertStatusResolved;
    }
  }
}

extension AlertSourceExtension on AlertSource {
  String getDisplayName(BuildContext context) {
    final loc = AppLocalizations.of(context);
    switch (this) {
      case AlertSource.emergency:
        return loc.alertSourceEmergency;
      case AlertSource.battery:
        return loc.alertSourceBattery;
      case AlertSource.maintenance:
        return loc.alertSourceMaintenance;
      case AlertSource.geofence:
        return loc.alertSourceGeofence;
      case AlertSource.temperature:
        return loc.alertSourceTemperature;
      case AlertSource.system:
        return loc.alertSourceSystem;
    }
  }
}
