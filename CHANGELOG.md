# Changelog

All notable changes to the AproFleet Manager App will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2025-10-28

### Added
- **VIA Design System**: Complete implementation of industrial dark glassmorphic design
  - 11 core VIA components (ViaButton, ViaCard, ViaToast, ViaBottomSheet, etc.)
  - ViaControlBar for advanced filtering and sorting
  - ViaStatChip for data visualization
  - ViaStatusBadge and ViaPriorityBadge for status indicators
- **Pretendard Variable Font**: Korean-optimized primary typography with SF Pro Display fallback
- **Enhanced Cart Cards**:
  - Critical issue alerts with visual indicators
  - Quick action buttons (Track, Service, Details)
  - Outdoor visibility improvements with increased contrast
  - Glassmorphic design with elegant shadows
- **Live Map Improvements**:
  - Custom cart markers with status-based colors
  - Real-time telemetry streaming
  - Map provider switching (Google Maps / Mapbox)
  - Geofence visualization
- **Work Order Module**:
  - 4-step creation wizard with validation
  - Priority-based workflow (P1-P4)
  - Auto-priority suggestions based on issue type
  - Parts list management
- **Alert System**:
  - Real-time alert center with severity-based routing
  - Escalation workflow with SLA tracking
  - Action history for audit trails
- **Internationalization**: Support for English, Japanese, Korean, and Chinese (Simplified & Traditional)

### Changed
- **Navigation Redesign**: Removed bottom tabs in favor of cleaner single-page navigation
- **Architecture**: Migrated to feature-based Clean Architecture with Riverpod 2.4.9
- **UI Theme**: Complete migration from Material Design to VIA Industrial Dark theme
- **Settings Page**: 100% VIA Design System implementation
- **Cart Inventory**: Enhanced filtering with ViaControlBar integration

### Improved
- **Performance**: Optimized state management with granular rebuilds using `.select()`
- **Accessibility**: Minimum touch areas (48x48) for all interactive elements
- **Code Quality**: Strict linting rules and consistent code style
- **Documentation**: Comprehensive architecture and design system documentation

### Fixed
- Cart status badge alignment in inventory list
- Alert notification timing issues
- Map marker clustering performance
- Navigation state preservation across routes

## [0.1.1] - 2025-10-20

### Added
- Basic cart inventory management
- Work order CRUD operations
- Alert notifications
- Analytics dashboard with KPI calculations

### Changed
- Initial project setup with Flutter 3.0+
- Mock API implementation for development

## [0.1.0] - 2025-10-15

### Added
- Initial project structure
- Authentication flow (splash, onboarding, login)
- Google Maps integration
- Basic fleet tracking functionality
- Domain models with Freezed
- State management with Riverpod
- Navigation with GoRouter

---

## Version History Summary

- **v0.2.0** (2025-10-28): VIA Design System complete implementation, enhanced UI/UX
- **v0.1.1** (2025-10-20): Core features and mock API
- **v0.1.0** (2025-10-15): Initial release with basic fleet tracking

[0.2.0]: https://github.com/yourusername/aprofleet_manager/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/yourusername/aprofleet_manager/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/yourusername/aprofleet_manager/releases/tag/v0.1.0
