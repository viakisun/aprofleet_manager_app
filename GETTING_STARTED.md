# Getting Started with AproFleet Manager

Welcome to AproFleet Manager! This guide will help you set up the development environment and start contributing quickly.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Running the App](#running-the-app)
- [Development Workflow](#development-workflow)
- [Common Tasks](#common-tasks)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)

---

## Prerequisites

### Required Software

1. **Flutter SDK** (3.0+)
   - Download: https://docs.flutter.dev/get-started/install
   - Verify: `flutter --version`

2. **Dart SDK** (3.0+)
   - Included with Flutter
   - Verify: `dart --version`

3. **IDE** (Choose one)
   - **VS Code** (recommended)
     - Install Flutter extension
     - Install Dart extension
   - **Android Studio**
     - Install Flutter plugin
     - Install Dart plugin

4. **Git**
   - Download: https://git-scm.com/downloads
   - Verify: `git --version`

### Platform-Specific Requirements

#### For iOS Development (macOS only)
- **Xcode** 15 or higher
- **CocoaPods**: `sudo gem install cocoapods`
- **iOS Simulator** (included with Xcode)

#### For Android Development
- **Android Studio** with Android SDK
- **Android Emulator** (configure via Android Studio)
- **Java Development Kit** (JDK) 17+

---

## Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd aprofleet_manager_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

This downloads all packages specified in `pubspec.yaml`.

### 3. Generate Code

The project uses code generation for:
- **Freezed**: Immutable data models
- **Riverpod**: State management providers
- **JSON Serialization**: Model serialization

Run code generation:

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Watch mode** (automatic regeneration on file changes):

```bash
dart run build_runner watch
```

### 4. Configure Environment Variables

Create a `.env` file in the project root (if not exists):

```bash
# .env
GOOGLE_MAPS_API_KEY=your_google_maps_key
MAPBOX_ACCESS_TOKEN=your_mapbox_token
```

### 5. Verify Installation

```bash
# Check for issues
flutter doctor

# Run tests
flutter test

# Analyze code
flutter analyze
```

---

## Project Structure

### High-Level Overview

```
aprofleet_manager_app/
├── lib/
│   ├── main.dart                   # App entry point
│   ├── app.dart                    # App widget with routing
│   ├── core/                       # Shared utilities and services
│   │   ├── services/              # API, repositories, providers
│   │   ├── theme/                 # Design tokens and themes
│   │   ├── widgets/               # Reusable UI components
│   │   ├── localization/          # i18n translations
│   │   └── utils/                 # Helper functions
│   ├── domain/                     # Business logic layer
│   │   └── models/                # Freezed data models
│   ├── features/                   # Feature modules
│   │   ├── auth/                  # Authentication
│   │   ├── fleet/                 # Live map tracking
│   │   ├── vehicles/              # Cart management
│   │   ├── service/               # Work orders
│   │   ├── alerts/                # Alert management
│   │   ├── analytics/             # KPI dashboard
│   │   └── settings/              # App settings
│   └── router/                     # GoRouter configuration
├── assets/                         # Images, fonts, seed data
├── test/                          # Unit and widget tests
├── docs/                          # Documentation
└── pubspec.yaml                   # Dependencies
```

### Feature Module Structure

Each feature follows Clean Architecture:

```
features/vehicles/
├── pages/                          # Full-screen views
│   └── cart_inventory_list.dart
├── controllers/                    # StateNotifier controllers
│   └── cart_inventory_controller.dart
├── widgets/                        # Feature-specific widgets
│   ├── cart_card.dart
│   └── cart_filter_sheet.dart
└── state/                         # State models (if needed)
    └── cart_inventory_state.dart
```

---

## Running the App

### List Available Devices

```bash
flutter devices
```

### Run on Specific Device

```bash
# iOS Simulator
flutter run -d "iPhone 16 Plus"

# Android Emulator
flutter run -d emulator-5554

# Chrome (web)
flutter run -d chrome
```

### Hot Reload

While app is running:
- **Hot Reload**: Press `r` (reloads code changes)
- **Hot Restart**: Press `R` (full restart)
- **Quit**: Press `q`

### Debug Mode vs Release Mode

```bash
# Debug mode (default)
flutter run

# Release mode (optimized)
flutter run --release

# Profile mode (for performance profiling)
flutter run --profile
```

---

## Development Workflow

### Typical Day-to-Day Workflow

1. **Start code generation** (in separate terminal):
   ```bash
   dart run build_runner watch
   ```

2. **Run the app**:
   ```bash
   flutter run
   ```

3. **Make code changes**
   - Edit files
   - Save (hot reload happens automatically)

4. **Test changes**:
   ```bash
   flutter test
   ```

5. **Check code quality**:
   ```bash
   flutter analyze
   ```

6. **Commit changes** (see [CONTRIBUTING.md](./CONTRIBUTING.md))

### Working with Features

#### Adding a New Feature

1. **Create feature directory**:
   ```bash
   mkdir -p lib/features/my_feature/{pages,controllers,widgets}
   ```

2. **Define domain model** (if needed):
   ```dart
   // lib/domain/models/my_model.dart
   import 'package:freezed_annotation/freezed_annotation.dart';

   part 'my_model.freezed.dart';
   part 'my_model.g.dart';

   @freezed
   class MyModel with _$MyModel {
     const factory MyModel({
       required String id,
       required String name,
     }) = _MyModel;

     factory MyModel.fromJson(Map<String, dynamic> json) =>
         _$MyModelFromJson(json);
   }
   ```

3. **Create controller**:
   ```dart
   // lib/features/my_feature/controllers/my_controller.dart
   import 'package:riverpod_annotation/riverpod_annotation.dart';

   part 'my_controller.g.dart';

   @riverpod
   class MyFeature extends _$MyFeature {
     @override
     Future<MyModel> build() async {
       // Initialize state
       return MyModel(id: '1', name: 'Example');
     }

     Future<void> update(String name) async {
       // Update logic
     }
   }
   ```

4. **Build UI**:
   ```dart
   // lib/features/my_feature/pages/my_page.dart
   import 'package:flutter/material.dart';
   import 'package:flutter_riverpod/flutter_riverpod.dart';

   class MyPage extends ConsumerWidget {
     @override
     Widget build(BuildContext context, WidgetRef ref) {
       final state = ref.watch(myFeatureProvider);

       return Scaffold(
         appBar: AppBar(title: Text('My Feature')),
         body: state.when(
           data: (model) => Text(model.name),
           loading: () => CircularProgressIndicator(),
           error: (err, stack) => Text('Error: $err'),
         ),
       );
     }
   }
   ```

5. **Register route**:
   ```dart
   // lib/router/app_router.dart
   GoRoute(
     path: '/my-feature',
     builder: (context, state) => MyPage(),
   ),
   ```

6. **Generate code**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

---

## Common Tasks

### Add a New Dependency

1. **Add to pubspec.yaml**:
   ```yaml
   dependencies:
     new_package: ^1.0.0
   ```

2. **Install**:
   ```bash
   flutter pub get
   ```

### Create a New VIA Component

Use existing VIA components as templates:

```dart
import 'package:aprofleet_manager/core/widgets/via/via_button.dart';

ViaButton.primary(
  text: 'Click Me',
  onPressed: () {
    print('Button clicked!');
  },
)
```

See [docs/design-system.md](./docs/design-system.md) for all VIA components.

### Add Translations

1. **Add key to AppLocalizations**:
   ```dart
   // lib/core/localization/app_localizations.dart
   String get myNewKey;
   ```

2. **Implement in each language**:
   ```dart
   // lib/core/localization/app_localizations_en.dart
   @override
   String get myNewKey => 'My New Text';

   // lib/core/localization/app_localizations_ko.dart
   @override
   String get myNewKey => '내 새로운 텍스트';
   ```

3. **Use in UI**:
   ```dart
   Text(AppLocalizations.of(context).myNewKey)
   ```

### Run Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/kpi_calculator_test.dart

# With coverage
flutter test --coverage
```

### Build for Production

```bash
# Android APK
flutter build apk

# Android App Bundle (for Play Store)
flutter build appbundle

# iOS (macOS only)
flutter build ios
```

---

## Troubleshooting

### Issue: Code Generation Fails

**Solution**:
```bash
# Clean generated files
dart run build_runner clean

# Remove build cache
rm -rf .dart_tool/build

# Regenerate
dart run build_runner build --delete-conflicting-outputs
```

### Issue: "Target of URI doesn't exist"

**Cause**: Missing generated files (`.g.dart` or `.freezed.dart`)

**Solution**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Issue: Hot Reload Not Working

**Solution**:
- Press `R` for hot restart
- Or restart the app completely: `q` then `flutter run`

### Issue: Dependency Conflicts

**Solution**:
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Issue: iOS Build Fails

**Solution**:
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

### Issue: Android Build Fails

**Solution**:
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter run
```

### Issue: Map Not Showing

**Check**:
1. API keys in `.env` file
2. API keys in `AndroidManifest.xml` (Android)
3. API keys in `AppDelegate.swift` (iOS)
4. Internet permissions in manifest files

---

## Next Steps

### For Junior Developers

1. **Read the guides**:
   - [docs/guides/junior-developer-guide.md](./docs/guides/junior-developer-guide.md)
   - [docs/design-system.md](./docs/design-system.md)

2. **Explore the codebase**:
   - Start with `lib/main.dart`
   - Trace through feature modules
   - Read existing code

3. **Try small changes**:
   - Update a text label
   - Change a color using VIA tokens
   - Add a new button

4. **Run and test**:
   - Use hot reload to see changes
   - Run tests to verify behavior

### For Experienced Developers

1. **Review architecture**:
   - [docs/architecture/overview.md](./docs/architecture/overview.md)
   - [CLAUDE.md](./CLAUDE.md)

2. **Understand state management**:
   - Riverpod 2.4.9 with code generation
   - Provider patterns

3. **Explore the Mock API**:
   - `lib/core/services/mock/mock_api.dart`
   - `lib/core/services/mock/mock_ws_hub.dart`

4. **Review VIA Design System**:
   - [docs/design-system.md](./docs/design-system.md)
   - Component library in `lib/core/widgets/via/`

### Resources

- **Flutter Docs**: https://docs.flutter.dev/
- **Riverpod Docs**: https://riverpod.dev/
- **Freezed Docs**: https://pub.dev/packages/freezed
- **GoRouter Docs**: https://pub.dev/packages/go_router
- **Project README**: [README.md](./README.md)
- **Contributing Guide**: [CONTRIBUTING.md](./CONTRIBUTING.md)

---

## Need Help?

1. **Check documentation**: [docs/](./docs/)
2. **Search issues**: [GitHub Issues](https://github.com/OWNER/aprofleet_manager_app/issues)
3. **Ask team**: Reach out on Slack/Discord
4. **Open discussion**: [GitHub Discussions](https://github.com/OWNER/aprofleet_manager_app/discussions)

---

**Happy coding!** 🚀

For more detailed information, see:
- [README.md](./README.md) - Project overview
- [CONTRIBUTING.md](./CONTRIBUTING.md) - Development guidelines
- [docs/design-system.md](./docs/design-system.md) - VIA Design System
- [docs/guides/junior-developer-guide.md](./docs/guides/junior-developer-guide.md) - Learning path
