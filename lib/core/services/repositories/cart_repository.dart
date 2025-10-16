import '../../domain/models/cart.dart';
import '../../domain/models/work_order.dart';
import '../../domain/models/alert.dart';
import '../../domain/models/telemetry.dart';
import '../../domain/models/kpi.dart';
import '../../domain/models/user_profile.dart';

abstract class CartRepository {
  Future<List<Cart>> getCarts();
  Future<Cart?> getCart(String id);
  Future<Cart> createCart(Cart cart);
  Future<Cart> updateCart(Cart cart);
  Stream<Cart> watchCart(String id);
  Stream<List<Cart>> watchCarts();
}

abstract class WorkOrderRepository {
  Future<List<WorkOrder>> getWorkOrders();
  Future<WorkOrder?> getWorkOrder(String id);
  Future<WorkOrder> createWorkOrder(WorkOrder workOrder);
  Future<WorkOrder> updateWorkOrder(WorkOrder workOrder);
  Stream<List<WorkOrder>> watchWorkOrders();
}

abstract class AlertRepository {
  Future<List<Alert>> getAlerts();
  Future<Alert?> getAlert(String id);
  Future<Alert> createAlert(Alert alert);
  Future<Alert> updateAlert(Alert alert);
  Stream<Alert> watchAlerts();
  Future<void> acknowledgeAlert(String alertId, String userId);
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

abstract class UserRepository {
  Future<List<UserProfile>> getUsers();
  Future<UserProfile?> getUser(String id);
  Future<UserProfile> updateUser(UserProfile user);
}
