# AproFleet Manager v0.2.0 Release Notes

**Release Date**: October 28, 2025
**Version**: 0.2.0+1

## Overview

Version 0.2.0 represents a major milestone in the AproFleet Manager App development, introducing the complete **VIA Design System** with an industrial dark glassmorphic theme. This release focuses on modernizing the UI/UX, improving outdoor visibility, and establishing a solid foundation for enterprise-grade fleet management.

---

## What's New

### 1. VIA Design System Implementation

Complete migration to the VIA Industrial Dark theme with glassmorphic design language:

#### Core Components
- **ViaButton**: 4 variants (primary, secondary, ghost, danger) with 3 sizes
  - Haptic feedback integration
  - Loading states
  - Icon support
- **ViaCard**: Glassmorphic cards with blur effects and elevated shadows
- **ViaToast**: 4 variants (success, error, warning, info) with slide animations
- **ViaBottomSheet**: Draggable sheets with snap points and drag handles
- **ViaInput**: Text inputs with validation and error states
- **ViaStatusBadge**: Status indicators with monochrome color coding
- **ViaPriorityBadge**: Priority badges (P1-P4) with visual hierarchy
- **ViaStatChip**: Interactive stat chips for filtering and data visualization
- **ViaControlBar**: Advanced filtering and sorting control bar

#### Design Tokens
- **Primary Brand Color**: #00C97B (Green) - VIA signature color
- **Critical Alert Color**: #C23D3D (Red)
- **Backgrounds**: Pure black (#000000) with glassmorphic surfaces
- **Borders**: White with 4-12% opacity for elegant depth
- **Typography**: Pretendard Variable (Korean-optimized) with SF Pro Display fallback
- **Spacing Scale**: 2, 4, 8, 12, 16, 20, 24, 32px (xxs to 2xl)
- **Animation Timing**: Fast (150ms), Normal (300ms), Slow (500ms)

### 2. Enhanced Cart Management

#### Cart Cards Redesign
- **Critical Issue Alerts**: Visual indicators for carts requiring immediate attention
- **Quick Action Buttons**:
  - Track: Navigate to live map with cart focus
  - Service: Create work order for cart
  - Details: View complete cart information
- **Outdoor Visibility**: Increased contrast and larger touch targets
- **Glassmorphic Design**: Elegant shadows and blur effects
- **Status Indicators**: Clear visual status badges (Active, Idle, Charging, Maintenance, Offline)

#### Cart Inventory Improvements
- **ViaControlBar Integration**: Advanced filtering and sorting
- **ViaStatChip**: Interactive summary statistics
- **Search Functionality**: Real-time cart search
- **Multi-Select Mode**: Bulk operations support

### 3. Live Map Enhancements

- **Custom Cart Markers**: Status-based color coding with vehicle icons
- **Real-Time Telemetry**: Live battery, speed, and position updates
- **Map Provider Switching**: Toggle between Google Maps and Mapbox
- **Geofence Visualization**: Course boundaries with polygon rendering
- **Cluster Management**: Performance-optimized marker clustering
- **Cart Focus Mode**: Center and track individual cart

### 4. Work Order System

- **4-Step Creation Wizard**:
  1. Issue Description with auto-priority suggestion
  2. Location Selection (QR scan or manual)
  3. Schedule (date, time, duration, notes)
  4. Review & Submit
- **Priority Workflow**: P1 (Critical) → P2 (High) → P3 (Medium) → P4 (Low)
- **Status Tracking**: draft → pending → inProgress → onHold → completed/cancelled
- **Parts Management**: Add/remove parts with quantity tracking
- **Technician Assignment**: Assign and reassign technicians
- **Checklist Support**: Task completion tracking

### 5. Alert Management

- **Real-Time Alert Center**: Live alert streaming via WebSocket simulation
- **Severity-Based Routing**:
  - Critical: Immediate notification with vibration
  - Warning: Standard notification
  - Info: Silent notification
- **Escalation Workflow**: Automatic escalation based on SLA
- **Action History**: Complete audit trail
- **Quick Actions**:
  - Acknowledge alert
  - Create work order
  - Navigate to cart
  - Resolve alert

### 6. Settings Page (100% VIA)

- **Language Selection**: EN, JA, KO, ZH (Simplified & Traditional)
- **Map Provider**: Toggle between Google Maps and Mapbox
- **Theme Settings**: Dark mode (Industrial Dark) with glassmorphic effects
- **Notification Preferences**: Configure alert severity thresholds
- **Profile Management**: User information and logout

### 7. Internationalization

Complete i18n support across all features:
- **English**: Default language
- **Japanese**: Full translation
- **Korean**: Full translation with Pretendard font optimization
- **Chinese**: Simplified and Traditional variants

---

## Technical Improvements

### Architecture
- **Clean Architecture**: Feature-based organization with clear separation of concerns
- **Domain Layer**: Pure Dart models with Freezed for immutability
- **Data Layer**: Repository pattern with mock API ready for backend swap
- **Presentation Layer**: Riverpod state management with StateNotifier pattern

### State Management
- **Riverpod 2.4.9**: Code generation for providers
- **Granular Rebuilds**: `.select()` for performance optimization
- **StreamSubscription**: Proper lifecycle management with dispose

### Navigation
- **GoRouter 12.1.3**: Declarative routing with authentication guards
- **ShellRoute**: Persistent navigation structure
- **Deep Linking**: Support for cart/:id and alert/:id routes

### Code Quality
- **Strict Linting**: Flutter lints 3.0.1 with custom rules
- **Code Generation**: build_runner for Freezed, JSON serialization, and Riverpod
- **Testing**: Unit tests for KPI calculations, priority queuing, and code formatters
- **Documentation**: Comprehensive inline documentation and architecture guides

### Performance
- **ListView.builder**: Virtualization for long lists
- **CachedNetworkImage**: Image caching and optimization
- **Debounced Search**: Reduced API calls with search throttling
- **Optimized Rebuilds**: Selective widget rebuilds with Riverpod selectors

---

## Breaking Changes

### Navigation Structure
- **Removed Bottom Tabs**: Cleaner single-page navigation pattern
  - Old: Bottom navigation with Fleet, Vehicles, Service, Alerts tabs
  - New: ProfessionalAppBar with contextual navigation

### Component API
- **Material → VIA Migration**:
  - Replace `ElevatedButton` with `ViaButton`
  - Replace `Card` with `ViaCard`
  - Replace `SnackBar` with `ViaToast`
  - Replace `AlertDialog` with `ViaBottomSheet`

### Theme Changes
- **Design Tokens**: Use `ViaDesignTokens` instead of `DesignTokens`
- **Color Scheme**: Monochrome glassmorphic palette replaces colorful Material Design

---

## Migration Guide

### For Developers

#### 1. Update Dependencies
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

#### 2. Migrate UI Components
```dart
// Old (Material)
ElevatedButton(
  onPressed: () {},
  child: Text('Submit'),
)

// New (VIA)
ViaButton.primary(
  text: 'Submit',
  onPressed: () {},
)
```

#### 3. Update Imports
```dart
// Add VIA imports
import 'package:aprofleet_manager/core/widgets/via/via_button.dart';
import 'package:aprofleet_manager/core/theme/via_design_tokens.dart';
```

#### 4. Follow Documentation
- Read `docs/design-system.md` for complete VIA component usage
- See `docs/guides/junior-developer-guide.md` for onboarding
- Check `CONTRIBUTING.md` for development workflow

---

## Known Issues

### Minor Issues
- **Mapbox Initialization**: Occasional delay on first map load (1-2 seconds)
- **QR Scanner**: Camera permission prompt may require app restart on iOS
- **Image Picker**: Limited to 5MB file size for cart photos

### Workarounds
- **Mapbox Delay**: Switching to Google Maps provider resolves initial load
- **Camera Permissions**: Grant permission in iOS Settings > AproFleet Manager > Camera
- **Large Images**: Use image compression before upload

### Planned Fixes (v0.2.1)
- Optimize Mapbox initialization sequence
- Implement automatic camera permission handling
- Add client-side image compression

---

## What's Next (v0.3.0 Roadmap)

### Analytics Module Enhancement
- **Real-Time KPI Dashboard**: Live metrics with 30-second refresh
- **Chart Visualizations**: fl_chart integration for trends
- **Export Functionality**: CSV/PDF report generation
- **Custom Date Ranges**: Flexible time period selection

### Work Order Enhancements
- **Photo Attachment**: Before/after photos for work orders
- **Parts Inventory**: Real-time parts availability checking
- **Technician Notes**: Rich text notes with formatting
- **Signature Capture**: Digital signature for work completion

### Fleet Tracking Improvements
- **Heatmap View**: Usage density visualization
- **Route Replay**: Historical route playback
- **Predictive Maintenance**: ML-based maintenance suggestions
- **Battery Health Trends**: Historical battery performance charts

---

## Installation & Setup

### Prerequisites
- Flutter 3.0 or higher
- Dart 3.0 or higher
- Xcode 15+ (for iOS)
- Android Studio (for Android)

### Quick Start
```bash
# Clone repository
git clone <repository-url>
cd aprofleet_manager_app

# Install dependencies
flutter pub get

# Generate code
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

For detailed setup instructions, see `GETTING_STARTED.md`.

---

## Documentation

### New Documentation
- **CHANGELOG.md**: Keep a Changelog format changelog
- **CONTRIBUTING.md**: Development workflow and guidelines
- **GETTING_STARTED.md**: Quick start for junior developers
- **docs/design-system.md**: Complete VIA Design System guide
- **docs/guides/junior-developer-guide.md**: Onboarding guide

### Updated Documentation
- **README.md**: Comprehensive v0.2 overview
- **CLAUDE.md**: Updated project instructions for Claude Code
- **docs/architecture.md**: Architecture deep-dive

---

## Credits

### Development Team
- **DY Innovate**: APRO golf cart manufacturer and project sponsor
- **VIA Design System**: Industrial dark glassmorphic design language
- **Flutter Team**: Framework and tooling

### Open Source Libraries
- **Riverpod**: State management and dependency injection
- **Freezed**: Immutable data classes
- **GoRouter**: Declarative routing
- **Google Maps / Mapbox**: Map providers
- **Pretendard**: Korean-optimized typography

---

## Support

For issues, questions, or contributions:
- **Issue Tracker**: [GitHub Issues](https://github.com/yourusername/aprofleet_manager/issues)
- **Documentation**: [docs/](./docs/)
- **Contributing Guide**: [CONTRIBUTING.md](./CONTRIBUTING.md)

---

**Thank you for using AproFleet Manager!**

For more information about v0.2.0, see:
- [CHANGELOG.md](./CHANGELOG.md)
- [README.md](./README.md)
- [VIA Design System Documentation](./docs/design-system.md)
