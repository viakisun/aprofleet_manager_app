import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/cart.dart';
import '../../domain/models/work_order.dart';
import '../../domain/models/alert.dart';
import '../../domain/models/telemetry.dart';
import '../../domain/models/kpi.dart';
import '../../domain/models/user_profile.dart';
import 'mock/mock_api.dart';
import 'mock/mock_ws_hub.dart';
import 'repositories/cart_repository.dart';

part 'providers.g.dart';

// Mock API Provider
@riverpod
MockApi mockApi(MockApiRef ref) {
  return MockApi();
}

// Mock WebSocket Hub Provider
@riverpod
MockWsHub mockWsHub(MockWsHubRef ref) {
  return MockWsHub();
}

// Repository Providers
@riverpod
CartRepository cartRepository(CartRepositoryRef ref) {
  return CartRepositoryImpl(ref.watch(mockApiProvider));
}

@riverpod
WorkOrderRepository workOrderRepository(WorkOrderRepositoryRef ref) {
  return WorkOrderRepositoryImpl(ref.watch(mockApiProvider));
}

@riverpod
AlertRepository alertRepository(AlertRepositoryRef ref) {
  return AlertRepositoryImpl(ref.watch(mockApiProvider));
}

// Cart Repository Provider
@riverpod
Future<List<Cart>> carts(CartsRef ref) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getCarts();
}

@riverpod
Future<Cart?> cart(CartRef ref, String cartId) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getCart(cartId);
}

// Work Order Repository Provider
@riverpod
Future<List<WorkOrder>> workOrders(WorkOrdersRef ref) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getWorkOrders();
}

@riverpod
Future<WorkOrder?> workOrder(WorkOrderRef ref, String workOrderId) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getWorkOrder(workOrderId);
}

// Alert Repository Provider
@riverpod
Future<List<Alert>> alerts(AlertsRef ref) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getAlerts();
}

@riverpod
Future<Alert?> alert(AlertRef ref, String alertId) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getAlert(alertId);
}

// Telemetry Repository Provider
@riverpod
Future<Telemetry?> telemetry(TelemetryRef ref, String cartId) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getTelemetry(cartId);
}

// Analytics Repository Provider
@riverpod
Future<Kpi> kpi(KpiRef ref) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getKpi();
}

// User Repository Provider
@riverpod
Future<List<UserProfile>> users(UsersRef ref) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getUsers();
}

// Stream Providers
@riverpod
Stream<Telemetry> telemetryStream(TelemetryStreamRef ref, String cartId) {
  final mockWsHub = ref.watch(mockWsHubProvider);
  return mockWsHub.telemetryStream.where((t) => t.cartId == cartId);
}

@riverpod
Stream<Cart> positionStream(PositionStreamRef ref, String cartId) {
  final mockWsHub = ref.watch(mockWsHubProvider);
  return mockWsHub.positionStream.where((c) => c.id == cartId);
}

@riverpod
Stream<Alert> alertStream(AlertStreamRef ref) {
  final mockWsHub = ref.watch(mockWsHubProvider);
  return mockWsHub.alertStream;
}

// Initialization Provider
@riverpod
Future<void> initializeApp(InitializeAppRef ref) async {
  final mockApi = ref.watch(mockApiProvider);
  final mockWsHub = ref.watch(mockWsHubProvider);

  await mockApi.initialize();
  await mockWsHub.initialize();
}
