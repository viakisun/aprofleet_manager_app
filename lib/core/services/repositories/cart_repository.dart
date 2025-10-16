import '../../../domain/models/cart.dart';
import '../../../domain/models/work_order.dart';
import '../../../domain/models/alert.dart';
import '../../../domain/models/telemetry.dart';
import '../../../domain/models/kpi.dart';
import '../../../domain/models/user_profile.dart';
import 'package:latlong2/latlong.dart';

abstract class CartRepository {
  Future<List<Cart>> getCarts();
  Future<Cart?> getCart(String id);
  Future<Cart> createCart(Cart cart);
  Future<Cart> updateCart(Cart cart);
  Future<Cart> register(CartRegistration registration);
  Stream<Cart> watchCart(String id);
  Stream<List<Cart>> watchCarts();
}

abstract class WorkOrderRepository {
  Future<List<WorkOrder>> getWorkOrders();
  Future<WorkOrder?> getWorkOrder(String id);
  Future<WorkOrder> createWorkOrder(WorkOrder workOrder);
  Future<WorkOrder> updateWorkOrder(WorkOrder workOrder);
  Future<WorkOrder> update(WorkOrder workOrder);
  Future<WorkOrder> updateStatus(String workOrderId, WorkOrderStatus status);
  Future<WorkOrder> create(WorkOrderDraft draft);
  Stream<List<WorkOrder>> watchWorkOrders();
}

abstract class AlertRepository {
  Future<List<Alert>> getAlerts();
  Future<Alert?> getAlert(String id);
  Future<Alert> createAlert(Alert alert);
  Future<Alert> updateAlert(Alert alert);
  Future<void> acknowledgeAlert(String alertId, String userId);
  Future<void> acknowledge(String alertId);
  Future<void> escalate(String alertId, {int? toLevel});
  Future<void> resolve(String alertId);
  Future<void> markAllRead();
  Stream<Alert> watchAlerts();
}

abstract class TelemetryRepository {
  Future<Telemetry?> getTelemetry(String cartId);
  Stream<Telemetry> watchTelemetry(String cartId);
  Stream<List<Telemetry>> watchAllTelemetry();
}

abstract class AnalyticsRepository {
  Future<Kpi> getKpi();
  Stream<Kpi> watchKpi();
}

class CartRepositoryImpl implements CartRepository {
  final dynamic mockApi; // MockApi type

  CartRepositoryImpl(this.mockApi);

  @override
  Future<List<Cart>> getCarts() async {
    return await mockApi.getCarts();
  }

  @override
  Future<Cart?> getCart(String id) async {
    return await mockApi.getCart(id);
  }

  @override
  Future<Cart> createCart(Cart cart) async {
    return await mockApi.createCart(cart);
  }

  @override
  Future<Cart> updateCart(Cart cart) async {
    return await mockApi.updateCart(cart);
  }

  @override
  Stream<Cart> watchCart(String id) async* {
    // Mock implementation
    final cart = await getCart(id);
    if (cart != null) {
      yield* Stream.periodic(Duration(seconds: 5), (_) => cart);
    }
  }

  @override
  Stream<List<Cart>> watchCarts() async* {
    // Mock implementation
    yield* Stream.periodic(Duration(seconds: 5), (_) => <Cart>[]);
  }

  // Additional methods for cart registration
  Future<Cart> register(CartRegistration registration) async {
    // Convert CartRegistration to Cart
    final cart = Cart(
      id: '', // Will be generated
      vin: registration.vin,
      manufacturer: registration.manufacturer,
      model: registration.model,
      year: registration.year,
      color: registration.color,
      batteryType: registration.batteryType,
      voltage: registration.voltage,
      seating: registration.seating,
      maxSpeed: registration.maxSpeed,
      gpsTrackerId: registration.gpsTrackerId,
      telemetryDeviceId: registration.telemetryDeviceId,
      componentSerials: registration.componentSerials,
      imagePaths: registration.imagePaths,
      purchaseDate: registration.purchaseDate,
      warrantyExpiry: registration.warrantyExpiry,
      insuranceNumber: registration.insuranceNumber,
      odometer: registration.odometer,
      status: CartStatus.active,
      position: LatLng(0, 0), // Default position
      batteryLevel: 100.0,
      speed: 0.0,
      lastSeen: DateTime.now(),
    );

    return await createCart(cart);
  }
}

class WorkOrderRepositoryImpl implements WorkOrderRepository {
  final dynamic mockApi; // MockApi type

  WorkOrderRepositoryImpl(this.mockApi);

  @override
  Future<List<WorkOrder>> getWorkOrders() async {
    return await mockApi.getWorkOrders();
  }

  @override
  Future<WorkOrder?> getWorkOrder(String id) async {
    return await mockApi.getWorkOrder(id);
  }

  @override
  Future<WorkOrder> createWorkOrder(WorkOrder workOrder) async {
    return await mockApi.createWorkOrder(workOrder);
  }

  @override
  Future<WorkOrder> updateWorkOrder(WorkOrder workOrder) async {
    return await mockApi.updateWorkOrder(workOrder);
  }

  @override
  Future<WorkOrder> update(WorkOrder workOrder) async {
    return await updateWorkOrder(workOrder);
  }

  @override
  Future<WorkOrder> updateStatus(
      String workOrderId, WorkOrderStatus status) async {
    final workOrder = await getWorkOrder(workOrderId);
    if (workOrder == null) throw Exception('WorkOrder not found');
    final updatedWorkOrder = workOrder.copyWith(status: status);
    return await updateWorkOrder(updatedWorkOrder);
  }

  @override
  Future<WorkOrder> create(WorkOrderDraft draft) async {
    final workOrder = WorkOrder(
      id: '', // Will be generated
      type: draft.type,
      priority: draft.priority,
      cartId: draft.cartId,
      description: draft.description,
      status: WorkOrderStatus.pending,
      createdAt: DateTime.now(),
      technician: draft.technician,
      parts: draft.parts,
      location: draft.location,
      notes: draft.notes,
      checklist: draft.checklist,
    );
    return await createWorkOrder(workOrder);
  }

  @override
  Stream<List<WorkOrder>> watchWorkOrders() async* {
    // Mock implementation
    yield* Stream.periodic(Duration(seconds: 5), (_) => <WorkOrder>[]);
  }
}

class AlertRepositoryImpl implements AlertRepository {
  final dynamic mockApi; // MockApi type

  AlertRepositoryImpl(this.mockApi);

  @override
  Future<List<Alert>> getAlerts() async {
    return await mockApi.getAlerts();
  }

  @override
  Future<Alert?> getAlert(String id) async {
    return await mockApi.getAlert(id);
  }

  @override
  Future<Alert> createAlert(Alert alert) async {
    return await mockApi.createAlert(alert);
  }

  @override
  Future<Alert> updateAlert(Alert alert) async {
    return await mockApi.updateAlert(alert);
  }

  @override
  Future<void> acknowledgeAlert(String alertId, String userId) async {
    // Mock implementation - delegate to acknowledge
    await acknowledge(alertId);
  }

  @override
  Stream<Alert> watchAlerts() async* {
    // Mock implementation
    yield* Stream.periodic(
        Duration(seconds: 5),
        (_) => Alert(
              id: '',
              code: '',
              severity: AlertSeverity.info,
              priority: Priority.p3,
              state: AlertStatus.triggered,
              title: '',
              message: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ));
  }

  @override
  Future<void> acknowledge(String alertId) async {
    // Mock implementation
  }

  @override
  Future<void> escalate(String alertId, {int? toLevel}) async {
    // Mock implementation
  }

  @override
  Future<void> resolve(String alertId) async {
    // Mock implementation
  }

  @override
  Future<void> markAllRead() async {
    // Mock implementation
  }
}
