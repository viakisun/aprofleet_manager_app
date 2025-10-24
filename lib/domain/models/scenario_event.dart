import 'package:latlong2/latlong.dart';
import 'alert.dart';
import 'alert_action.dart';
import 'cart.dart';
import 'work_order.dart';

/// Type of scenario event
enum ScenarioEventType {
  alertTrigger,      // Alert is triggered
  stateChange,       // Cart state changes
  positionUpdate,    // Cart position updates
  telemetryUpdate,   // Cart telemetry updates
  info,              // Informational message
}

/// Scenario event definition
class ScenarioEvent {
  /// Relative time from scenario start (in seconds)
  final int offsetSeconds;

  /// Type of event
  final ScenarioEventType type;

  /// Cart ID this event affects
  final String cartId;

  /// Event title
  final String title;

  /// Event description/message
  final String message;

  /// Alert severity (for alert events)
  final AlertSeverity? severity;

  /// Alert priority (for alert events)
  final Priority? priority;

  /// Available actions for this event
  final List<AlertActionType>? availableActions;

  /// Recommended action
  final AlertActionType? recommendedAction;

  /// New position (for position update events)
  final LatLng? newPosition;

  /// New cart status (for state change events)
  final CartStatus? newStatus;

  /// Telemetry changes (for telemetry update events)
  final Map<String, dynamic>? telemetryChanges;

  /// Expected action outcome
  final Map<AlertActionType, AlertActionResult>? actionOutcomes;

  const ScenarioEvent({
    required this.offsetSeconds,
    required this.type,
    required this.cartId,
    required this.title,
    required this.message,
    this.severity,
    this.priority,
    this.availableActions,
    this.recommendedAction,
    this.newPosition,
    this.newStatus,
    this.telemetryChanges,
    this.actionOutcomes,
  });

  /// Create an alert trigger event
  factory ScenarioEvent.alert({
    required int offsetSeconds,
    required String cartId,
    required String title,
    required String message,
    required AlertSeverity severity,
    required Priority priority,
    required List<AlertActionType> availableActions,
    AlertActionType? recommendedAction,
    Map<AlertActionType, AlertActionResult>? actionOutcomes,
  }) {
    return ScenarioEvent(
      offsetSeconds: offsetSeconds,
      type: ScenarioEventType.alertTrigger,
      cartId: cartId,
      title: title,
      message: message,
      severity: severity,
      priority: priority,
      availableActions: availableActions,
      recommendedAction: recommendedAction,
      actionOutcomes: actionOutcomes,
    );
  }

  /// Create a state change event
  factory ScenarioEvent.stateChange({
    required int offsetSeconds,
    required String cartId,
    required String title,
    required String message,
    required CartStatus newStatus,
  }) {
    return ScenarioEvent(
      offsetSeconds: offsetSeconds,
      type: ScenarioEventType.stateChange,
      cartId: cartId,
      title: title,
      message: message,
      newStatus: newStatus,
    );
  }

  /// Create a position update event
  factory ScenarioEvent.positionUpdate({
    required int offsetSeconds,
    required String cartId,
    required String title,
    required LatLng newPosition,
  }) {
    return ScenarioEvent(
      offsetSeconds: offsetSeconds,
      type: ScenarioEventType.positionUpdate,
      cartId: cartId,
      title: title,
      message: 'Position updated to ${newPosition.latitude.toStringAsFixed(6)}, ${newPosition.longitude.toStringAsFixed(6)}',
      newPosition: newPosition,
    );
  }

  /// Create an info event
  factory ScenarioEvent.info({
    required int offsetSeconds,
    required String title,
    required String message,
    String cartId = 'SYSTEM',
  }) {
    return ScenarioEvent(
      offsetSeconds: offsetSeconds,
      type: ScenarioEventType.info,
      cartId: cartId,
      title: title,
      message: message,
    );
  }

  /// Format offset as time string (MM:SS)
  String get timeString {
    final minutes = offsetSeconds ~/ 60;
    final seconds = offsetSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get icon for event type
  String get icon {
    switch (type) {
      case ScenarioEventType.alertTrigger:
        return severity == AlertSeverity.critical ? '🔴' :
               severity == AlertSeverity.warning ? '🟡' : '🟢';
      case ScenarioEventType.stateChange:
        return '🔄';
      case ScenarioEventType.positionUpdate:
        return '📍';
      case ScenarioEventType.telemetryUpdate:
        return '📊';
      case ScenarioEventType.info:
        return 'ℹ️';
    }
  }
}

/// A complete scenario with timeline of events
class Scenario {
  final String id;
  final String name;
  final String description;
  final List<ScenarioEvent> events;
  final Duration totalDuration;

  const Scenario({
    required this.id,
    required this.name,
    required this.description,
    required this.events,
    required this.totalDuration,
  });

  /// Get events sorted by time
  List<ScenarioEvent> get sortedEvents {
    final sorted = List<ScenarioEvent>.from(events);
    sorted.sort((a, b) => a.offsetSeconds.compareTo(b.offsetSeconds));
    return sorted;
  }

  /// Get next event after given offset
  ScenarioEvent? getNextEvent(int currentOffsetSeconds) {
    for (final event in sortedEvents) {
      if (event.offsetSeconds > currentOffsetSeconds) {
        return event;
      }
    }
    return null;
  }
}
