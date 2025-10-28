# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**AproFleet Manager App v0.2.0** - A comprehensive fleet management system for APRO golf carts manufactured by DY Innovate. Built with Flutter using Clean Architecture principles with feature-based organization.

- **Version**: 0.2.0 (Released: 2025-10-28)
- **Brand**: APRO golf carts
- **Manufacturer**: DY Innovate
- **Current Phase**: Production-ready (using Mock API, ready for backend swap)
- **Supported Languages**: English, Japanese, Korean, Chinese (Simplified & Traditional)
- **Design**: VIA Design System (Industrial Dark Theme) - monochrome glassmorphic design
- **Migration Status**: Phase 4 Complete (100% VIA components)

**Key Documentation**:
- [README.md](./README.md) - Project overview (Korean)
- [CHANGELOG.md](./CHANGELOG.md) - Version history
- [RELEASE_NOTES_v0.2.0.md](./RELEASE_NOTES_v0.2.0.md) - v0.2 release details
- [CONTRIBUTING.md](./CONTRIBUTING.md) - Development guidelines
- [GETTING_STARTED.md](./GETTING_STARTED.md) - Quick start guide
- [docs/design-system.md](./docs/design-system.md) - VIA Design System
- [docs/guides/junior-developer-guide.md](./docs/guides/junior-developer-guide.md) - Learning path

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
- `fleet/`: Live map with Google Maps/Mapbox, real-time telemetry streaming, cart detail monitoring
- `vehicles/`: Cart inventory list with multi-filter search, cart registration wizard with QR generation
- `service/`: Work order CRUD with 4-step creation wizard, priority-based workflow (P1-P4)
- `alerts/`: Real-time alert center with severity-based routing, escalation workflow, SLA tracking
- `analytics/`: KPI dashboard with 30-second auto-refresh, chart visualizations, export functionality
- `settings/`: Language selection, map provider, preferences

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
- Alert → Create Work Order: `context.go('/service/create?cart=${alert.cartId}')`
- Cart → Track: `context.go('/rt/cart/${cart.id}')`
- Cart Inventory: `context.go('/vehicles/inventory')`

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

## Design System - VIA (Phase 4 Migration in Progress)

**Current Status**: Migrating to VIA Design System (75% complete)
- ✅ Phase 1-2: Core VIA components (ViaButton, ViaCard, ViaToast, etc.)
- ✅ Phase 3: Live Map View 100% VIA
- 🔄 Phase 4: Remaining screens (Settings, Alerts, Work Orders, etc.)

**Theme**: VIA Industrial Dark - glassmorphic monochrome design

**Color Tokens** (`lib/core/theme/via_design_tokens.dart`):
- Primary: #00C97B (Green) - VIA brand color
- Critical: #C23D3D (Red) - Alerts, errors
- Backgrounds: Pure black (#000000), surface (#0A0A0A with 5% white opacity)
- Borders: White with 4-12% opacity for glassmorphic effects
- Status Colors:
  - Active: #00C97B (Green)
  - Idle: #FFAA00 (Orange)
  - Charging: #3B83CC (Blue)
  - Maintenance: #D67500 (Dark Orange)
  - Offline: #666666 (Gray)
- Priority Colors: P1 (#C23D3D) → P2 (#D67500) → P3 (#3B83CC) → P4 (#00C97B)

**Typography**:
- **Primary Font**: Pretendard Variable (Korean-optimized, weights 100-900)
- **Fallback Font**: SF Pro Display (if Pretendard not available)
- Clean, modern sans-serif with excellent readability
- Variable font allows precise weight control
- See `PRETENDARD_FONT_SETUP.md` for installation instructions

**VIA Components** (in `lib/core/widgets/via/`):
- `ViaButton` - 4 variants (primary, secondary, ghost, danger), 3 sizes
- `ViaCard` - Glassmorphic cards with blur effects
- `ViaToast` - 4 variants with slide animations
- `ViaBottomSheet` - Draggable sheets with snap points
- `ViaInput` - Text inputs with validation
- `ViaStatusBadge`, `ViaPriorityBadge` - Status indicators
- And more (see `VIA_DESIGN_SYSTEM_STATUS.md`)

**Spacing Scale**: 2, 4, 8, 12, 16, 20, 24, 32 (xxs to 2xl)

**Animations**:
- Fast: 150ms (micro-interactions)
- Normal: 300ms (modals, sheets)
- Slow: 500ms (page transitions)
- Standard curve: easeInOut

**Access VIA Design Tokens**:
```dart
import 'package:aprofleet_manager/core/theme/via_design_tokens.dart';

// Use VIA components instead of Material widgets
ViaCard(
  child: Text('Content', style: ViaDesignTokens.headingMedium),
)

ViaButton.primary(
  text: 'Submit',
  onPressed: () {},
)

ViaToast.show(
  context: context,
  message: 'Success!',
  variant: ViaToastVariant.success,
)
```

**Important**: When working on new features or updates:
- Always use VIA components instead of Material widgets
- Follow patterns in `PHASE4_PLAN.md` for component migration
- Never mix Material and VIA components in the same screen

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
| VIA Theme | `lib/theme/via_theme.dart` |
| Industrial Dark Theme | `lib/theme/industrial_dark_theme.dart` |
| VIA Design Tokens | `lib/core/theme/via_design_tokens.dart` |
| Legacy Design Tokens | `lib/core/theme/design_tokens.dart` |
| VIA Components | `lib/core/widgets/via/*.dart` |
| Domain Models | `lib/domain/models/*.dart` |
| Auth Controller | `lib/features/auth/controllers/auth_controller.dart` |
| Live Map (Fleet) | `lib/features/fleet/pages/live_map_view.dart` |
| Cart Inventory | `lib/features/vehicles/pages/cart_inventory_list.dart` |
| Work Orders | `lib/features/service/pages/work_order_list_v2.dart` |
| Alerts | `lib/features/alerts/pages/alert_management_page_v2.dart` |
| Analytics | `lib/features/analytics/pages/analytics_dashboard.dart` |
| Settings | `lib/features/settings/pages/settings_page.dart` |
| Localization | `lib/core/localization/app_localizations.dart` |
| Seed Data | `assets/seeds/*.json` |

## Important Notes

- **VIA Design System**: Always use VIA components (ViaButton, ViaCard, etc.) instead of Material widgets
- **Never hardcode strings**: Always use `AppLocalizations.of(context)` for user-facing text
- **Always use ViaDesignTokens**: Never hardcode colors or spacing values
- **Stream cleanup**: All StreamSubscriptions must be cancelled in controller `dispose()`
- **Immutable models**: All domain models use Freezed, modify via `copyWith()`
- **Repository pattern**: UI never calls MockApi directly, always through repository providers
- **Authentication**: Auth state persisted in SharedPreferences, guards routes via GoRouter redirect
- **Haptic feedback**: Include `enableHaptic: true` for all interactive VIA components

## Project Status & Migration

**Current Version**: v0.2.0 (Released: 2025-10-28)
**Current Branch**: `main`

**VIA Design System Migration**: ✅ **COMPLETE**
- ✅ Phase 1-2: Core VIA components complete (11 components)
- ✅ Phase 3: Live Map View 100% VIA
- ✅ Phase 4: All remaining screens migrated
  - Settings Page 100% VIA
  - Work Orders 100% VIA
  - Cart Management 100% VIA
  - Alerts 100% VIA

**v0.2.0 Features**:
- ✅ VIA Design System - glassmorphic industrial dark theme
- ✅ Pretendard Variable font integration
- ✅ Live map with Google Maps + Mapbox support
- ✅ Enhanced cart cards with critical alerts and quick actions
- ✅ Custom cart markers with status-based colors
- ✅ Real-time telemetry streaming with MockWsHub
- ✅ 4-step work order creation wizard
- ✅ Real-time alert center with severity-based routing
- ✅ Outdoor visibility improvements

**Project Documentation**:
- [README.md](./README.md) - Project overview (Korean)
- [CHANGELOG.md](./CHANGELOG.md) - Version history
- [RELEASE_NOTES_v0.2.0.md](./RELEASE_NOTES_v0.2.0.md) - v0.2 release details
- [CONTRIBUTING.md](./CONTRIBUTING.md) - Development guidelines
- [GETTING_STARTED.md](./GETTING_STARTED.md) - Quick start guide
- [docs/design-system.md](./docs/design-system.md) - VIA Design System
- [docs/guides/junior-developer-guide.md](./docs/guides/junior-developer-guide.md) - Learning path
- [docs/archive/](./docs/archive/) - Historical documentation (PHASE plans, migration docs)
