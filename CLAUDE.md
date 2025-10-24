# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**AproFleet Manager App** - A comprehensive fleet management system for APRO golf carts manufactured by DY Innovate. Built with Flutter using Clean Architecture principles with feature-based organization.

- **Brand**: APRO golf carts
- **Manufacturer**: DY Innovate
- **Current Phase**: Development (using Mock API)
- **Supported Languages**: English, Japanese, Korean, Chinese (Simplified & Traditional)
- **Design**: Dark monochrome theme with Material3

## Build, Test, and Run Commands

### Development Setup
```bash
# Install dependencies
flutter pub get

# Generate code (Freezed models, Riverpod providers, JSON serialization)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for continuous code generation during development
dart run build_runner watch

# Run the app
flutter run

# Run on specific device
flutter run -d <device_id>
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/kpi_calculator_test.dart

# Generate test coverage
flutter test --coverage

# Widget testing with specific file
flutter test test/alert_center_list_test.dart
```

### Maintenance
```bash
# Clean build artifacts
flutter clean

# Update dependencies
flutter pub upgrade

# Clear build_runner cache
dart run build_runner clean
```

## Architecture Overview

### Clean Architecture with Feature-Based Modules

The codebase follows strict separation of concerns across three main layers:

1. **Domain Layer** (`lib/domain/`): Pure Dart models with no framework dependencies
   - All models use `@freezed` for immutability
   - Automatic JSON serialization with `json_serializable`
   - Core entities: `Cart`, `WorkOrder`, `Alert`, `Telemetry`, `KPI`, `UserProfile`

2. **Data/Service Layer** (`lib/core/services/`):
   - Repository pattern with abstract interfaces
   - Mock API implementation (`mock/mock_api.dart`) ready for real backend swap
   - MockWsHub simulates real-time WebSocket streams
   - All repositories injected via Riverpod providers in `providers.dart`

3. **Presentation Layer** (`lib/features/`):
   - Seven feature modules, each self-contained with pages/controllers/widgets
   - Controllers use `StateNotifier` pattern
   - All state management via Riverpod 2.4.9

### Feature Modules

Each feature follows this structure:
```
features/<module>/
├── pages/           # Full-screen views
├── controllers/     # StateNotifier controllers
├── widgets/         # Feature-specific UI components
└── state/          # Feature-specific state models (if needed)
```

**Core Modules**:
- `auth/`: Splash, onboarding, login flow with SharedPreferences persistence
- `realtime_monitoring/`: Live map with Google Maps, real-time telemetry streaming, cart detail monitoring
- `cart_management/`: Inventory list with multi-filter search, 4-step registration wizard with QR generation
- `maintenance_management/`: Work order CRUD with 4-step creation wizard, priority-based workflow (P1-P4)
- `alert_management/`: Real-time alert center with severity-based routing, escalation workflow, SLA tracking
- `analytics_reporting/`: KPI dashboard with 30-second auto-refresh, chart visualizations, export functionality
- `settings/`: Language selection, preferences

### State Management Pattern

**Riverpod with Code Generation**:
```dart
// Providers defined in core/services/providers.dart
@riverpod
Future<List<Cart>> carts(Ref ref) async {...}

@riverpod
Stream<Telemetry> telemetryStream(Ref ref, String cartId) {...}

// Controllers use StateNotifier
class CartInventoryController extends StateNotifier<CartInventoryState> {
  // Manage local feature state
}

// UI layer watches state
final state = ref.watch(cartInventoryControllerProvider);
final filteredCarts = ref.watch(cartInventoryControllerProvider.select((s) => s.filteredCarts));
```

**Key Patterns**:
- Use `.select()` for granular rebuilds (avoid full state subscriptions)
- StreamSubscriptions in controllers must be cancelled in `dispose()`
- AsyncValue handles loading/error/data states consistently

### Navigation Architecture

**GoRouter (v12.1.3)** with authentication guards:
```
/splash → /onboarding → /login → ShellRoute (main app with bottom nav)
                                      ├─ /rt/map (Live Map)
                                      ├─ /rt/cart/:id (Cart Detail)
                                      ├─ /cm/list (Cart Inventory)
                                      ├─ /cm/register (Cart Registration)
                                      ├─ /mm/list (Work Orders)
                                      ├─ /mm/create (Create Work Order)
                                      ├─ /al/center (Alert Center)
                                      ├─ /ar/dashboard (Analytics)
                                      └─ /settings (Settings)
```

**Cross-Module Navigation**:
- Alert → Cart Detail: `context.go('/rt/cart/${alert.cartId}')`
- Alert → Create Work Order: `context.go('/mm/create?cart=${alert.cartId}')`
- Cart → Track: `context.go('/rt/cart/${cart.id}')`

Route guards check `authControllerProvider` state for onboarding completion and login status.

### Data Flow & Real-Time Simulation

**Mock API** (`lib/core/services/mock/mock_api.dart`):
- Singleton with in-memory storage (Maps/Lists)
- Loads seed data from `assets/seeds/` on initialization
- Simulates CRUD operations with realistic delays
- Ready to be swapped with REST/WebSocket implementations

**MockWsHub** real-time streams:
- Telemetry updates: Every 1 second
- Position updates: Every 3 seconds
- New alerts: Every 10 seconds
- Alert state changes: Every 5 seconds
- Analytics/KPI updates: Every 30 seconds (±2% variance)

**Stream subscription pattern**:
```dart
class MyController extends StateNotifier<MyState> {
  StreamSubscription? _subscription;

  void init() {
    _subscription = ref.read(telemetryStreamProvider(cartId)).listen(
      (telemetry) => state = state.copyWith(telemetry: telemetry),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```

## Domain Models & Business Logic

### Key Entities

**Cart** (`domain/models/cart.dart`):
- Status enum: active, idle, charging, maintenance, offline
- Battery metrics: level (%), health score, voltage, type
- Location: LatLng coordinates with last seen timestamp
- Operational metrics: daily distance, operating hours, downtime

**WorkOrder** (`domain/models/work_order.dart`):
- Type: emergencyRepair, preventive, battery, tire, safety, other
- Priority: P1 (Critical) → P4 (Low)
- Status workflow: draft → pending → inProgress → onHold → completed/cancelled
- Linked to Cart, assigned Technician, parts list, checklist
- Auto-priority suggestion based on type

**Alert** (`domain/models/alert.dart`):
- Severity: critical (🛑), warning (⚠️), info (ℹ️)
- State: triggered → notified → acknowledged → escalated → resolved
- Category: cart, battery, maintenance, geofence, system
- Escalation workflow with SLA tracking
- Action history for audit trail

**Telemetry** (`domain/models/telemetry.dart`):
- Real-time metrics: battery %, speed (km/h), temperature, voltage, current
- Streamed every 1 second per cart
- Includes position (LatLng) and timestamp

**KPI** (`domain/models/kpi.dart`):
- availabilityRate: (operating hours / (operating + downtime)) × 100
- mttrMinutes: mean time to repair (average of completed work orders)
- utilizationKm: total distance traveled
- Calculated via `KpiCalculator.fromSamples()` utility

### Code Formatters

**ID Generation** (`lib/core/utils/code_formatters.dart`):
- Work Orders: `WO-YYYY-####` (e.g., WO-2025-0001)
- Alerts: `ALT-YYYY-####` (e.g., ALT-2025-0001)
- Carts: `GCA-###` (e.g., GCA-001)
- Auto-increments with zero-padding, year-based reset

## Switching from Mock to Real API

### Provider Override Strategy

In `lib/main.dart`, replace mock repositories with real implementations:
```dart
void main() {
  runApp(ProviderScope(
    overrides: [
      cartRepositoryProvider.overrideWithValue(RestCartRepository(httpClient)),
      workOrderRepositoryProvider.overrideWithValue(RestWoRepository(httpClient)),
      alertRepositoryProvider.overrideWithValue(WebSocketAlertRepository(wsClient)),
      // ... other overrides
    ],
    child: const App(),
  ));
}
```

### Expected REST Endpoints

- **Carts**: `GET/POST/PUT/DELETE /carts`, `GET /carts/:id`
- **Work Orders**: `GET/POST/PUT/DELETE /work-orders`, `PATCH /work-orders/:id/status`
- **Alerts**: `GET /alerts`, `POST /alerts/:id/acknowledge`, `POST /alerts/:id/resolve`
- **Analytics**: `GET /analytics/kpi?start=...&end=...`

### WebSocket Events

- `telemetry_update`: Real-time cart metrics
- `position_update`: Cart location changes
- `alert_created`: New alert triggered
- `alert_updated`: Alert state changes
- `work_order_updated`: Work order status changes

Authentication via Bearer token in headers. Token refresh logic should be implemented in `AuthTokenManager`.

## Design System

**Theme**: Dark monochrome with pure black (#000000) background

**Color Tokens** (`lib/core/theme/design_tokens.dart`):
- Backgrounds: Pure black (#000000), dark gray (#0A0A0A), card surface (#1A1A1A)
- Borders: White with 4-12% opacity for subtle separation
- Status Colors:
  - Active: Bright green (#00FF00)
  - Idle: Orange (#FFAA00)
  - Charging: Blue (#0088FF)
  - Maintenance: Red (#FF4444)
  - Offline: Gray (#666666)
- Priority Colors: P1 (Red) → P2 (Orange) → P3 (Blue) → P4 (Green)

**Typography**:
- Font: SF Pro Display (custom font in `assets/fonts/`)
- All text uses uppercase with letter-spacing for professional look
- Numeric displays use tabular figures for alignment

**Spacing Scale**: 4px base unit (4, 8, 12, 16, 20, 24, 32, 48, 64)

**Access Design Tokens**:
```dart
import 'package:aprofleet_manager/core/theme/design_tokens.dart';

Container(
  color: DesignTokens.bgPrimary,
  decoration: BoxDecoration(
    border: Border.all(color: DesignTokens.borderPrimary),
  ),
  child: Text('ACTIVE', style: TextStyle(color: DesignTokens.statusActive)),
)
```

## Development Workflows

### Adding a New Feature

1. Create feature directory under `lib/features/new_feature/`
2. Define domain models in `lib/domain/models/` with `@freezed`
3. Add repository interface and mock implementation
4. Register provider in `lib/core/services/providers.dart`
5. Create controller extending `StateNotifier<YourState>`
6. Build UI pages/widgets using `ConsumerWidget`
7. Register routes in `lib/router/app_router.dart`
8. Run `dart run build_runner build --delete-conflicting-outputs`

### Modifying State Logic

Controllers live in `features/<module>/controllers/`. Pattern:
```dart
@riverpod
class CartInventoryController extends _$CartInventoryController {
  @override
  CartInventoryState build() => CartInventoryState.initial();

  Future<void> filterByStatus(CartStatus status) async {
    state = state.copyWith(filter: state.filter.copyWith(status: status));
    await _refreshCarts();
  }
}
```

### Adding Localization

1. Add key to `lib/core/localization/app_localizations.dart`
2. Implement in `app_localizations_en.dart`, `_ja.dart`, `_ko.dart`, `_zh.dart`
3. Use in UI: `AppLocalizations.of(context).yourTranslationKey`

### Performance Optimization

- Use `ref.watch(...).select((s) => s.specificField)` to avoid unnecessary rebuilds
- Prefer `ListView.builder` for long lists (virtualization)
- Cancel StreamSubscriptions in controller `dispose()`
- Limit image sizes (thumbnails at 200x200 via `ImageOptimizer`)

## Testing Strategy

### Unit Tests
- `test/kpi_calculator_test.dart`: Validates KPI calculations (availability, MTTR, utilization)
- `test/priority_queue_test.dart`: Alert ordering by P1-P4 then timestamp
- `test/code_formatter_test.dart`: ID generation format validation

### Widget Tests
- `test/alert_center_list_test.dart`: Filter application, acknowledge action
- `test/create_wo_form_test.dart`: Multi-step validation, auto-priority assignment

Run tests with `flutter test`. Add tests for new features following existing patterns.

## Common Troubleshooting

### Build Runner Issues
```bash
# If freezed/json_serializable fails
dart run build_runner clean
rm -rf .dart_tool
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Missing Imports After Code Generation
Ensure import paths in your code match generated file locations:
```dart
import 'package:aprofleet_manager/domain/models/cart.dart';
import 'package:aprofleet_manager/domain/models/cart.freezed.dart';
import 'package:aprofleet_manager/domain/models/cart.g.dart';
```

### Google Maps Not Showing
- Check API key in `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift`
- Verify permissions in `Info.plist` (iOS) and `AndroidManifest.xml` (Android)

### QR Scanner/Camera Permissions
Add to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access required for QR code scanning</string>
```
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

## Key File Locations

| Component | Path |
|-----------|------|
| Main entry | `lib/main.dart` |
| App root | `lib/app.dart` |
| Routing | `lib/router/app_router.dart` |
| Providers (DI) | `lib/core/services/providers.dart` |
| Mock API | `lib/core/services/mock/mock_api.dart` |
| Mock WebSocket | `lib/core/services/mock/mock_ws_hub.dart` |
| Theme | `lib/theme/app_theme.dart` |
| Design Tokens | `lib/core/theme/design_tokens.dart` |
| Domain Models | `lib/domain/models/*.dart` |
| Auth Controller | `lib/features/auth/controllers/auth_controller.dart` |
| Cart Inventory | `lib/features/cart_management/controllers/cart_inventory_controller.dart` |
| Work Orders | `lib/features/maintenance_management/controllers/work_order_controller.dart` |
| Alerts | `lib/features/alert_management/controllers/alert_controller.dart` |
| Analytics | `lib/features/analytics_reporting/controllers/analytics_controller.dart` |
| Live Map | `lib/features/realtime_monitoring/pages/live_map_view.dart` |
| Localization | `lib/core/localization/app_localizations.dart` |
| Seed Data | `assets/seeds/*.json` |

## Important Notes

- **Never hardcode strings**: Always use `AppLocalizations.of(context)` for user-facing text
- **Always use DesignTokens**: Never hardcode colors or spacing values
- **Stream cleanup**: All StreamSubscriptions must be cancelled in controller `dispose()`
- **Immutable models**: All domain models use Freezed, modify via `copyWith()`
- **Repository pattern**: UI never calls MockApi directly, always through repository providers
- **Authentication**: Auth state persisted in SharedPreferences, guards routes via GoRouter redirect

## Project Status

Current branch: `design/monochrome-theme`

Recent features:
- Monochrome design system implementation
- Layer toggle, compact vertical cart strip in map view
- Top status strip with keyboard shortcuts
- Micro tag synchronization and performance fixes
- Custom cart markers with Android compatibility
