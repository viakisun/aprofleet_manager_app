import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/cart.dart';
import '../../domain/models/work_order.dart';
import '../../domain/models/alert.dart';
import '../../domain/models/telemetry.dart';
import '../../domain/models/kpi.dart';
import '../../domain/models/user_profile.dart';
import 'mock/mock_api.dart';
import 'mock/mock_ws_hub.dart';
import 'repositories/cart_repository.dart';
import 'map/map_marker_factory.dart';

part 'providers.g.dart';

// Mock API Provider
@riverpod
MockApi mockApi(Ref ref) {
  return MockApi();
}

// Mock WebSocket Hub Provider
@riverpod
MockWsHub mockWsHub(Ref ref) {
  return MockWsHub();
}

// Repository Providers
@riverpod
CartRepository cartRepository(Ref ref) {
  return CartRepositoryImpl(ref.watch(mockApiProvider));
}

@riverpod
WorkOrderRepository workOrderRepository(Ref ref) {
  return WorkOrderRepositoryImpl(ref.watch(mockApiProvider));
}

@riverpod
AlertRepository alertRepository(Ref ref) {
  return AlertRepositoryImpl(ref.watch(mockApiProvider));
}

// Cart Repository Provider
@riverpod
Future<List<Cart>> carts(Ref ref) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getCarts();
}

@riverpod
Future<Cart?> cart(Ref ref, String cartId) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getCart(cartId);
}

// Work Order Repository Provider
@riverpod
Future<List<WorkOrder>> workOrders(Ref ref) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getWorkOrders();
}

@riverpod
Future<WorkOrder?> workOrder(Ref ref, String workOrderId) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getWorkOrder(workOrderId);
}

// Alert Repository Provider
@riverpod
Future<List<Alert>> alerts(Ref ref) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getAlerts();
}

@riverpod
Future<Alert?> alert(Ref ref, String alertId) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getAlert(alertId);
}

// Telemetry Repository Provider
@riverpod
Future<Telemetry?> telemetry(Ref ref, String cartId) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getTelemetry(cartId);
}

// Analytics Repository Provider
@riverpod
Future<Kpi> kpi(Ref ref) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getKpi();
}

// User Repository Provider
@riverpod
Future<List<UserProfile>> users(Ref ref) async {
  final mockApi = ref.watch(mockApiProvider);
  return await mockApi.getUsers();
}

// Stream Providers
@riverpod
Stream<Telemetry> telemetryStream(Ref ref, String cartId) {
  final mockWsHub = ref.watch(mockWsHubProvider);
  return mockWsHub.telemetryStream.where((t) => t.cartId == cartId);
}

@riverpod
Stream<Cart> positionStream(Ref ref, String cartId) {
  final mockWsHub = ref.watch(mockWsHubProvider);
  return mockWsHub.positionStream.where((c) => c.id == cartId);
}

@riverpod
Stream<Alert> alertStream(Ref ref) {
  final mockWsHub = ref.watch(mockWsHubProvider);
  return mockWsHub.alertStream;
}

// Initialization Provider
@riverpod
Future<void> initializeApp(Ref ref) async {
  final mockApi = ref.watch(mockApiProvider);
  final mockWsHub = ref.watch(mockWsHubProvider);

  // 앱 초기화: Mock API, WebSocket Hub, 커스텀 마커 아이콘
  await Future.wait([
    mockApi.initialize(),
    mockWsHub.initialize(),
    MapMarkerFactory.initializeCustomIcons(), // 커스텀 마커 아이콘 캐시 초기화
  ]);
}
