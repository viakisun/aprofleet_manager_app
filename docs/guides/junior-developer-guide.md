# Junior Developer Guide

Welcome to the AproFleet Manager development team! This guide will help you understand the codebase, learn our patterns, and become productive quickly.

## Table of Contents

- [Welcome](#welcome)
- [Learning Path](#learning-path)
- [Understanding the Codebase](#understanding-the-codebase)
- [Key Concepts](#key-concepts)
- [Common Patterns](#common-patterns)
- [Your First Tasks](#your-first-tasks)
- [Best Practices](#best-practices)
- [Getting Help](#getting-help)

---

## Welcome

### What is AproFleet Manager?

AproFleet Manager is a **fleet management system** for APRO golf carts. It helps operators:
- Track cart locations in real-time
- Monitor battery levels and cart health
- Manage maintenance and work orders
- Respond to alerts and issues

### Technology Stack

- **Flutter**: Cross-platform mobile framework
- **Dart**: Programming language
- **Riverpod**: State management
- **Freezed**: Immutable data models
- **GoRouter**: Navigation
- **VIA Design System**: UI components

### Project Goals

- **Clarity**: Easy to understand and maintain
- **Performance**: Fast and responsive
- **Reliability**: Stable and bug-free
- **Scalability**: Ready for growth

---

## Learning Path

### Week 1: Setup and Exploration

**Goals**:
- Get the project running on your machine
- Explore the codebase structure
- Understand the app flow

**Tasks**:
1. Complete [GETTING_STARTED.md](../../GETTING_STARTED.md) setup
2. Run the app and explore all features
3. Read [README.md](../../README.md) overview
4. Browse `lib/` directory structure

**Resources**:
- Flutter basics: https://docs.flutter.dev/get-started/codelab
- Dart language tour: https://dart.dev/guides/language/language-tour

### Week 2: Understanding State Management

**Goals**:
- Learn Riverpod fundamentals
- Understand provider patterns
- Practice reading controller code

**Tasks**:
1. Read Riverpod docs: https://riverpod.dev/docs/getting_started
2. Study `lib/features/vehicles/controllers/cart_inventory_controller.dart`
3. Trace how data flows from provider to UI
4. Make small state changes and observe results

**Resources**:
- Riverpod tutorial: https://riverpod.dev/docs/essentials/first_request
- Our provider file: `lib/core/services/providers.dart`

### Week 3: Building UI with VIA

**Goals**:
- Master VIA component library
- Build simple UI screens
- Understand design tokens

**Tasks**:
1. Read [docs/design-system.md](../design-system.md)
2. Experiment with VIA components in a test page
3. Build a simple feature (e.g., About page)
4. Review VIA components code in `lib/core/widgets/via/`

**Resources**:
- VIA Design System: [docs/design-system.md](../design-system.md)
- Flutter layouts: https://docs.flutter.dev/development/ui/layout

### Week 4: Feature Development

**Goals**:
- Understand feature module structure
- Build a complete feature
- Write tests

**Tasks**:
1. Choose a simple feature to implement
2. Create feature structure (pages/controllers/widgets)
3. Connect to existing providers
4. Write unit tests
5. Submit your first PR!

**Resources**:
- [CONTRIBUTING.md](../../CONTRIBUTING.md)
- Feature examples: `lib/features/`

---

## Understanding the Codebase

### Project Structure

```
lib/
├── main.dart                   # App entry point
├── app.dart                    # Root widget
├── core/                       # Shared code
│   ├── services/              # Repositories, API
│   ├── widgets/               # Reusable widgets
│   ├── theme/                 # Design tokens
│   └── utils/                 # Helper functions
├── domain/                     # Business logic
│   └── models/                # Data models
├── features/                   # Feature modules
│   ├── auth/                  # Login, onboarding
│   ├── fleet/                 # Live map
│   ├── vehicles/              # Cart management
│   ├── service/               # Work orders
│   ├── alerts/                # Alerts
│   ├── analytics/             # KPIs
│   └── settings/              # Settings
└── router/                     # Navigation
```

### Feature Module Pattern

Each feature follows this structure:

```
features/my_feature/
├── pages/                      # Screens
│   └── my_feature_page.dart
├── controllers/                # Business logic
│   └── my_feature_controller.dart
├── widgets/                    # Feature-specific UI
│   └── my_widget.dart
└── state/                     # State models
    └── my_feature_state.dart
```

**Example**: Cart Inventory feature
```
features/vehicles/
├── pages/
│   └── cart_inventory_list.dart          # List screen
├── controllers/
│   └── cart_inventory_controller.dart    # State + logic
├── widgets/
│   └── cart_card.dart                    # Cart card widget
```

### Data Flow

1. **UI** calls controller method
2. **Controller** fetches data from repository
3. **Repository** calls API/Mock API
4. **Data** flows back through controller to UI
5. **UI** rebuilds with new data

```
ViaButton → Controller.refresh() → Repository.getCarts() → MockApi → UI update
```

---

## Key Concepts

### 1. State Management with Riverpod

**Provider**: Declares a piece of state

```dart
@riverpod
class CartInventory extends _$CartInventory {
  @override
  Future<List<Cart>> build() async {
    // Initialize state
    return ref.watch(cartRepositoryProvider).getCarts();
  }

  Future<void> refresh() async {
    // Update state
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(cartRepositoryProvider).getCarts();
    });
  }
}
```

**Consumer**: Watches state in UI

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartInventoryProvider);

    return state.when(
      data: (carts) => ListView(children: [...]),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
```

### 2. Immutable Models with Freezed

**Define model**:

```dart
@freezed
class Cart with _$Cart {
  const factory Cart({
    required String id,
    required String modelName,
    required CartStatus status,
    required double batteryLevel,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) =>
      _$CartFromJson(json);
}
```

**Use model**:

```dart
// Create
final cart = Cart(
  id: 'GCA-001',
  modelName: 'APRO G4',
  status: CartStatus.active,
  batteryLevel: 85.0,
);

// Copy with changes
final updatedCart = cart.copyWith(batteryLevel: 80.0);

// Models are immutable - this won't work:
// cart.batteryLevel = 80.0; // ERROR!
```

### 3. Navigation with GoRouter

**Define routes**:

```dart
GoRoute(
  path: '/vehicles/inventory',
  builder: (context, state) => CartInventoryList(),
),
```

**Navigate**:

```dart
// Go to route
context.go('/vehicles/inventory');

// Go with parameters
context.go('/vehicles/cart/${cart.id}');

// Go back
context.pop();
```

### 4. VIA Components

**Always use VIA components**:

```dart
// ✅ GOOD
ViaButton.primary(
  text: 'Submit',
  onPressed: () {},
)

// ❌ BAD
ElevatedButton(
  onPressed: () {},
  child: Text('Submit'),
)
```

---

## Common Patterns

### Pattern 1: Loading Data

```dart
@riverpod
class MyFeature extends _$MyFeature {
  @override
  Future<List<MyData>> build() async {
    return _loadData();
  }

  Future<List<MyData>> _loadData() async {
    return ref.read(myRepositoryProvider).getData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadData);
  }
}
```

### Pattern 2: Displaying Data

```dart
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myFeatureProvider);

    return Scaffold(
      body: state.when(
        data: (data) => _buildDataView(data),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err'),
        ),
      ),
    );
  }

  Widget _buildDataView(List<MyData> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return MyDataCard(data: data[index]);
      },
    );
  }
}
```

### Pattern 3: Showing Toasts

```dart
ViaButton.primary(
  text: 'Save',
  onPressed: () async {
    try {
      await ref.read(myControllerProvider.notifier).save();

      if (context.mounted) {
        ViaToast.show(
          context: context,
          message: 'Saved successfully',
          variant: ViaToastVariant.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ViaToast.show(
          context: context,
          message: 'Save failed: $e',
          variant: ViaToastVariant.error,
        );
      }
    }
  },
)
```

### Pattern 4: Building Forms

```dart
final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();

ViaCard(
  child: Form(
    key: _formKey,
    child: Column(
      children: [
        ViaInput(
          label: 'Name',
          controller: _nameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name is required';
            }
            return null;
          },
        ),
        SizedBox(height: ViaDesignTokens.spacingLg),
        ViaButton.primary(
          text: 'Submit',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Form is valid
              _submit();
            }
          },
        ),
      ],
    ),
  ),
)
```

---

## Your First Tasks

### Task 1: Fix a Typo (Easy)

1. Find a text string in the UI
2. Locate it in the code
3. Fix the typo
4. Test the change with hot reload
5. Commit: `fix(ui): Correct typo in cart inventory`

### Task 2: Change a Color (Easy)

1. Find a hardcoded color in a widget
2. Replace it with a VIA design token
3. Test the change
4. Commit: `refactor(ui): Use VIA design token for cart status`

### Task 3: Add a New Button (Medium)

1. Choose a page that needs a new button
2. Add `ViaButton` component
3. Wire up the `onPressed` handler
4. Show a toast on button press
5. Test and commit: `feat(vehicles): Add export button to cart inventory`

### Task 4: Build a Simple Page (Medium)

1. Create `lib/features/about/pages/about_page.dart`
2. Use `ViaCard` to display app info
3. Add navigation route in `router/app_router.dart`
4. Add a button in Settings to navigate to About
5. Test and commit: `feat(settings): Add About page`

### Task 5: Write a Unit Test (Medium)

1. Choose a simple utility function
2. Create test file in `test/`
3. Write test cases
4. Run `flutter test`
5. Commit: `test(utils): Add tests for date formatter`

---

## Best Practices

### Code Style

**Do**:
- Use meaningful variable names
- Keep functions small (< 50 lines)
- Add comments for complex logic
- Use VIA components
- Use design tokens

**Don't**:
- Hardcode colors or spacing
- Use Material widgets
- Write long functions
- Ignore linter warnings

### State Management

**Do**:
- Use providers for shared state
- Use `.select()` for granular rebuilds
- Cancel subscriptions in `dispose()`
- Handle loading/error states

**Don't**:
- Store state in widgets
- Watch entire providers unnecessarily
- Forget error handling

### UI Development

**Do**:
- Use VIA components consistently
- Follow design system guidelines
- Test on multiple screen sizes
- Provide loading indicators
- Show error messages

**Don't**:
- Mix Material and VIA components
- Hardcode sizes or colors
- Skip accessibility considerations
- Ignore edge cases

### Testing

**Do**:
- Write tests for business logic
- Test error cases
- Use descriptive test names
- Run tests before committing

**Don't**:
- Skip tests
- Test implementation details
- Write flaky tests

---

## Getting Help

### Resources

1. **Documentation**:
   - [README.md](../../README.md)
   - [GETTING_STARTED.md](../../GETTING_STARTED.md)
   - [CONTRIBUTING.md](../../CONTRIBUTING.md)
   - [docs/design-system.md](../design-system.md)

2. **Code Examples**:
   - Existing features in `lib/features/`
   - VIA components in `lib/core/widgets/via/`

3. **External Docs**:
   - Flutter: https://docs.flutter.dev/
   - Riverpod: https://riverpod.dev/
   - Dart: https://dart.dev/

### When You're Stuck

1. **Read the error message** carefully
2. **Search the codebase** for similar patterns
3. **Check existing tests** for examples
4. **Google the error** (likely someone else had it)
5. **Ask a teammate** - we're here to help!

### Questions to Ask

**Good questions**:
- "How does the cart filtering logic work?"
- "Why do we use Riverpod instead of Provider?"
- "What's the best way to add a new feature?"

**Questions to research first**:
- "What is Flutter?" (check docs)
- "How do I install Flutter?" (check GETTING_STARTED.md)
- "What does this error mean?" (google it first)

---

## Your Growth Path

### Junior Developer (Months 1-3)

**Focus**: Learn the codebase and patterns

**Goals**:
- Complete small bug fixes
- Build simple features
- Understand state management
- Write basic tests

### Mid-Level Developer (Months 4-6)

**Focus**: Build features independently

**Goals**:
- Design and implement features
- Refactor existing code
- Write comprehensive tests
- Review others' code

### Senior Developer (Months 7+)

**Focus**: Architecture and mentorship

**Goals**:
- Design system architecture
- Optimize performance
- Mentor junior developers
- Drive technical decisions

---

## Final Tips

1. **Don't be afraid to ask questions** - Everyone was a beginner once
2. **Take your time** - Understanding is more important than speed
3. **Experiment** - Try things in a test project
4. **Read code** - Learn from existing implementations
5. **Write clean code** - Future you will thank you
6. **Test your changes** - Catch bugs early
7. **Commit often** - Small commits are easier to review
8. **Have fun!** - Enjoy learning and building

---

**Welcome to the team! We're excited to have you here.** 🚀

For more resources, see:
- [GETTING_STARTED.md](../../GETTING_STARTED.md)
- [CONTRIBUTING.md](../../CONTRIBUTING.md)
- [docs/design-system.md](../design-system.md)
