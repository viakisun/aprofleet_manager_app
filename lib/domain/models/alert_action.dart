import 'package:flutter/material.dart';

/// Alert action types that can be taken in response to events
enum AlertActionType {
  // Battery actions
  sendToCharging('충전소로 안내', Icons.ev_station, Colors.blue),
  assignReplacement('대체 카트 배정', Icons.swap_horiz, Colors.orange),
  stopOperation('운행 중지', Icons.stop_circle, Colors.red),

  // Maintenance actions
  createWorkOrder('정비 작업 생성', Icons.build, Colors.purple),
  scheduleMaintenance('정비 예약', Icons.calendar_today, Colors.indigo),
  assignTechnician('기사 배정', Icons.engineering, Colors.teal),

  // Emergency actions
  requestFieldCheck('현장 확인 요청', Icons.search, Colors.orange),
  activateGPS('GPS 추적 활성화', Icons.my_location, Colors.blue),
  escalateToManager('에스컬레이션', Icons.arrow_upward, Colors.red),
  sendEmergencyReturn('긴급 귀환 명령', Icons.home, Colors.red),

  // Communication actions
  contactDriver('운전자 연락', Icons.phone, Colors.green),
  notifySecurity('보안팀 알림', Icons.security, Colors.red),
  attemptReconnect('재연결 시도', Icons.refresh, Colors.blue),

  // Cooling and safety
  sendCoolingCommand('냉각 대기 명령', Icons.ac_unit, Colors.cyan),
  requestSafetyCheck('안전 확인 요청', Icons.health_and_safety, Colors.orange),

  // Monitoring
  continueMonitoring('모니터링 강화', Icons.visibility, Colors.amber),
  allowContinue('운행 계속 허가', Icons.check_circle, Colors.green),

  // System
  ignore('무시', Icons.close, Colors.grey);

  final String label;
  final IconData icon;
  final Color color;

  const AlertActionType(this.label, this.icon, this.color);
}

/// Result of an alert action execution
class AlertActionResult {
  final bool success;
  final String message;
  final String? nextState;
  final Duration? nextAlertDelay;

  const AlertActionResult({
    required this.success,
    required this.message,
    this.nextState,
    this.nextAlertDelay,
  });

  factory AlertActionResult.success(String message, {String? nextState}) {
    return AlertActionResult(
      success: true,
      message: message,
      nextState: nextState,
    );
  }

  factory AlertActionResult.failure(String message) {
    return AlertActionResult(
      success: false,
      message: message,
    );
  }

  factory AlertActionResult.withNextAlert(
    String message, {
    required Duration delay,
    String? nextState,
  }) {
    return AlertActionResult(
      success: true,
      message: message,
      nextAlertDelay: delay,
      nextState: nextState,
    );
  }
}

/// Available actions for different alert scenarios
class AlertActionConfig {
  final List<AlertActionType> quickActions;
  final AlertActionType? recommendedAction;

  const AlertActionConfig({
    required this.quickActions,
    this.recommendedAction,
  });

  /// Get actions for battery critical alert
  static AlertActionConfig forBatteryCritical() {
    return const AlertActionConfig(
      quickActions: [
        AlertActionType.sendEmergencyReturn,
        AlertActionType.assignReplacement,
        AlertActionType.stopOperation,
      ],
      recommendedAction: AlertActionType.sendEmergencyReturn,
    );
  }

  /// Get actions for battery warning alert
  static AlertActionConfig forBatteryWarning() {
    return const AlertActionConfig(
      quickActions: [
        AlertActionType.sendToCharging,
        AlertActionType.allowContinue,
        AlertActionType.ignore,
      ],
      recommendedAction: AlertActionType.sendToCharging,
    );
  }

  /// Get actions for temperature alert
  static AlertActionConfig forTemperature() {
    return const AlertActionConfig(
      quickActions: [
        AlertActionType.sendCoolingCommand,
        AlertActionType.scheduleMaintenance,
        AlertActionType.requestFieldCheck,
      ],
      recommendedAction: AlertActionType.sendCoolingCommand,
    );
  }

  /// Get actions for communication loss
  static AlertActionConfig forCommunicationLoss() {
    return const AlertActionConfig(
      quickActions: [
        AlertActionType.requestFieldCheck,
        AlertActionType.activateGPS,
        AlertActionType.escalateToManager,
      ],
      recommendedAction: AlertActionType.requestFieldCheck,
    );
  }

  /// Get actions for geofence violation
  static AlertActionConfig forGeofenceViolation() {
    return const AlertActionConfig(
      quickActions: [
        AlertActionType.sendEmergencyReturn,
        AlertActionType.contactDriver,
        AlertActionType.notifySecurity,
      ],
      recommendedAction: AlertActionType.sendEmergencyReturn,
    );
  }

  /// Get actions for maintenance alert
  static AlertActionConfig forMaintenance() {
    return const AlertActionConfig(
      quickActions: [
        AlertActionType.createWorkOrder,
        AlertActionType.assignTechnician,
        AlertActionType.scheduleMaintenance,
      ],
      recommendedAction: AlertActionType.createWorkOrder,
    );
  }

  /// Get actions for emergency brake detection
  static AlertActionConfig forEmergencyBrake() {
    return const AlertActionConfig(
      quickActions: [
        AlertActionType.requestSafetyCheck,
        AlertActionType.scheduleMaintenance,
        AlertActionType.assignReplacement,
      ],
      recommendedAction: AlertActionType.requestSafetyCheck,
    );
  }
}
