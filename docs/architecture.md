# Architecture Overview

## System Architecture

The AproFleet Manager App follows a layered architecture pattern with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                        UI Layer                              │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────┐ │
│  │    Pages    │ │  Widgets    │ │ Controllers │ │ Router  │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                    Business Logic Layer                     │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────┐ │
│  │ Controllers │ │  Services   │ │  Providers  │ │ Utils   │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────┐ │
│  │Repositories │ │   Adapters   │ │    Seeds    │ │  Models │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Core Components

### Domain Models
- **Cart**: Fleet vehicle with telemetry and status
- **WorkOrder**: Maintenance tasks with priority and assignment
- **Alert**: System notifications with escalation levels
- **Telemetry**: Real-time sensor data
- **Kpi**: Performance metrics and trends

### State Management
- **Riverpod**: Provider-based state management
- **StateNotifier**: Reactive state updates
- **AsyncValue**: Loading, error, and data states
- **Selectors**: Granular rebuild optimization

### Real-Time Data Flow
```
MockWsHub → Stream → Controller → StateNotifier → UI
    ↓           ↓         ↓           ↓         ↓
  Timer    Telemetry  Process    Update   Rebuild
```

**Update Intervals:**
- Telemetry: 1 second
- Position: 3 seconds  
- Alerts: 10 seconds (new), 5 seconds (state changes)
- Analytics: 30 seconds (±2% variation)

## Module Structure

### Real-Time Module (RT)
```
lib/features/rt/
├── pages/
│   ├── live_map_view.dart      # GCA-RT-001
│   └── cart_detail_monitor.dart # GCA-RT-002
├── controllers/
│   └── live_map_controller.dart
└── widgets/
    └── canvas_map_view.dart
```

### Cart Management (CM)
```
lib/features/cm/
├── pages/
│   ├── cart_inventory_list.dart # GCA-CM-001
│   └── cart_registration.dart   # GCA-CM-002
├── controllers/
│   └── cart_inventory_controller.dart
└── widgets/
    └── cart_card.dart
```

### Maintenance (MM)
```
lib/features/mm/
├── pages/
│   ├── work_order_list.dart    # GCA-MM-001
│   └── create_work_order.dart  # GCA-MM-002
├── controllers/
│   └── work_order_controller.dart
└── widgets/
    ├── wo_card.dart
    └── wo_detail_modal.dart
```

### Alerts (AL)
```
lib/features/al/
├── pages/
│   └── alert_center.dart       # GCA-AL-001
├── controllers/
│   └── alert_controller.dart
└── widgets/
    ├── alert_card.dart
    └── alert_detail_modal.dart
```

### Analytics (AR)
```
lib/features/ar/
├── pages/
│   └── analytics_dashboard.dart # GCA-AR-001
├── controllers/
│   └── analytics_controller.dart
└── widgets/
    ├── kpi_card.dart
    └── charts/
        ├── fleet_performance_bar.dart
        ├── battery_health_line.dart
        └── maintenance_pie.dart
```

## Navigation Architecture

### Route Structure
```dart
GoRouter(
  routes: [
    GoRoute(path: '/rt/map', builder: (context, state) => LiveMapView()),
    GoRoute(path: '/rt/cart/:id', builder: (context, state) => CartDetailMonitor()),
    GoRoute(path: '/cm/list', builder: (context, state) => CartInventoryList()),
    GoRoute(path: '/cm/register', builder: (context, state) => CartRegistration()),
    GoRoute(path: '/mm/list', builder: (context, state) => WorkOrderList()),
    GoRoute(path: '/mm/create', builder: (context, state) => CreateWorkOrder()),
    GoRoute(path: '/al/center', builder: (context, state) => AlertCenter()),
    GoRoute(path: '/ar/dashboard', builder: (context, state) => AnalyticsDashboard()),
  ],
)
```

### Cross-Module Navigation
- **Alert → Cart Detail**: `context.go('/rt/cart/${alert.cartId}')`
- **Alert → Work Order**: `context.go('/mm/create?cart=${alert.cartId}&type=${mappedType}')`
- **Cart → Work Order**: `context.go('/mm/create?cart=${cart.id}')`
- **Cart → Track**: `context.go('/rt/cart/${cart.id}')`

## Data Flow Patterns

### Repository Pattern
```dart
abstract class CartRepository {
  Future<List<Cart>> list({CartFilter? filter});
  Future<Cart> get(String id);
  Future<Cart> create(CartRegistration registration);
  Future<Cart> update(Cart cart);
}

class MockCartRepository implements CartRepository {
  // In-memory implementation
}

class RestCartRepository implements CartRepository {
  // HTTP API implementation
}
```

### Provider Pattern
```dart
@riverpod
class CartController extends _$CartController {
  @override
  Future<List<Cart>> build() async {
    return ref.read(cartRepositoryProvider).list();
  }
  
  Future<void> createCart(CartRegistration registration) async {
    final cart = await ref.read(cartRepositoryProvider).create(registration);
    ref.invalidateSelf();
  }
}
```

### Stream Pattern
```dart
class MockWsHub {
  Stream<Telemetry> get telemetryStream => _telemetryController.stream;
  Stream<Position> get positionStream => _positionController.stream;
  Stream<Alert> get alertStream => _alertController.stream;
  
  void _startSimulation() {
    Timer.periodic(Duration(seconds: 1), (_) {
      _telemetryController.add(_generateTelemetry());
    });
  }
}
```

## Extensibility Points

### Map Provider Abstraction
```dart
abstract class MapFacade {
  Widget buildMapView({
    required List<Cart> carts,
    required Function(Cart) onCartTap,
    required double zoom,
    required ValueChanged<double> onZoomChanged,
  });
}

class CanvasMapFacade implements MapFacade {
  // Custom SVG/Canvas implementation
}

class GoogleMapFacade implements MapFacade {
  // Google Maps implementation
}
```

### Repository Adapters
- **Mock**: In-memory data for development
- **REST**: HTTP API integration
- **WebSocket**: Real-time data streams
- **GraphQL**: Flexible query language

### State Selectors
```dart
// Optimize rebuilds with selectors
final summaryCounts = ref.watch(alertControllerProvider.select(
  (state) => state.summaryCounts,
));

final unreadCount = ref.watch(alertControllerProvider.select(
  (state) => state.unreadCount,
));
```

## Performance Considerations

### List Virtualization
- All lists use `ListView.builder` for lazy loading
- `AutomaticKeepAliveClientMixin` for tab persistence
- `SliverList` for complex scrolling scenarios

### Image Optimization
- Thumbnails are downscaled on decode
- Cached images with proper disposal
- Lazy loading for large image sets

### Stream Management
- Controllers properly dispose of subscriptions
- Pause/resume based on app lifecycle
- Debounced updates for high-frequency data

## Testing Strategy

### Unit Tests
- **KPI Calculator**: Availability, MTTR, utilization calculations
- **Priority Queue**: Alert ordering and state management
- **Code Formatters**: ID generation and formatting

### Widget Tests
- **Alert Center**: Filtering and state changes
- **Work Order Creation**: Form validation and navigation

### Integration Tests
- **Cross-module navigation**: Deep linking between features
- **Real-time updates**: Stream processing and UI updates
- **Export functionality**: CSV generation and file handling

## Security Considerations

### Data Protection
- Sensitive data encrypted in transit
- Local storage encrypted at rest
- API keys stored securely

### Access Control
- Role-based permissions
- Session management
- Audit logging

### Input Validation
- Form validation on client and server
- SQL injection prevention
- XSS protection