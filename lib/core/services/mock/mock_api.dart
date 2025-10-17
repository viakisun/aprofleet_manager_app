import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/models/cart.dart';
import '../../../domain/models/work_order.dart';
import '../../../domain/models/alert.dart';
import '../../../domain/models/telemetry.dart';
import '../../../domain/models/kpi.dart';
import '../../../domain/models/user_profile.dart';
import '../../constants/app_constants.dart';

class MockApi {
  static final MockApi _instance = MockApi._internal();
  factory MockApi() => _instance;
  MockApi._internal();

  // In-memory storage
  final Map<String, Cart> _carts = {};
  final Map<String, WorkOrder> _workOrders = {};
  final Map<String, Alert> _alerts = {};
  final Map<String, Telemetry> _telemetry = {};
  final List<UserProfile> _users = [];

  // Counters for ID generation
  int _cartCounter = 1;
  int _workOrderCounter = 1;
  int _alertCounter = 1;

  // Initialize with seed data
  Future<void> initialize() async {
    try {
      await _loadCarts();
      await _loadWorkOrders();
      await _loadAlerts();
      await _loadTelemetry();
      await _loadUsers();

      // Add fallback data if loading failed
      if (_carts.isEmpty) {
        _addFallbackCarts();
      }
      if (_workOrders.isEmpty) {
        _addFallbackWorkOrders();
      }
      if (_alerts.isEmpty) {
        _addFallbackAlerts();
      }

      print(
          'Mock API initialized with ${_carts.length} carts, ${_workOrders.length} work orders, ${_alerts.length} alerts');
    } catch (e) {
      print('Error during Mock API initialization: $e');
      // Add fallback data
      _addFallbackCarts();
      _addFallbackWorkOrders();
      _addFallbackAlerts();
    }
  }

  // Cart operations
  Future<List<Cart>> getCarts() async {
    return _carts.values.toList();
  }

  Future<Cart?> getCart(String id) async {
    return _carts[id];
  }

  Future<Cart> createCart(Cart cart) async {
    final newCart = cart.copyWith(
      id: 'APRO-${_cartCounter.toString().padLeft(3, '0')}',
    );
    _carts[newCart.id] = newCart;
    _cartCounter++;
    return newCart;
  }

  Future<Cart> updateCart(Cart cart) async {
    _carts[cart.id] = cart;
    return cart;
  }

  // Work Order operations
  Future<List<WorkOrder>> getWorkOrders() async {
    return _workOrders.values.toList();
  }

  Future<WorkOrder?> getWorkOrder(String id) async {
    return _workOrders[id];
  }

  Future<WorkOrder> createWorkOrder(WorkOrder workOrder) async {
    final newWorkOrder = workOrder.copyWith(
      id: 'WO-2025-${_workOrderCounter.toString().padLeft(4, '0')}',
      createdAt: DateTime.now(),
    );
    _workOrders[newWorkOrder.id] = newWorkOrder;
    _workOrderCounter++;
    return newWorkOrder;
  }

  Future<WorkOrder> updateWorkOrder(WorkOrder workOrder) async {
    _workOrders[workOrder.id] = workOrder;
    return workOrder;
  }

  // Alert operations
  Future<List<Alert>> getAlerts() async {
    return _alerts.values.toList();
  }

  Future<Alert?> getAlert(String id) async {
    return _alerts[id];
  }

  Future<Alert> createAlert(Alert alert) async {
    final newAlert = alert.copyWith(
      id: 'ALT-2025-${_alertCounter.toString().padLeft(4, '0')}',
      createdAt: DateTime.now(),
    );
    _alerts[newAlert.id] = newAlert;
    _alertCounter++;
    return newAlert;
  }

  Future<Alert> updateAlert(Alert alert) async {
    _alerts[alert.id] = alert;
    return alert;
  }

  // Telemetry operations
  Future<Telemetry?> getTelemetry(String cartId) async {
    return _telemetry[cartId];
  }

  Future<Telemetry> updateTelemetry(String cartId, Telemetry telemetry) async {
    _telemetry[cartId] = telemetry;
    return telemetry;
  }

  // KPI operations
  Future<Kpi> getKpi() async {
    // Calculate mock KPIs
    final carts = _carts.values.toList();
    final activeCarts =
        carts.where((c) => c.status == CartStatus.active).length;
    final totalCarts = carts.length;

    final availabilityRate =
        totalCarts > 0 ? (activeCarts / totalCarts) * 100 : 0.0;

    return Kpi(
      availabilityRate: availabilityRate,
      mttr: 18.0 + Random().nextDouble() * 10, // 18-28 minutes
      utilization: 800.0 + Random().nextDouble() * 200, // 800-1000 km
      dailyDistance: 15.0 + Random().nextDouble() * 10, // 15-25 km per cart
      trend: KpiTrendDirection
          .values[Random().nextInt(KpiTrendDirection.values.length)],
      lastUpdated: DateTime.now(),
    );
  }

  // User operations
  Future<List<UserProfile>> getUsers() async {
    return _users;
  }

  // Private methods for loading seed data
  Future<void> _loadCarts() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/seeds/carts.json');
      print('Loaded JSON string length: ${jsonString.length}');

      final dynamic jsonData = json.decode(jsonString);
      print('Parsed JSON type: ${jsonData.runtimeType}');

      if (jsonData is List) {
        print('JSON is List with ${jsonData.length} items');
        for (int i = 0; i < jsonData.length; i++) {
          try {
            final cart = Cart.fromJson(jsonData[i]);
            _carts[cart.id] = cart;
            print('Loaded cart: ${cart.id}');
          } catch (e) {
            print('Error parsing cart at index $i: $e');
          }
        }
      } else {
        print('JSON is not a List, it is: ${jsonData.runtimeType}');
      }
    } catch (e) {
      print('Error loading carts: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> _loadWorkOrders() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/seeds/work_orders.json');
      final dynamic jsonData = json.decode(jsonString);

      if (jsonData is List && jsonData.isNotEmpty) {
        for (final json in jsonData) {
          final workOrder = WorkOrder.fromJson(json);
          _workOrders[workOrder.id] = workOrder;
        }
      }
    } catch (e) {
      print('Error loading work orders: $e');
    }
  }

  Future<void> _loadAlerts() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/seeds/alerts.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      for (final json in jsonList) {
        final alert = Alert.fromJson(json);
        _alerts[alert.id] = alert;
      }
    } catch (e) {
      print('Error loading alerts: $e');
    }
  }

  Future<void> _loadTelemetry() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/seeds/telemetry_seed.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      for (final entry in jsonMap.entries) {
        final telemetry = Telemetry.fromJson({
          ...entry.value,
          'timestamp': DateTime.now().toIso8601String(),
        });
        _telemetry[entry.key] = telemetry;
      }
    } catch (e) {
      print('Error loading telemetry: $e');
    }
  }

  Future<void> _loadUsers() async {
    _users.addAll([
      const UserProfile(
        id: 'user-001',
        name: 'John Smith',
        email: 'john.smith@aprofleet.com',
        role: UserRole.manager,
        department: 'Operations',
      ),
      const UserProfile(
        id: 'user-002',
        name: 'Sarah Johnson',
        email: 'sarah.johnson@aprofleet.com',
        role: UserRole.technician,
        department: 'Maintenance',
      ),
      const UserProfile(
        id: 'user-003',
        name: 'Mike Chen',
        email: 'mike.chen@aprofleet.com',
        role: UserRole.technician,
        department: 'Maintenance',
      ),
      const UserProfile(
        id: 'user-004',
        name: 'Lisa Wang',
        email: 'lisa.wang@aprofleet.com',
        role: UserRole.operator,
        department: 'Operations',
      ),
      const UserProfile(
        id: 'user-005',
        name: 'David Kim',
        email: 'david.kim@aprofleet.com',
        role: UserRole.operator,
        department: 'Operations',
      ),
    ]);
  }

  // Fallback data methods
  void _addFallbackCarts() {
    print('Adding fallback cart data...');
    final fallbackCart = Cart(
      id: 'APRO-FALLBACK-001',
      vin: 'APRO2025FALLBACK001',
      manufacturer: 'DY Innovate',
      model: 'APRO-100',
      year: 2025,
      color: 'White',
      batteryType: 'Lithium-ion',
      voltage: 48,
      seating: 4,
      maxSpeed: 25.0,
      gpsTrackerId: 'GPS-FB-001',
      telemetryDeviceId: 'TEL-FB-001',
      componentSerials: {
        'battery': 'BAT-FB-001',
        'motor': 'MOT-FB-001',
      },
      imagePaths: {},
      purchaseDate: DateTime(2025, 1, 1),
      warrantyExpiry: DateTime(2027, 1, 1),
      insuranceNumber: 'INS-FB-001',
      odometer: 0.0,
      status: CartStatus.active,
      position: LatLng(37.7749, -122.4194), // San Francisco
      batteryLevel: 85.0,
      speed: 0.0,
      lastSeen: DateTime.now(),
    );
    _carts[fallbackCart.id] = fallbackCart;
  }

  void _addFallbackWorkOrders() {
    print('Adding fallback work order data...');
    final fallbackWO = WorkOrder(
      id: 'WO-FALLBACK-001',
      type: WorkOrderType.preventive,
      priority: Priority.p2,
      cartId: 'APRO-FALLBACK-001',
      description: 'Fallback preventive maintenance',
      status: WorkOrderStatus.pending,
      createdAt: DateTime.now(),
      technician: 'John Smith',
      location: 'Maintenance Bay',
      parts: [],
      checklist: {},
      notes: 'Fallback work order for testing',
    );
    _workOrders[fallbackWO.id] = fallbackWO;
  }

  void _addFallbackAlerts() {
    print('Adding fallback alert data...');
    final fallbackAlert = Alert(
      id: 'ALERT-FALLBACK-001',
      code: 'BAT-LOW-001',
      severity: AlertSeverity.warning,
      priority: Priority.p2,
      state: AlertStatus.triggered,
      title: 'Fallback Battery Alert',
      message: 'Battery level below 20%',
      cartId: 'APRO-FALLBACK-001',
      location: 'Maintenance Bay',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      acknowledgedBy: null,
      acknowledgedAt: null,
      resolvedBy: null,
      resolvedAt: null,
      notes: 'Fallback alert for testing',
    );
    _alerts[fallbackAlert.id] = fallbackAlert;
  }
}
