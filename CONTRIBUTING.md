# Contributing to AproFleet Manager

Thank you for your interest in contributing to AproFleet Manager! This document provides guidelines and best practices for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Style Guidelines](#code-style-guidelines)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing Guidelines](#testing-guidelines)
- [Documentation Guidelines](#documentation-guidelines)

---

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Accept constructive criticism gracefully
- Focus on what is best for the project and community
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment or discriminatory language
- Personal attacks or trolling
- Publishing others' private information
- Other conduct which could reasonably be considered inappropriate

---

## Getting Started

### Prerequisites

Before contributing, ensure you have:

- **Flutter**: 3.0 or higher
- **Dart**: 3.0 or higher
- **IDE**: VS Code or Android Studio with Flutter plugins
- **Git**: Latest stable version

### Initial Setup

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/aprofleet_manager_app.git
   cd aprofleet_manager_app
   ```

3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/aprofleet_manager_app.git
   ```

4. **Install dependencies**:
   ```bash
   flutter pub get
   ```

5. **Generate code**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

6. **Verify setup**:
   ```bash
   flutter test
   flutter run
   ```

### Read the Documentation

Before making changes, familiarize yourself with:

- [README.md](./README.md) - Project overview
- [GETTING_STARTED.md](./GETTING_STARTED.md) - Quick start guide
- [docs/design-system.md](./docs/design-system.md) - VIA Design System
- [CLAUDE.md](./CLAUDE.md) - Project structure and conventions

---

## Development Workflow

### 1. Create a Feature Branch

Always create a new branch for your work:

```bash
# Update main branch
git checkout main
git pull upstream main

# Create feature branch
git checkout -b feature/your-feature-name
```

**Branch Naming Conventions**:
- `feature/` - New features (e.g., `feature/cart-filtering`)
- `fix/` - Bug fixes (e.g., `fix/map-marker-alignment`)
- `refactor/` - Code refactoring (e.g., `refactor/state-management`)
- `docs/` - Documentation updates (e.g., `docs/api-endpoints`)
- `test/` - Test additions/improvements (e.g., `test/kpi-calculator`)

### 2. Make Your Changes

#### Code Generation

If you modify:
- Domain models with `@freezed`
- Providers with `@riverpod`
- Models with `@JsonSerializable`

Run code generation:
```bash
dart run build_runner watch  # For continuous generation
# OR
dart run build_runner build --delete-conflicting-outputs  # One-time generation
```

#### Run Tests

Ensure all tests pass:
```bash
flutter test
```

#### Verify Linting

Fix any linting issues:
```bash
flutter analyze
dart fix --apply  # Auto-fix when possible
```

### 3. Commit Your Changes

Follow our [commit message guidelines](#commit-message-guidelines):

```bash
git add .
git commit -m "feat(vehicles): Add multi-select mode to cart inventory"
```

### 4. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

### 5. Create a Pull Request

1. Go to the original repository on GitHub
2. Click "New Pull Request"
3. Select your feature branch
4. Fill out the PR template (see [Pull Request Process](#pull-request-process))

---

## Code Style Guidelines

### General Principles

1. **Follow Flutter/Dart style guide**: https://dart.dev/guides/language/effective-dart
2. **Use VIA Design System**: Always use VIA components, never Material widgets
3. **Write self-documenting code**: Clear variable names, concise functions
4. **Keep functions small**: Max 50 lines per function
5. **Avoid deep nesting**: Max 3 levels of indentation

### Dart Conventions

#### Naming

```dart
// Classes: PascalCase
class CartInventoryController {}

// Constants: lowerCamelCase
const maxRetryAttempts = 3;

// Private members: _leadingUnderscore
final _apiClient = ApiClient();

// Files: snake_case
cart_inventory_list.dart
```

#### Imports

Order imports alphabetically within groups:

```dart
// 1. Dart imports
import 'dart:async';
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 4. Relative imports
import '../../core/theme/via_design_tokens.dart';
import '../controllers/cart_controller.dart';
```

### VIA Design System Usage

#### Always Use VIA Components

```dart
// ✅ CORRECT
ViaButton.primary(
  text: 'Submit',
  onPressed: () {},
)

// ❌ WRONG
ElevatedButton(
  onPressed: () {},
  child: Text('Submit'),
)
```

#### Use Design Tokens

```dart
// ✅ CORRECT
Container(
  padding: EdgeInsets.all(ViaDesignTokens.spacingMd),
  decoration: BoxDecoration(
    color: ViaDesignTokens.bgSurface,
    borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
  ),
)

// ❌ WRONG
Container(
  padding: EdgeInsets.all(16), // Hardcoded value
  decoration: BoxDecoration(
    color: Colors.grey[900], // Hardcoded color
    borderRadius: BorderRadius.circular(12), // Hardcoded radius
  ),
)
```

### State Management

#### Use Riverpod Providers

```dart
// Define provider with code generation
@riverpod
class CartInventory extends _$CartInventory {
  @override
  Future<List<Cart>> build() async {
    return ref.watch(cartRepositoryProvider).getCarts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(cartRepositoryProvider).getCarts();
    });
  }
}
```

#### Optimize Rebuilds

```dart
// ✅ CORRECT - Granular rebuild
final cartCount = ref.watch(
  cartInventoryProvider.select((state) => state.value?.length ?? 0)
);

// ❌ WRONG - Full rebuild
final state = ref.watch(cartInventoryProvider);
final cartCount = state.value?.length ?? 0;
```

### Clean Architecture

#### Feature Structure

```
features/vehicles/
├── pages/              # Full-screen views
│   └── cart_inventory_list.dart
├── controllers/        # StateNotifier controllers
│   └── cart_inventory_controller.dart
├── widgets/           # Feature-specific UI components
│   ├── cart_card.dart
│   └── cart_filter_sheet.dart
└── state/            # Feature-specific state models
    └── cart_inventory_state.dart
```

#### Dependency Rule

```dart
// ✅ CORRECT - UI depends on controller
class CartInventoryList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartInventoryControllerProvider);
    // ...
  }
}

// ❌ WRONG - UI directly calls repository
class CartInventoryList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carts = ref.watch(cartRepositoryProvider).getCarts(); // BAD!
    // ...
  }
}
```

---

## Commit Message Guidelines

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type

- **feat**: New feature
- **fix**: Bug fix
- **refactor**: Code refactoring
- **docs**: Documentation changes
- **test**: Test additions/improvements
- **chore**: Maintenance tasks
- **perf**: Performance improvements
- **style**: Code style changes (formatting, etc.)

### Scope

Feature module or component affected:
- `vehicles` - Cart management
- `fleet` - Live map and tracking
- `service` - Work orders
- `alerts` - Alert management
- `analytics` - Dashboard and KPIs
- `auth` - Authentication
- `settings` - App settings
- `core` - Core utilities/components

### Examples

```bash
feat(vehicles): Add multi-select mode to cart inventory

- Implemented checkbox selection UI
- Added bulk action toolbar
- Supports delete and status change operations

Closes #123

---

fix(fleet): Correct map marker clustering on zoom

Map markers were not clustering properly when zooming out beyond
level 12. Updated cluster algorithm to handle edge cases.

Fixes #456

---

refactor(core): Migrate TextFields to ViaInput components

Replaced all Material TextFields with ViaInput to maintain
design system consistency.

Part of VIA Design System migration (Phase 4)

---

docs(api): Add WebSocket event documentation

Documented all WebSocket events with payload schemas and
example responses.
```

---

## Pull Request Process

### PR Title

Follow commit message format:
```
feat(vehicles): Add multi-select mode to cart inventory
```

### PR Description Template

```markdown
## Description
Brief description of the changes.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Refactoring
- [ ] Documentation update
- [ ] Performance improvement

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
- [ ] All existing tests pass
- [ ] New tests added (if applicable)
- [ ] Manual testing completed

## Screenshots (if applicable)
[Add screenshots here]

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No new warnings introduced
- [ ] VIA Design System components used
```

### Review Process

1. **Automated Checks**: CI/CD runs tests and linting
2. **Code Review**: At least one maintainer reviews code
3. **Address Feedback**: Make requested changes
4. **Approval**: Maintainer approves PR
5. **Merge**: Squash and merge to main

---

## Testing Guidelines

### Unit Tests

Test business logic and utilities:

```dart
// test/kpi_calculator_test.dart
void main() {
  group('KpiCalculator', () {
    test('calculates availability rate correctly', () {
      final sample = CartSample(
        operatingHours: 8.0,
        downtimeMinutes: 60,
      );

      final kpi = KpiCalculator.fromSamples([sample]);

      expect(kpi.availabilityRate, closeTo(88.89, 0.01));
    });
  });
}
```

### Widget Tests

Test UI components:

```dart
// test/widgets/cart_card_test.dart
void main() {
  testWidgets('CartCard displays cart information', (tester) async {
    final cart = Cart(
      id: 'GCA-001',
      modelName: 'APRO G4',
      status: CartStatus.active,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CartCard(cart: cart),
        ),
      ),
    );

    expect(find.text('GCA-001'), findsOneWidget);
    expect(find.text('APRO G4'), findsOneWidget);
  });
}
```

### Integration Tests

Test feature workflows:

```dart
// integration_test/cart_inventory_test.dart
void main() {
  testWidgets('Can filter carts by status', (tester) async {
    await tester.pumpWidget(const App());

    // Navigate to cart inventory
    await tester.tap(find.text('Vehicles'));
    await tester.pumpAndSettle();

    // Open filter
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();

    // Select 'Active' filter
    await tester.tap(find.text('Active'));
    await tester.pumpAndSettle();

    // Verify only active carts shown
    // ...
  });
}
```

### Test Coverage

Aim for:
- **Unit Tests**: 80%+ coverage for business logic
- **Widget Tests**: 70%+ coverage for UI components
- **Integration Tests**: Critical user flows

Run coverage report:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Documentation Guidelines

### Inline Documentation

```dart
/// Calculates fleet KPIs from cart operational data.
///
/// Takes a list of [CartSample]s and computes:
/// - Availability rate (%)
/// - Mean time to repair (minutes)
/// - Utilization (km)
///
/// Example:
/// ```dart
/// final samples = [
///   CartSample(operatingHours: 8.0, downtimeMinutes: 30),
/// ];
/// final kpi = KpiCalculator.fromSamples(samples);
/// print(kpi.availabilityRate); // 93.75
/// ```
class KpiCalculator {
  /// Availability rate as percentage (0-100).
  final double availabilityRate;

  // ...
}
```

### README Updates

Update README.md when:
- Adding new features
- Changing setup process
- Updating dependencies
- Modifying architecture

### Architecture Documentation

Update docs when:
- Adding new modules
- Changing state management patterns
- Introducing new design patterns
- Modifying navigation structure

---

## Questions?

If you have questions about contributing:

1. **Check existing documentation**:
   - [README.md](./README.md)
   - [docs/](./docs/)
   - [CLAUDE.md](./CLAUDE.md)

2. **Search existing issues**: https://github.com/OWNER/aprofleet_manager_app/issues

3. **Open a discussion**: https://github.com/OWNER/aprofleet_manager_app/discussions

4. **Ask maintainers**: Tag @maintainer in your PR or issue

---

**Thank you for contributing to AproFleet Manager!** 🚀
