import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/models/scenario_event.dart';
import '../../../domain/models/alert.dart';
import '../../../domain/models/alert_action.dart';
import '../../../domain/models/cart.dart';
import '../../../domain/models/work_order.dart';
import '../mock/mock_api.dart';

/// Scenario playback state
enum ScenarioState {
  idle,
  playing,
  paused,
  completed,
}

/// Scenario engine that executes scenarios with timeline
class ScenarioEngine {
  ScenarioEngine(this._mockApi);

  final MockApi _mockApi;

  // Current scenario
  Scenario? _currentScenario;

  // Playback state
  ScenarioState _state = ScenarioState.idle;
  int _currentOffsetSeconds = 0;
  int _playbackSpeed = 1; // 1x, 2x, 5x, 10x

  // Timers
  Timer? _playbackTimer;

  // Stream controllers
  final StreamController<ScenarioEvent> _eventController =
      StreamController<ScenarioEvent>.broadcast();
  final StreamController<ScenarioState> _stateController =
      StreamController<ScenarioState>.broadcast();
  final StreamController<int> _progressController =
      StreamController<int>.broadcast();

  // Getters
  ScenarioState get state => _state;
  Scenario? get currentScenario => _currentScenario;
  int get currentOffsetSeconds => _currentOffsetSeconds;
  int get playbackSpeed => _playbackSpeed;

  // Stream getters
  Stream<ScenarioEvent> get eventStream => _eventController.stream;
  Stream<ScenarioState> get stateStream => _stateController.stream;
  Stream<int> get progressStream => _progressController.stream;

  /// Load a scenario
  void loadScenario(Scenario scenario) {
    stop();
    _currentScenario = scenario;
    _currentOffsetSeconds = 0;
    _setState(ScenarioState.idle);
  }

  /// Start or resume playback
  void play() {
    if (_currentScenario == null) return;
    if (_state == ScenarioState.playing) return;
    if (_state == ScenarioState.completed) {
      // Restart from beginning
      _currentOffsetSeconds = 0;
    }

    _setState(ScenarioState.playing);
    _startPlaybackTimer();
  }

  /// Pause playback
  void pause() {
    if (_state != ScenarioState.playing) return;
    _playbackTimer?.cancel();
    _setState(ScenarioState.paused);
  }

  /// Stop playback and reset
  void stop() {
    _playbackTimer?.cancel();
    _currentOffsetSeconds = 0;
    _setState(ScenarioState.idle);
    _progressController.add(0);
  }

  /// Set playback speed (1x, 2x, 5x, 10x, 60x for demo)
  void setPlaybackSpeed(int speed) {
    if (![1, 2, 5, 10, 60].contains(speed)) return;
    final wasPlaying = _state == ScenarioState.playing;
    if (wasPlaying) {
      _playbackTimer?.cancel();
    }
    _playbackSpeed = speed;
    if (wasPlaying) {
      _startPlaybackTimer();
    }
  }

  /// Skip to specific offset
  void skipTo(int offsetSeconds) {
    if (_currentScenario == null) return;
    _currentOffsetSeconds = offsetSeconds.clamp(
      0,
      _currentScenario!.totalDuration.inSeconds,
    );
    _progressController.add(_currentOffsetSeconds);
  }

  /// Execute an action for an alert
  Future<AlertActionResult> executeAction(
    ScenarioEvent event,
    AlertActionType action,
  ) async {
    // Get outcome from event configuration
    final outcome = event.actionOutcomes?[action];
    if (outcome != null) {
      // Apply state changes if specified
      if (outcome.nextState != null) {
        await _applyStateChange(event.cartId, outcome.nextState!);
      }

      // Schedule next alert if specified
      if (outcome.nextAlertDelay != null) {
        // Could schedule a follow-up event here
      }

      return outcome;
    }

    // Default success result
    return AlertActionResult.success('조치 완료: ${action.label}');
  }

  /// Start playback timer
  void _startPlaybackTimer() {
    // Timer fires every 100ms, increments by speed factor
    _playbackTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _tick(),
    );
  }

  /// Timer tick - advance timeline and fire events
  void _tick() {
    if (_currentScenario == null) return;

    // Increment time based on playback speed
    _currentOffsetSeconds += (0.1 * _playbackSpeed).round();

    // Check if we've reached the end
    if (_currentOffsetSeconds >= _currentScenario!.totalDuration.inSeconds) {
      _currentOffsetSeconds = _currentScenario!.totalDuration.inSeconds;
      _playbackTimer?.cancel();
      _setState(ScenarioState.completed);
      _progressController.add(_currentOffsetSeconds);
      return;
    }

    // Fire events that should occur at this time
    final eventsToFire = _currentScenario!.sortedEvents.where(
      (event) =>
          event.offsetSeconds <= _currentOffsetSeconds &&
          event.offsetSeconds >
              (_currentOffsetSeconds - (0.1 * _playbackSpeed).round()),
    );

    for (final event in eventsToFire) {
      _fireEvent(event);
    }

    _progressController.add(_currentOffsetSeconds);
  }

  /// Fire an event
  Future<void> _fireEvent(ScenarioEvent event) async {
    print(
        '🎬 Scenario Event [${event.timeString}] ${event.icon} ${event.title}: ${event.message}');

    // Broadcast event
    _eventController.add(event);

    // Execute event based on type
    switch (event.type) {
      case ScenarioEventType.alertTrigger:
        await _createAlert(event);
        break;

      case ScenarioEventType.stateChange:
        if (event.newStatus != null) {
          await _updateCartStatus(event.cartId, event.newStatus!);
        }
        break;

      case ScenarioEventType.positionUpdate:
        if (event.newPosition != null) {
          await _updateCartPosition(event.cartId, event.newPosition!);
        }
        break;

      case ScenarioEventType.telemetryUpdate:
        if (event.telemetryChanges != null) {
          await _updateTelemetry(event.cartId, event.telemetryChanges!);
        }
        break;

      case ScenarioEventType.info:
        // Info events are just broadcast, no state changes
        break;
    }
  }

  /// Create alert from scenario event
  Future<void> _createAlert(ScenarioEvent event) async {
    final alert = Alert(
      id: '', // Will be generated by MockApi
      code: '', // Will be generated by MockApi
      severity: event.severity ?? AlertSeverity.info,
      priority: event.priority ?? Priority.p3,
      state: AlertStatus.triggered,
      title: event.title,
      message: event.message,
      cartId: event.cartId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      escalationLevel: 0,
    );

    await _mockApi.createAlert(alert);
  }

  /// Update cart status
  Future<void> _updateCartStatus(String cartId, CartStatus status) async {
    final carts = await _mockApi.getCarts();
    final cart = carts.firstWhere((c) => c.id == cartId);
    final updated = cart.copyWith(status: status);
    await _mockApi.updateCart(updated);
  }

  /// Update cart position
  Future<void> _updateCartPosition(String cartId, LatLng position) async {
    final carts = await _mockApi.getCarts();
    final cart = carts.firstWhere((c) => c.id == cartId);
    final updated = cart.copyWith(position: position);
    await _mockApi.updateCart(updated);
  }

  /// Update telemetry
  Future<void> _updateTelemetry(
      String cartId, Map<String, dynamic> changes) async {
    final telemetry = await _mockApi.getTelemetry(cartId);
    if (telemetry == null) return;

    // Apply changes to telemetry
    // This would merge the changes map with current telemetry
    // Implementation depends on telemetry model structure
  }

  /// Apply state change from action
  Future<void> _applyStateChange(String cartId, String nextState) async {
    print('🔄 State change for $cartId: $nextState');
    // Apply state changes based on nextState string
    // This could update cart status, telemetry, etc.
  }

  /// Set state and broadcast
  void _setState(ScenarioState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  /// Dispose resources
  void dispose() {
    _playbackTimer?.cancel();
    _eventController.close();
    _stateController.close();
    _progressController.close();
  }
}

/// Provider for scenario engine
final scenarioEngineProvider = Provider<ScenarioEngine>((ref) {
  final mockApi = MockApi();
  final engine = ScenarioEngine(mockApi);
  ref.onDispose(() => engine.dispose());
  return engine;
});

/// Provider for current scenario state
final scenarioStateProvider = StreamProvider<ScenarioState>((ref) {
  final engine = ref.watch(scenarioEngineProvider);
  return engine.stateStream;
});

/// Provider for scenario events
final scenarioEventProvider = StreamProvider<ScenarioEvent>((ref) {
  final engine = ref.watch(scenarioEngineProvider);
  return engine.eventStream;
});

/// Provider for playback progress
final scenarioProgressProvider = StreamProvider<int>((ref) {
  final engine = ref.watch(scenarioEngineProvider);
  return engine.progressStream;
});
