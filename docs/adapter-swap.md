# Adapter Swap Guide

This guide explains how to replace mock services with real REST/WebSocket adapters in the AproFleet Manager App.

## Overview

The app is designed with a clean separation between business logic and data sources. All data access goes through repository interfaces, making it easy to swap implementations.

## Current Architecture

```
UI → Controllers → Repositories → Adapters → External APIs
```

- **Controllers**: Business logic and state management
- **Repositories**: Abstract interfaces for data access
- **Adapters**: Concrete implementations (Mock/REST/WebSocket)

## Provider Override Strategy

### 1. Update Main App Configuration

```dart
// lib/main.dart
void main() {
  runApp(ProviderScope(
    overrides: [
      // Replace mock repositories with real implementations
      cartRepositoryProvider.overrideWithValue(
        RestCartRepository(httpClient),
      ),
      workOrderRepositoryProvider.overrideWithValue(
        RestWoRepository(httpClient),
      ),
      alertRepositoryProvider.overrideWithValue(
        RestAlertRepository(wsClient),
      ),
      analyticsRepositoryProvider.overrideWithValue(
        RestAnalyticsRepository(httpClient),
      ),
    ],
    child: const App(),
  ));
}
```

### 2. Environment-Based Configuration

```dart
// lib/core/config/environment.dart
enum Environment { development, staging, production }

class AppConfig {
  static Environment get current => 
      const String.fromEnvironment('ENV', defaultValue: 'development') == 'production'
          ? Environment.production
          : Environment.development;
  
  static List<Override> get providerOverrides {
    switch (current) {
      case Environment.development:
        return []; // Use mock providers
      case Environment.staging:
        return _stagingOverrides;
      case Environment.production:
        return _productionOverrides;
    }
  }
}
```

## Repository Interfaces

### Cart Repository

```dart
abstract class CartRepository {
  Future<List<Cart>> list({CartFilter? filter});
  Future<Cart> get(String id);
  Future<Cart> create(CartRegistration registration);
  Future<Cart> update(Cart cart);
  Future<void> delete(String id);
  Stream<Cart> watch(String id);
  Stream<List<Cart>> watchList();
}
```

### Work Order Repository

```dart
abstract class WorkOrderRepository {
  Future<List<WorkOrder>> list({WorkOrderFilter? filter});
  Future<WorkOrder> get(String id);
  Future<WorkOrder> create(WorkOrderDraft draft);
  Future<WorkOrder> update(WorkOrder workOrder);
  Future<void> updateStatus(String id, WorkOrderStatus status);
  Future<void> delete(String id);
  Stream<WorkOrder> watch(String id);
  Stream<List<WorkOrder>> watchList();
}
```

### Alert Repository

```dart
abstract class AlertRepository {
  Future<List<Alert>> list({AlertFilter? filter});
  Future<Alert> get(String id);
  Future<void> acknowledge(String id, {String? note});
  Future<void> escalate(String id, {int toLevel, String? note});
  Future<void> resolve(String id, {String? note});
  Future<void> markAllRead();
  Future<void> mute(bool value);
  Stream<Alert> live();
  Stream<List<Alert>> watchList();
}
```

### Analytics Repository

```dart
abstract class AnalyticsRepository {
  Future<Kpi> getKpis({AnalyticsRange range});
  Future<List<Map<String, dynamic>>> getFleetPerformance({AnalyticsRange range});
  Future<List<Map<String, dynamic>>> getBatteryHealth({AnalyticsRange range});
  Future<List<Map<String, dynamic>>> getMaintenanceDistribution({AnalyticsRange range});
  Future<Map<String, double>> getCostAnalysis({AnalyticsRange range});
  Stream<Kpi> watchKpis({AnalyticsRange range});
}
```

## REST API Endpoints

### Cart Endpoints

```dart
class RestCartRepository implements CartRepository {
  final HttpClient httpClient;
  
  RestCartRepository(this.httpClient);
  
  @override
  Future<List<Cart>> list({CartFilter? filter}) async {
    final queryParams = _buildQueryParams(filter);
    final response = await httpClient.get(
      Uri.parse('$baseUrl/carts?$queryParams'),
      headers: await _getHeaders(),
    );
    
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      return json.map((e) => Cart.fromJson(e)).toList();
    }
    
    throw CartRepositoryException('Failed to fetch carts: ${response.statusCode}');
  }
  
  @override
  Future<Cart> create(CartRegistration registration) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/carts'),
      headers: await _getHeaders(),
      body: jsonEncode(registration.toJson()),
    );
    
    if (response.statusCode == 201) {
      return Cart.fromJson(jsonDecode(response.body));
    }
    
    throw CartRepositoryException('Failed to create cart: ${response.statusCode}');
  }
}
```

**API Endpoints:**
- `GET /carts` - List carts with filtering
- `GET /carts/:id` - Get specific cart
- `POST /carts` - Create new cart
- `PUT /carts/:id` - Update cart
- `DELETE /carts/:id` - Delete cart

### Work Order Endpoints

**API Endpoints:**
- `GET /work-orders` - List work orders with filtering
- `GET /work-orders/:id` - Get specific work order
- `POST /work-orders` - Create new work order
- `PUT /work-orders/:id` - Update work order
- `PATCH /work-orders/:id/status` - Update work order status
- `DELETE /work-orders/:id` - Delete work order

### Alert Endpoints

**API Endpoints:**
- `GET /alerts` - List alerts with filtering
- `GET /alerts/:id` - Get specific alert
- `POST /alerts/:id/acknowledge` - Acknowledge alert
- `POST /alerts/:id/escalate` - Escalate alert
- `POST /alerts/:id/resolve` - Resolve alert
- `POST /alerts/mark-all-read` - Mark all alerts as read
- `PATCH /alerts/mute` - Toggle mute state

### Analytics Endpoints

**API Endpoints:**
- `GET /analytics/kpi?range=week` - Get KPI data
- `GET /analytics/fleet-performance?range=week` - Get fleet performance
- `GET /analytics/battery-health?range=week` - Get battery health trends
- `GET /analytics/maintenance-distribution?range=week` - Get maintenance distribution
- `GET /analytics/cost-analysis?range=week` - Get cost analysis

## WebSocket Integration

### Real-Time Data Streams

```dart
class WebSocketAlertRepository implements AlertRepository {
  final WebSocketChannel channel;
  final StreamController<Alert> _alertController = StreamController.broadcast();
  
  WebSocketAlertRepository(this.channel) {
    _setupWebSocket();
  }
  
  void _setupWebSocket() {
    channel.stream.listen((data) {
      final event = jsonDecode(data);
      switch (event['type']) {
        case 'alert_created':
          _alertController.add(Alert.fromJson(event['data']));
          break;
        case 'alert_updated':
          _alertController.add(Alert.fromJson(event['data']));
          break;
      }
    });
  }
  
  @override
  Stream<Alert> live() => _alertController.stream;
}
```

**WebSocket Events:**
- `telemetry_update` - Real-time telemetry data
- `position_update` - Cart position updates
- `alert_created` - New alert notifications
- `alert_updated` - Alert state changes
- `work_order_updated` - Work order status changes

## Error Handling

### Retry Strategy

```dart
class RetryHttpClient {
  final HttpClient httpClient;
  final int maxRetries;
  final Duration baseDelay;
  
  Future<Response> getWithRetry(Uri url, {Map<String, String>? headers}) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final response = await httpClient.get(url, headers: headers);
        if (response.statusCode < 500) {
          return response;
        }
      } catch (e) {
        if (attempt == maxRetries) rethrow;
      }
      
      await Future.delayed(baseDelay * pow(2, attempt));
    }
    
    throw Exception('Max retries exceeded');
  }
}
```

### Error Policy

```dart
class ApiErrorPolicy {
  static void handleError(dynamic error) {
    if (error is SocketException) {
      // Network error - show offline message
      throw NetworkException('No internet connection');
    } else if (error is TimeoutException) {
      // Timeout - retry with exponential backoff
      throw TimeoutException('Request timed out');
    } else if (error is HttpException) {
      // HTTP error - handle status codes
      throw ApiException('Server error: ${error.message}');
    }
  }
}
```

## Authentication

### Token Management

```dart
class AuthTokenManager {
  String? _accessToken;
  String? _refreshToken;
  DateTime? _expiresAt;
  
  Future<String> getValidToken() async {
    if (_accessToken != null && _expiresAt != null && DateTime.now().isBefore(_expiresAt!)) {
      return _accessToken!;
    }
    
    if (_refreshToken != null) {
      await _refreshAccessToken();
      return _accessToken!;
    }
    
    throw AuthenticationException('No valid token available');
  }
  
  Future<void> _refreshAccessToken() async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: {'Authorization': 'Bearer $_refreshToken'},
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
      _expiresAt = DateTime.now().add(Duration(seconds: data['expires_in']));
    } else {
      throw AuthenticationException('Token refresh failed');
    }
  }
}
```

## Configuration

### Environment Variables

```dart
class ApiConfig {
  static String get baseUrl => const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.aprofleet.com',
  );
  
  static String get wsUrl => const String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'wss://ws.aprofleet.com',
  );
  
  static Duration get timeout => Duration(
    seconds: const int.fromEnvironment('API_TIMEOUT', defaultValue: 30),
  );
  
  static int get maxRetries => const int.fromEnvironment('API_MAX_RETRIES', defaultValue: 3);
}
```

### Build Configuration

```yaml
# pubspec.yaml
flutter:
  build.yaml:
    targets:
      $default:
        builders:
          json_serializable:
            options:
              explicit_to_json: true
```

## Testing

### Mock vs Real Testing

```dart
// test/helpers/test_providers.dart
List<Override> createTestProviders({
  bool useRealApi = false,
}) {
  if (useRealApi) {
    return [
      cartRepositoryProvider.overrideWithValue(RestCartRepository(testHttpClient)),
      workOrderRepositoryProvider.overrideWithValue(RestWoRepository(testHttpClient)),
    ];
  } else {
    return [
      cartRepositoryProvider.overrideWithValue(MockCartRepository()),
      workOrderRepositoryProvider.overrideWithValue(MockWoRepository()),
    ];
  }
}
```

### Integration Tests

```dart
// integration_test/app_test.dart
void main() {
  group('API Integration Tests', () {
    testWidgets('Real API integration', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: createTestProviders(useRealApi: true),
          child: const App(),
        ),
      );
      
      // Test real API calls
      await tester.pumpAndSettle();
      expect(find.text('Loading...'), findsNothing);
    });
  });
}
```

## Migration Checklist

- [ ] Update provider overrides in `main.dart`
- [ ] Implement REST repository classes
- [ ] Configure WebSocket connections
- [ ] Add authentication token management
- [ ] Implement error handling and retry logic
- [ ] Update environment configuration
- [ ] Add integration tests
- [ ] Update documentation
- [ ] Deploy to staging environment
- [ ] Perform end-to-end testing
- [ ] Deploy to production