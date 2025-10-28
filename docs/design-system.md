# VIA Design System Documentation

**Version**: 0.2.0
**Theme**: Industrial Dark with Glassmorphism
**Philosophy**: Monochrome elegance with functional clarity

---

## Table of Contents

- [Overview](#overview)
- [Design Principles](#design-principles)
- [Design Tokens](#design-tokens)
- [Typography](#typography)
- [Components](#components)
- [Usage Guidelines](#usage-guidelines)
- [Migration from Material](#migration-from-material)

---

## Overview

The VIA Design System is a comprehensive UI framework designed for enterprise fleet management applications. It combines:

- **Industrial Dark Theme**: Professional, low-light optimized interface
- **Glassmorphism**: Elegant depth through transparency and blur effects
- **Monochrome Palette**: Focus on content with strategic color accents
- **Outdoor Visibility**: High contrast for sunlight readability

### Core Values

1. **Clarity**: Information is immediately understandable
2. **Consistency**: Predictable patterns across the app
3. **Performance**: Smooth animations and responsive interactions
4. **Accessibility**: WCAG 2.1 AA compliance with minimum touch targets

---

## Design Principles

### 1. Industrial Dark Aesthetic

- **Background**: Pure black (#000000) for OLED optimization
- **Surfaces**: Dark gray with subtle transparency
- **Depth**: Achieved through outlines, not shadows
- **Contrast**: High contrast for outdoor readability

### 2. Glassmorphism

- **Blur Effects**: `BackdropFilter` with 10-20px blur
- **Transparency**: 5-15% opacity for layering
- **Borders**: 4-12% white opacity for elegant definition
- **No Heavy Shadows**: Glassmorphic depth replaces traditional elevation

### 3. Functional Color

- **Monochrome Base**: White text on black backgrounds
- **Status Colors**: Semantic colors (green=active, red=critical)
- **VIA Green**: #00C97B as primary brand accent
- **Priority System**: P1-P4 with distinct color coding

### 4. Typography Hierarchy

- **Primary Font**: Pretendard Variable (Korean-optimized)
- **Fallback**: SF Pro Display
- **Scale**: 10px - 32px (7 sizes)
- **Weight**: 400-700 (regular, medium, semibold, bold)

---

## Design Tokens

### Color Palette

#### Brand Colors
```dart
static const Color accentPrimary = Color(0xFF00C97B);  // VIA Green
static const Color accentSecondary = Color(0xFF0099CC); // Accent Blue
```

#### Background Colors
```dart
static const Color bgBase = Color(0xFF000000);         // Pure black
static const Color bgSurface = Color(0xFF0A0A0A);      // Surface (5% white)
static const Color bgElevated = Color(0xFF141414);     // Elevated (8% white)
```

#### Text Colors
```dart
static const Color textPrimary = Color(0xFFFFFFFF);    // White
static const Color textSecondary = Color(0xFFB3B3B3);  // Gray 70%
static const Color textTertiary = Color(0xFF666666);   // Gray 40%
```

#### Status Colors
```dart
static const Color statusActive = Color(0xFF00C97B);    // Green
static const Color statusIdle = Color(0xFFFFAA00);      // Orange
static const Color statusCharging = Color(0xFF3B83CC);  // Blue
static const Color statusMaintenance = Color(0xFFD67500); // Dark Orange
static const Color statusOffline = Color(0xFF666666);   // Gray
```

#### Priority Colors
```dart
static const Color priorityP1 = Color(0xFFC23D3D);  // Critical - Red
static const Color priorityP2 = Color(0xFFD67500);  // High - Dark Orange
static const Color priorityP3 = Color(0xFF3B83CC);  // Medium - Blue
static const Color priorityP4 = Color(0xFF00C97B);  // Low - Green
```

#### Alert Colors
```dart
static const Color alertCritical = Color(0xFFC23D3D);  // Red
static const Color alertWarning = Color(0xFFFFAA00);   // Orange
static const Color alertInfo = Color(0xFF3B83CC);      // Blue
static const Color alertSuccess = Color(0xFF00C97B);   // Green
```

### Spacing Scale

```dart
static const double spacingXxs = 2.0;
static const double spacingXs = 4.0;
static const double spacingSm = 8.0;
static const double spacingMd = 12.0;
static const double spacingLg = 16.0;
static const double spacingXl = 20.0;
static const double spacing2xl = 24.0;
static const double spacing3xl = 32.0;
```

**Usage**: Always use spacing constants, never hardcoded values.

### Border Radius

```dart
static const double radiusSm = 6.0;
static const double radiusMd = 12.0;
static const double radiusLg = 16.0;
static const double radiusXl = 20.0;
static const double radiusFull = 9999.0;  // Circular
```

### Border Width

```dart
static const double borderWidth = 2.0;      // Standard borders
static const double borderWidthThin = 1.0;  // Subtle borders
```

### Animation Duration

```dart
static const Duration animationFast = Duration(milliseconds: 150);
static const Duration animationNormal = Duration(milliseconds: 300);
static const Duration animationSlow = Duration(milliseconds: 500);
```

---

## Typography

### Font Families

#### Primary: Pretendard Variable
- **File**: `assets/fonts/PretendardVariable.ttf`
- **Weights**: 100-900 (variable)
- **Optimized**: Korean characters with excellent Latin support
- **Features**: Clean, modern, professional

#### Fallback: SF Pro Display
- **Files**: Regular, Medium, Bold
- **Usage**: When Pretendard unavailable
- **Platform**: iOS native font

### Text Styles

```dart
// Headings
static const headingLarge = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w700,
  height: 1.2,
  letterSpacing: -0.5,
);

static const headingMedium = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  height: 1.3,
  letterSpacing: -0.3,
);

static const headingSmall = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  height: 1.4,
);

// Body Text
static const bodyLarge = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

static const bodyMedium = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

static const bodySmall = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  height: 1.4,
);

// Labels
static const labelLarge = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

static const labelMedium = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
);

static const labelSmall = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.5,
);
```

---

## Components

### ViaButton

Primary interactive component with 4 variants and 3 sizes.

#### Variants

1. **Primary**: Main CTA actions
2. **Secondary**: Secondary actions
3. **Ghost**: Tertiary actions, less emphasis
4. **Danger**: Destructive actions

#### Sizes

- **Small**: Compact UI, lists
- **Medium**: Standard buttons
- **Large**: Hero actions, CTAs

#### Usage

```dart
// Primary button
ViaButton.primary(
  text: 'Create Work Order',
  onPressed: () {
    // Action
  },
  size: ViaButtonSize.medium,
  icon: Icons.add,
  enableHaptic: true,
)

// Secondary button
ViaButton.secondary(
  text: 'Cancel',
  onPressed: () {},
)

// Ghost button
ViaButton.ghost(
  text: 'Learn More',
  onPressed: () {},
)

// Danger button
ViaButton.danger(
  text: 'Delete',
  onPressed: () {},
  size: ViaButtonSize.small,
)

// Loading state
ViaButton.primary(
  text: 'Submitting...',
  onPressed: () {},
  isLoading: true,
)

// Disabled state
ViaButton.primary(
  text: 'Submit',
  onPressed: null,  // null = disabled
)
```

#### API

```dart
ViaButton.primary({
  required String text,
  required VoidCallback? onPressed,
  ViaButtonSize size = ViaButtonSize.medium,
  IconData? icon,
  bool isLoading = false,
  bool enableHaptic = true,
  bool fullWidth = false,
})
```

---

### ViaCard

Glassmorphic container with blur effects.

#### Usage

```dart
ViaCard(
  child: Column(
    children: [
      Text('Cart ID: GCA-001'),
      Text('Status: Active'),
    ],
  ),
  padding: EdgeInsets.all(ViaDesignTokens.spacingLg),
  onTap: () {
    // Optional tap handler
  },
)

// Without padding
ViaCard.noPadding(
  child: Image.network('https://...'),
)

// Custom styling
ViaCard(
  backgroundColor: ViaDesignTokens.bgElevated,
  borderColor: ViaDesignTokens.accentPrimary.withOpacity(0.3),
  child: Text('Custom card'),
)
```

#### API

```dart
ViaCard({
  required Widget child,
  EdgeInsetsGeometry? padding,
  Color? backgroundColor,
  Color? borderColor,
  double? borderRadius,
  VoidCallback? onTap,
})
```

---

### ViaToast

Temporary notifications with slide animations.

#### Variants

1. **Success**: Green, checkmark icon
2. **Error**: Red, error icon
3. **Warning**: Orange, warning icon
4. **Info**: Blue, info icon

#### Usage

```dart
// Success toast
ViaToast.show(
  context: context,
  message: 'Work order created successfully',
  variant: ViaToastVariant.success,
  duration: Duration(seconds: 3),
);

// Error toast
ViaToast.show(
  context: context,
  message: 'Failed to save changes',
  variant: ViaToastVariant.error,
);

// Warning toast
ViaToast.show(
  context: context,
  message: 'Battery level critical',
  variant: ViaToastVariant.warning,
);

// Info toast
ViaToast.show(
  context: context,
  message: 'New alert received',
  variant: ViaToastVariant.info,
  action: ViaToastAction(
    label: 'View',
    onPressed: () {
      // Navigate to alert
    },
  ),
);
```

#### API

```dart
ViaToast.show({
  required BuildContext context,
  required String message,
  required ViaToastVariant variant,
  Duration duration = const Duration(seconds: 3),
  ViaToastAction? action,
})
```

---

### ViaBottomSheet

Draggable modal bottom sheet with snap points.

#### Usage

```dart
// Show bottom sheet
ViaBottomSheet.show(
  context: context,
  title: 'Filter Options',
  child: Column(
    children: [
      ListTile(title: Text('All Carts')),
      ListTile(title: Text('Active Only')),
      ListTile(title: Text('Idle Only')),
    ],
  ),
  onDismiss: () {
    print('Sheet dismissed');
  },
);

// With primary action
ViaBottomSheet.show(
  context: context,
  title: 'Confirm Action',
  child: Text('Are you sure you want to delete this work order?'),
  primaryAction: ViaButton.danger(
    text: 'Delete',
    onPressed: () {
      // Delete action
      Navigator.pop(context);
    },
  ),
  secondaryAction: ViaButton.ghost(
    text: 'Cancel',
    onPressed: () {
      Navigator.pop(context);
    },
  ),
);

// Scrollable content
ViaBottomSheet.show(
  context: context,
  title: 'Work Order Details',
  child: SingleChildScrollView(
    child: Column(
      children: [
        // Long content...
      ],
    ),
  ),
  initialChildSize: 0.5,
  maxChildSize: 0.9,
);
```

#### API

```dart
ViaBottomSheet.show({
  required BuildContext context,
  required String title,
  required Widget child,
  Widget? primaryAction,
  Widget? secondaryAction,
  VoidCallback? onDismiss,
  double initialChildSize = 0.6,
  double minChildSize = 0.3,
  double maxChildSize = 0.9,
  bool isDismissible = true,
})
```

---

### ViaInput

Text input field with validation.

#### Usage

```dart
ViaInput(
  label: 'Cart ID',
  placeholder: 'Enter cart ID',
  controller: _cartIdController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Cart ID is required';
    }
    return null;
  },
  onChanged: (value) {
    print('Input: $value');
  },
)

// With icon
ViaInput(
  label: 'Search',
  placeholder: 'Search carts...',
  prefixIcon: Icons.search,
  controller: _searchController,
)

// Password field
ViaInput(
  label: 'Password',
  placeholder: 'Enter password',
  obscureText: true,
  controller: _passwordController,
)

// Multiline
ViaInput(
  label: 'Notes',
  placeholder: 'Enter notes',
  maxLines: 5,
  controller: _notesController,
)

// Error state
ViaInput(
  label: 'Email',
  placeholder: 'Enter email',
  controller: _emailController,
  errorText: 'Invalid email format',
)
```

#### API

```dart
ViaInput({
  required String label,
  String? placeholder,
  TextEditingController? controller,
  String? Function(String?)? validator,
  ValueChanged<String>? onChanged,
  IconData? prefixIcon,
  IconData? suffixIcon,
  bool obscureText = false,
  int maxLines = 1,
  TextInputType keyboardType = TextInputType.text,
  String? errorText,
  bool enabled = true,
})
```

---

### ViaStatusBadge

Status indicator badges with color coding.

#### Usage

```dart
// Cart status
ViaStatusBadge(
  label: 'Active',
  status: CartStatus.active,
)

ViaStatusBadge(
  label: 'Idle',
  status: CartStatus.idle,
)

ViaStatusBadge(
  label: 'Charging',
  status: CartStatus.charging,
)

ViaStatusBadge(
  label: 'Maintenance',
  status: CartStatus.maintenance,
)

ViaStatusBadge(
  label: 'Offline',
  status: CartStatus.offline,
)

// Custom status
ViaStatusBadge.custom(
  label: 'Custom',
  color: ViaDesignTokens.accentPrimary,
)
```

#### API

```dart
ViaStatusBadge({
  required String label,
  required CartStatus status,
  ViaStatusBadgeSize size = ViaStatusBadgeSize.medium,
})

ViaStatusBadge.custom({
  required String label,
  required Color color,
  ViaStatusBadgeSize size = ViaStatusBadgeSize.medium,
})
```

---

### ViaPriorityBadge

Priority badges for work orders and alerts (P1-P4).

#### Usage

```dart
// P1 - Critical
ViaPriorityBadge(priority: WorkOrderPriority.p1)

// P2 - High
ViaPriorityBadge(priority: WorkOrderPriority.p2)

// P3 - Medium
ViaPriorityBadge(priority: WorkOrderPriority.p3)

// P4 - Low
ViaPriorityBadge(priority: WorkOrderPriority.p4)

// Small size
ViaPriorityBadge(
  priority: WorkOrderPriority.p1,
  size: ViaPriorityBadgeSize.small,
)
```

#### API

```dart
ViaPriorityBadge({
  required WorkOrderPriority priority,
  ViaPriorityBadgeSize size = ViaPriorityBadgeSize.medium,
})
```

---

### ViaStatChip

Interactive stat chip for filtering and data visualization.

#### Usage

```dart
ViaStatChip(
  label: 'Critical',
  count: 3,
  color: ViaDesignTokens.alertCritical,
  isActive: true,
  onTap: () {
    // Filter by critical
  },
)

ViaStatChip(
  label: 'Active',
  count: 24,
  color: ViaDesignTokens.statusActive,
  isActive: false,
  onTap: () {
    // Filter by active
  },
)

// Small size
ViaStatChip(
  label: 'Pending',
  count: 5,
  color: ViaDesignTokens.alertWarning,
  size: ViaStatChipSize.small,
)
```

#### API

```dart
ViaStatChip({
  required String label,
  required int count,
  required Color color,
  bool isActive = false,
  VoidCallback? onTap,
  ViaStatChipSize size = ViaStatChipSize.medium,
})
```

---

### ViaControlBar

Advanced filtering and sorting control bar.

#### Usage

```dart
ViaControlBar(
  stats: [
    ViaStatData(
      label: 'Critical',
      count: 3,
      color: ViaDesignTokens.alertCritical,
      isActive: selectedFilter == 'critical',
    ),
    ViaStatData(
      label: 'Warning',
      count: 5,
      color: ViaDesignTokens.alertWarning,
      isActive: selectedFilter == 'warning',
    ),
  ],
  filterOptions: [
    ViaFilterOption(label: 'All', value: 'all'),
    ViaFilterOption(label: 'Unread', value: 'unread'),
    ViaFilterOption(label: 'Critical', value: 'critical'),
  ],
  sortOptions: [
    ViaSortOption(label: 'Newest', value: 'newest'),
    ViaSortOption(label: 'Oldest', value: 'oldest'),
    ViaSortOption(label: 'Priority', value: 'priority'),
  ],
  currentFilter: 'all',
  currentSort: 'newest',
  onFilterChanged: (filter) {
    setState(() => selectedFilter = filter);
  },
  onSortChanged: (sort) {
    setState(() => selectedSort = sort);
  },
  onStatTapped: (statId) {
    // Handle stat chip tap
  },
)
```

#### API

```dart
ViaControlBar({
  required List<ViaStatData> stats,
  required List<ViaFilterOption> filterOptions,
  required List<ViaSortOption> sortOptions,
  required String currentFilter,
  required String currentSort,
  required ValueChanged<String> onFilterChanged,
  required ValueChanged<String> onSortChanged,
  ValueChanged<String>? onStatTapped,
  List<ViaViewMode>? viewModes,
  String? currentViewMode,
  ValueChanged<String>? onViewModeChanged,
  bool showSearch = false,
  ValueChanged<String>? onSearch,
})
```

---

## Usage Guidelines

### Do's

✅ **Always use VIA components** instead of Material widgets

✅ **Use design tokens** for all colors, spacing, and sizing

✅ **Follow naming conventions**: `ViaComponentName`

✅ **Enable haptic feedback** for interactive components

✅ **Use proper text styles** from ViaDesignTokens

✅ **Test on physical devices** for outdoor visibility

✅ **Provide loading and error states** for all async operations

### Don'ts

❌ **Never use Material widgets** (ElevatedButton, Card, etc.)

❌ **Never hardcode colors** (use design tokens)

❌ **Never hardcode spacing** (use spacing scale)

❌ **Never skip accessibility** (minimum 48x48 touch targets)

❌ **Never use heavy shadows** (use glassmorphic effects)

❌ **Never ignore haptic feedback** for interactive elements

---

## Migration from Material

### Button Migration

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

### Card Migration

```dart
// Old (Material)
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Content'),
  ),
)

// New (VIA)
ViaCard(
  padding: EdgeInsets.all(ViaDesignTokens.spacingLg),
  child: Text('Content'),
)
```

### SnackBar Migration

```dart
// Old (Material)
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Success')),
);

// New (VIA)
ViaToast.show(
  context: context,
  message: 'Success',
  variant: ViaToastVariant.success,
);
```

### AlertDialog Migration

```dart
// Old (Material)
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Confirm'),
    content: Text('Are you sure?'),
    actions: [
      TextButton(child: Text('Cancel'), onPressed: () {}),
      TextButton(child: Text('OK'), onPressed: () {}),
    ],
  ),
);

// New (VIA)
ViaBottomSheet.show(
  context: context,
  title: 'Confirm',
  child: Text('Are you sure?'),
  primaryAction: ViaButton.primary(text: 'OK', onPressed: () {}),
  secondaryAction: ViaButton.ghost(text: 'Cancel', onPressed: () {}),
);
```

### TextField Migration

```dart
// Old (Material)
TextField(
  decoration: InputDecoration(
    labelText: 'Name',
    hintText: 'Enter name',
  ),
  controller: controller,
)

// New (VIA)
ViaInput(
  label: 'Name',
  placeholder: 'Enter name',
  controller: controller,
)
```

---

## Resources

- **Component Library**: `lib/core/widgets/via/`
- **Design Tokens**: `lib/core/theme/via_design_tokens.dart`
- **Migration Status**: `VIA_DESIGN_SYSTEM_STATUS.md`
- **Phase Plan**: `PHASE4_PLAN.md`

---

**For questions or suggestions**, open an issue or discussion on GitHub.

---

**VIA Design System** - Industrial Dark Elegance for Enterprise Fleet Management
