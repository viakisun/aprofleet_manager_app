# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**AproFleet Manager App** - A comprehensive fleet management system for APRO golf carts manufactured by DY Innovate. Built with Flutter using Clean Architecture principles with feature-based organization.

- **Brand**: APRO golf carts
- **Manufacturer**: DY Innovate
- **Current Phase**: VIA Design System Migration (Phase 4)
- **Supported Languages**: English, Japanese, Korean, Chinese (Simplified & Traditional)
- **Design**: VIA Design System - Dark monochrome with glassmorphism

## Build, Test, and Run Commands

### Development Setup
```bash
# Install dependencies
flutter pub get

# Generate code (Freezed models, Riverpod providers, JSON serialization)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for continuous code generation during development
dart run build_runner watch --delete-conflicting-outputs

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
   - Controllers use `StateNotifier` pattern with Riverpod code generation
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

// Controllers use generated StateNotifier
@riverpod
class CartInventoryController extends _$CartInventoryController {
  @override
  CartInventoryState build() => CartInventoryState.initial();

  Future<void> filterByStatus(CartStatus status) async {
    state = state.copyWith(filter: state.filter.copyWith(status: status));
    await _refreshCarts();
  }
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

## VIA Design System

**Current Status:** Phase 4 in progress - migrating entire app to VIA Design System
**Documentation:** See `PHASE4_PLAN.md` and `VIA_DESIGN_SYSTEM_STATUS.md` for detailed migration roadmap

### VIA Components Available (16 total)

**Basic Components (11)**:
- `ViaButton` - 4 variants (primary, secondary, ghost, danger), 3 sizes
- `ViaIconButton` - 3 variants (primary, secondary, ghost), circular design
- `ViaCard` - Glassmorphic cards with subtle elevation
- `ViaChip` - Filter chips with animations
- `ViaToast` - 4 variants (success, error, warning, info) with slide animations
- `ViaBottomSheet` - Draggable sheets with snap points
- `ViaModal` - Modal dialogs with VIA styling
- `ViaStatusBadge` - Status indicators (active, idle, charging, maintenance, offline)
- `ViaPriorityBadge` - Priority levels (P1-P4) with color mapping
- `ViaLoadingIndicator` - Loading states
- `ViaInput` - Text input fields with validation

**Custom Components (5)**:
- `ViaFilterSheet` - Filter bottom sheet (used in Live Map)
- `ViaStatusBar` - Status filter chips with animations
- `ViaCartListItem` - Cart list item with scale animations
- `MicroTag` - Map marker badges
- `ToneControlSlider` - Opacity control slider

**Recently Added Components**:
- `ViaSwitch` - Toggle switches with haptic feedback
- `ViaCheckbox` - Checkboxes with check animation
- `ViaSelect` - Dropdown/bottom sheet pickers
- `ViaDatePicker` - Calendar date picker in VIA style

### Design Tokens Location

All design tokens are centralized in `lib/core/theme/via_design_tokens.dart`:

```dart
// Colors
ViaDesignTokens.primary           // #00C97B (Green)
ViaDesignTokens.secondary         // #3B83CC (Blue)
ViaDesignTokens.warning           // #D67500 (Orange)
ViaDesignTokens.critical          // #C23D3D (Red)
ViaDesignTokens.surfacePrimary    // #0F0F0F (Pure black)
ViaDesignTokens.surfaceSecondary  // #181818
ViaDesignTokens.textPrimary       // #FFFFFF
ViaDesignTokens.textSecondary     // #A0A0A0

// Typography
ViaDesignTokens.headingLarge      // 24px, w700
ViaDesignTokens.headingMedium     // 20px, w600
ViaDesignTokens.bodyMedium        // 14px, w400
ViaDesignTokens.labelSmall        // 12px, w600

// Spacing
ViaDesignTokens.spacingXs         // 4px
ViaDesignTokens.spacingSm         // 8px
ViaDesignTokens.spacingMd         // 12px
ViaDesignTokens.spacingLg         // 16px
ViaDesignTokens.spacingXl         // 20px

// Animations
ViaDesignTokens.durationFast      // 150ms
ViaDesignTokens.durationNormal    // 300ms
ViaDesignTokens.curveStandard     // easeInOut
```

### Using VIA Components

**ALWAYS prefer VIA components over Material equivalents:**

```dart
// ✅ CORRECT - Use VIA components
ViaToast.show(
  context: context,
  message: 'Success!',
  variant: ViaToastVariant.success,
);

ViaButton.primary(
  text: 'Submit',
  onPressed: () {},
  icon: Icons.check,
);

ViaCard(
  child: Text('Content', style: ViaDesignTokens.bodyMedium),
);

ViaBottomSheet.show(
  context: context,
  header: Text('Title', style: ViaDesignTokens.headingMedium),
  child: Text('Content'),
  footer: Row(
    children: [
      Expanded(child: ViaButton.ghost(text: 'Cancel', onPressed: () {})),
      SizedBox(width: ViaDesignTokens.spacingMd),
      Expanded(child: ViaButton.primary(text: 'OK', onPressed: () {})),
    ],
  ),
);

// ❌ WRONG - Don't use Material equivalents
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('...')));
ElevatedButton(child: Text('Submit'), onPressed: () {});
Card(child: Text('Content'));
showDialog(context: context, builder: (context) => AlertDialog(...));
```

### Migration Status

**Completed (✅)**:
- Live Map View (100% VIA)
- Auth screens (Login, Onboarding, Splash)
- Work Order module (100% VIA)

**In Progress (⏳)**:
- Settings Page
- Alert Management
- Cart Management
- Analytics Dashboard

See `VIA_DESIGN_SYSTEM_STATUS.md` for detailed migration tracking.

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

## Development Workflows

### Adding a New Feature

1. Create feature directory under `lib/features/new_feature/`
2. Define domain models in `lib/domain/models/` with `@freezed`
3. Add repository interface and mock implementation
4. Register provider in `lib/core/services/providers.dart`
5. Create controller extending generated Riverpod controller base
6. Build UI pages/widgets using `ConsumerWidget` and VIA components
7. Register routes in `lib/router/app_router.dart`
8. Run `dart run build_runner build --delete-conflicting-outputs`

### Adding Localization

1. Add key to `lib/core/localization/app_localizations.dart`
2. Implement in `app_localizations_en.dart`, `_ja.dart`, `_ko.dart`, `_zh.dart`
3. Use in UI: `AppLocalizations.of(context).yourTranslationKey`

### Performance Optimization

- Use `ref.watch(...).select((s) => s.specificField)` to avoid unnecessary rebuilds
- Prefer `ListView.builder` for long lists (virtualization)
- Cancel StreamSubscriptions in controller `dispose()`
- Limit image sizes (thumbnails at 200x200 via `ImageOptimizer`)

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

**Core Architecture:**
- Entry: `lib/main.dart`, `lib/app.dart`
- Routing: `lib/router/app_router.dart`
- DI/Providers: `lib/core/services/providers.dart`
- Mock Data: `lib/core/services/mock/mock_api.dart`, `lib/core/services/mock/mock_ws_hub.dart`

**VIA Design System:**
- Design Tokens: `lib/core/theme/via_design_tokens.dart`
- VIA Components: `lib/core/widgets/via/*.dart`
- Legacy Tokens: `lib/core/theme/design_tokens.dart` (being phased out)

**Domain Models:** `lib/domain/models/*.dart`

**Features:** `lib/features/<module>/{pages,controllers,widgets}/`

**Localization:** `lib/core/localization/app_localizations*.dart`

**Seed Data:** `assets/seeds/*.json`

## Critical Development Rules

1. **VIA Design System First**: ALWAYS use VIA components instead of Material equivalents (ElevatedButton → ViaButton, SnackBar → ViaToast, AlertDialog → ViaBottomSheet, etc.)

2. **No Hardcoded Design Values**: Use `ViaDesignTokens` for all colors, spacing, typography, and animations. Never hardcode `Color()`, `EdgeInsets`, or font sizes.

3. **Localization Required**: Use `AppLocalizations.of(context)` for all user-facing text. Never hardcode strings.

4. **Stream Cleanup**: All StreamSubscriptions must be cancelled in controller `dispose()` to prevent memory leaks.

5. **Immutable Models**: All domain models use Freezed. Modify via `copyWith()`, never by direct mutation.

6. **Repository Pattern**: UI never calls MockApi directly. Always use repository providers.

7. **Code Generation**: After modifying models or providers, run `dart run build_runner build --delete-conflicting-outputs`

8. **Authentication**: Auth state persisted in SharedPreferences, guards routes via GoRouter redirect.

## Project Status

**Current Phase:** VIA Design System Migration (Phase 4)
**Branch:** main
**Latest Milestone:** Work Order module VIA conversion complete (Phase 4 Week 1)

**Recent Commits:**
- Complete Work Order module VIA conversion (Day 1-4)
- Add VIA Design System Status documentation
- Implement ViaSwitch, ViaCheckbox, ViaSelect, ViaDatePicker components

**Next Steps:** Settings Page migration, Alert Management migration
**See:** `PHASE4_PLAN.md` for detailed 4-week migration roadmap

## Additional Resources

For comprehensive Korean documentation, see `README.md`.
For design system migration details, see `PHASE4_PLAN.md` and `VIA_DESIGN_SYSTEM_STATUS.md`.
