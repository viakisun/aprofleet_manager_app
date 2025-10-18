import 'dart:async';
import 'dart:math';
import 'package:latlong2/latlong.dart';

import '../../../domain/models/cart.dart';
import '../../../domain/models/telemetry.dart';
import '../../../domain/models/alert.dart';
import '../../../domain/models/work_order.dart';
import '../../constants/app_constants.dart';
import 'mock_api.dart';

class MockWsHub {
  static final MockWsHub _instance = MockWsHub._internal();
  factory MockWsHub() => _instance;
  MockWsHub._internal();

  final MockApi _mockApi = MockApi();

  // Stream controllers
  final StreamController<Telemetry> _telemetryController =
      StreamController<Telemetry>.broadcast();
  final StreamController<Cart> _positionController =
      StreamController<Cart>.broadcast();
  final StreamController<Alert> _alertController =
      StreamController<Alert>.broadcast();

  // Timers
  Timer? _telemetryTimer;
  Timer? _positionTimer;
  Timer? _alertTimer;

  // Random generator
  final Random _random = Random();

  // Test mode flag
  bool _testMode = false;

  // Initialize WebSocket simulation
  Future<void> initialize() async {
    await _mockApi.initialize();
    
    // 테스트 모드가 아닐 때만 타이머 시작
    if (!_testMode) {
      _startTelemetrySimulation();
      _startPositionSimulation();
      _startAlertSimulation();
    }
  }

  // 테스트 모드 활성화
  void enableTestMode() {
    _testMode = true;
  }

  // Stream getters
  Stream<Telemetry> get telemetryStream => _telemetryController.stream;
  Stream<Cart> get positionStream => _positionController.stream;
  Stream<Alert> get alertStream => _alertController.stream;

  // Start telemetry simulation (1 second intervals)
  void _startTelemetrySimulation() {
    _telemetryTimer = Timer.periodic(
      Duration(seconds: AppConstants.telemetryInterval),
      (_) => _updateTelemetry(),
    );
  }

  // Start position simulation (3 second intervals)
  void _startPositionSimulation() {
    _positionTimer = Timer.periodic(
      Duration(seconds: AppConstants.positionInterval),
      (_) => _updatePositions(),
    );
  }

  // Start alert simulation (10 second intervals)
  void _startAlertSimulation() {
    _alertTimer = Timer.periodic(
      Duration(seconds: AppConstants.alertInterval),
      (_) => _generateRandomAlert(),
    );
  }

  // Update telemetry for all carts
  Future<void> _updateTelemetry() async {
    final carts = await _mockApi.getCarts();

    for (final cart in carts) {
      if (cart.status == CartStatus.offline) continue;

      final currentTelemetry = await _mockApi.getTelemetry(cart.id);
      if (currentTelemetry == null) continue;

      // Simulate battery drain
      double batteryDrain = 0.0;
      if (cart.status == CartStatus.active) {
        batteryDrain = 0.1 + _random.nextDouble() * 1.1; // 0.1 to 1.2%
      } else if (cart.status == CartStatus.charging) {
        batteryDrain =
            -2.0 - _random.nextDouble() * 3.0; // -2 to -5% (charging)
      }

      // Simulate speed changes
      double speedChange = 0.0;
      if (cart.status == CartStatus.active) {
        speedChange = _random.nextDouble() * 5.0 - 2.5; // -2.5 to +2.5 km/h
      }

      // Simulate temperature changes
      double tempChange = _random.nextDouble() * 2.0 - 1.0; // -1 to +1°C

      final newTelemetry = currentTelemetry.copyWith(
        battery: (currentTelemetry.battery - batteryDrain).clamp(0.0, 100.0),
        speed: (currentTelemetry.speed + speedChange).clamp(0.0, 25.0),
        temperature:
            (currentTelemetry.temperature + tempChange).clamp(20.0, 80.0),
        voltage: currentTelemetry.voltage +
            (_random.nextDouble() * 0.4 - 0.2), // ±0.2V
        current: currentTelemetry.current +
            (_random.nextDouble() * 2.0 - 1.0), // ±1A
        runtime:
            currentTelemetry.runtime + (AppConstants.telemetryInterval / 60.0),
        distance: currentTelemetry.distance +
            (currentTelemetry.speed * AppConstants.telemetryInterval / 3600.0),
        timestamp: DateTime.now(),
      );

      await _mockApi.updateTelemetry(cart.id, newTelemetry);
      _telemetryController.add(newTelemetry);

      // Check for battery alerts
      if (newTelemetry.battery <= AppConstants.batteryCriticalThreshold) {
        await _createBatteryAlert(cart, newTelemetry.battery, 'critical');
      } else if (newTelemetry.battery <= AppConstants.batteryWarningThreshold) {
        await _createBatteryAlert(cart, newTelemetry.battery, 'warning');
      }

      // Check for temperature alerts
      if (newTelemetry.temperature >=
          AppConstants.temperatureWarningThreshold) {
        await _createTemperatureAlert(cart, newTelemetry.temperature);
      }
    }
  }

  // Update positions for active carts
  Future<void> _updatePositions() async {
    final carts = await _mockApi.getCarts();

    for (final cart in carts) {
      if (cart.status != CartStatus.active) continue;

      // Simulate small position changes
      final latChange =
          (_random.nextDouble() - 0.5) * 0.0001; // ±0.00005 degrees
      final lngChange = (_random.nextDouble() - 0.5) * 0.0001;

      final newPosition = LatLng(
        cart.position.latitude + latChange,
        cart.position.longitude + lngChange,
      );

      final updatedCart = cart.copyWith(
        position: newPosition,
        lastSeen: DateTime.now(),
      );

      await _mockApi.updateCart(updatedCart);
      _positionController.add(updatedCart);
    }
  }

  // Generate random alerts
  Future<void> _generateRandomAlert() async {
    final carts = await _mockApi.getCarts();
    if (carts.isEmpty) return;

    final cart = carts[_random.nextInt(carts.length)];
    final alertTypes = ['geofence', 'maintenance', 'system', 'communication'];
    final alertType = alertTypes[_random.nextInt(alertTypes.length)];

    AlertSeverity severity;
    Priority priority;
    String message;

    switch (alertType) {
      case 'geofence':
        severity = AlertSeverity.warning;
        priority = Priority.p2;
        message = 'Geofence violation - cart outside designated area';
        break;
      case 'maintenance':
        severity = AlertSeverity.info;
        priority = Priority.p3;
        message = 'Maintenance due - scheduled service approaching';
        break;
      case 'system':
        severity = AlertSeverity.info;
        priority = Priority.p3;
        message = 'System update available - recommend installation';
        break;
      case 'communication':
        severity = AlertSeverity.warning;
        priority = Priority.p2;
        message = 'Communication timeout - check connectivity';
        break;
      default:
        severity = AlertSeverity.info;
        priority = Priority.p3;
        message = 'System notification';
    }

    final alert = Alert(
      id: '', // Will be generated by MockApi
      code: '', // Will be generated by MockApi
      severity: severity,
      priority: priority,
      state: AlertStatus.triggered,
      title: 'System Alert',
      message: message,
      cartId: cart.id,
      location: cart.location?.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      escalationLevel: 1,
    );

    await _mockApi.createAlert(alert);
    _alertController.add(alert);
  }

  // Create battery alert
  Future<void> _createBatteryAlert(
      Cart cart, double batteryLevel, String severity) async {
    final alertSeverity =
        severity == 'critical' ? AlertSeverity.critical : AlertSeverity.warning;
    final priority = severity == 'critical' ? Priority.p1 : Priority.p2;

    final alert = Alert(
      id: '', // Will be generated by MockApi
      code: '', // Will be generated by MockApi
      severity: alertSeverity,
      priority: priority,
      state: AlertStatus.triggered,
      title: 'Battery Alert',
      message:
          '${severity.toUpperCase()} battery level - ${batteryLevel.toStringAsFixed(1)}% remaining',
      cartId: cart.id,
      location: cart.location?.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      escalationLevel: 1,
    );

    await _mockApi.createAlert(alert);
    _alertController.add(alert);
  }

  // Create temperature alert
  Future<void> _createTemperatureAlert(Cart cart, double temperature) async {
    final alert = Alert(
      id: '', // Will be generated by MockApi
      code: '', // Will be generated by MockApi
      severity: AlertSeverity.warning,
      priority: Priority.p2,
      state: AlertStatus.triggered,
      title: 'Temperature Alert',
      message:
          'Temperature warning - motor running hot (${temperature.toStringAsFixed(1)}°C)',
      cartId: cart.id,
      location: cart.location?.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      escalationLevel: 1,
    );

    await _mockApi.createAlert(alert);
    _alertController.add(alert);
  }

  // Dispose resources
  void dispose() {
    _telemetryTimer?.cancel();
    _positionTimer?.cancel();
    _alertTimer?.cancel();
    _telemetryController.close();
    _positionController.close();
    _alertController.close();
  }
}
