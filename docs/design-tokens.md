# Design Tokens - Monochrome Design System

This document defines the design system tokens used throughout the AproFleet Manager App, updated with a refined monochrome aesthetic inspired by professional administrative interfaces.

## Design Principles

### Monochrome-First Approach
- **Primary**: Pure black (#000000) and white (#FFFFFF) with alpha variants
- **Depth**: Dark grays (#0A0A0A, #1A1A1A) for visual hierarchy
- **Status Colors**: Vibrant colors (red/orange/blue/green) only for critical information
- **Everything else**: Grayscale with subtle borders and minimal shadows

### Typography Hierarchy
- **Tight Tracking**: Reduced letter spacing (0-0.5) for professional look
- **Bold Contrasts**: Strong font weight differences (400/600/700)
- **Compact Spacing**: Tighter padding and margins throughout

### Visual Elements
- **Sharper Corners**: Reduced border radius (2-8px vs previous 4-16px)
- **Subtle Borders**: More transparent borders (0.04-0.08 alpha vs 0.06-0.12)
- **Minimal Shadows**: Prefer flat design with reduced elevation
- **Compact Layout**: Tighter spacing for professional density

## Color Palette

### Background Colors
```dart
class AppColors {
  // Primary backgrounds
  static const Color primaryBackground = Color(0xFF000000);      // Pure black
  static const Color secondaryBackground = Color(0xFF0A0A0A);   // Dark gray
  static const Color surfaceBackground = Color(0xFF1A1A1A);     // Card background
  
  // Border colors - More subtle for monochrome design
  static const Color borderPrimary = Color(0x0AFFFFFF);         // 4% opacity white
  static const Color borderSecondary = Color(0x14FFFFFF);      // 8% opacity white
  static const Color borderAccent = Color(0x1FFFFFFF);         // 12% opacity white
}
```

### Priority Colors
```dart
class PriorityColors {
  static const Color p1 = Color(0xFFEF4444);  // Red - Critical/Emergency
  static const Color p2 = Color(0xFFF97316);  // Orange - High Priority
  static const Color p3 = Color(0xFF3B82F6);   // Blue - Medium Priority
  static const Color p4 = Color(0xFF22C55E);   // Green - Low Priority
}
```

### Alert Severity Colors
```dart
class AlertColors {
  static const Color critical = Color(0xFFEF4444);  // Red
  static const Color warning = Color(0xFFF97316);   // Orange
  static const Color info = Color(0xFF3B82F6);     // Blue
  static const Color success = Color(0xFF22C55E);  // Green
}
```

### Status Colors
```dart
class StatusColors {
  static const Color active = Color(0xFF22C55E);      // Green
  static const Color idle = Color(0xFF6B7280);        // Gray
  static const Color charging = Color(0xFF3B82F6);    // Blue
  static const Color maintenance = Color(0xFFF97316); // Orange
  static const Color offline = Color(0xFFEF4444);     // Red
}
```

### Text Colors
```dart
class TextColors {
  static const Color primary = Color(0xFFFFFFFF);     // White
  static const Color secondary = Color(0xB3FFFFFF);   // 70% opacity white
  static const Color tertiary = Color(0x66FFFFFF);    // 40% opacity white
  static const Color disabled = Color(0x33FFFFFF);    // 20% opacity white
}
```

## Typography

### Font Family
- **Primary**: SF Pro Display (iOS) / Roboto (Android)
- **Monospace**: SF Mono (iOS) / Roboto Mono (Android)

### Font Weights
```dart
class FontWeights {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight heavy = FontWeight.w800;
}
```

### Text Styles
```dart
class AppTextStyles {
  // Headers
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: Colors.white,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    color: Colors.white,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: Colors.white,
  );
  
  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: Colors.white,
  );
  
  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
  
  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: Colors.white,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: Colors.white,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: Colors.white,
  );
  
  // KPI/Numeric
  static const TextStyle kpiLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFeatures: [FontFeature.tabularFigures()],
    color: Colors.white,
  );
  
  static const TextStyle kpiMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
    color: Colors.white,
  );
  
  static const TextStyle kpiSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
    color: Colors.white,
  );
}
```

## Spacing Scale

### Base Unit
- **Base**: 4px
- **Scale**: 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 80, 96

### Spacing Tokens
```dart
class AppSpacing {
  static const double xs = 4.0;    // 0.25rem
  static const double sm = 8.0;    // 0.5rem
  static const double md = 12.0;   // 0.75rem
  static const double lg = 16.0;   // 1rem
  static const double xl = 20.0;   // 1.25rem
  static const double xxl = 24.0;  // 1.5rem
  static const double xxxl = 32.0; // 2rem
  static const double huge = 40.0; // 2.5rem
  static const double massive = 48.0; // 3rem
  static const double giant = 64.0;  // 4rem
  static const double enormous = 80.0; // 5rem
  static const double colossal = 96.0; // 6rem
}
```

### Component Spacing
```dart
class ComponentSpacing {
  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets cardPaddingSmall = EdgeInsets.all(12);
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(20);
  
  // Button padding
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const EdgeInsets buttonPaddingSmall = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const EdgeInsets buttonPaddingLarge = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  
  // List item spacing
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const EdgeInsets listItemPaddingDense = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  
  // Section spacing
  static const EdgeInsets sectionPadding = EdgeInsets.all(20);
  static const EdgeInsets sectionPaddingSmall = EdgeInsets.all(16);
  static const EdgeInsets sectionPaddingLarge = EdgeInsets.all(24);
}
```

## Border Radius

### Border Radius Tokens - Sharper Corners
```dart
class AppBorderRadius {
  static const double none = 0.0;
  static const double xs = 2.0;    // Sharper corners
  static const double sm = 4.0;
  static const double md = 6.0;
  static const double lg = 8.0;
  static const double xl = 12.0;
  static const double xxl = 16.0;
  static const double full = 9999.0;
}
```

### Component Border Radius
```dart
class ComponentBorderRadius {
  // Cards - Sharper corners
  static const BorderRadius card = BorderRadius.all(Radius.circular(8));
  static const BorderRadius cardSmall = BorderRadius.all(Radius.circular(6));
  static const BorderRadius cardLarge = BorderRadius.all(Radius.circular(12));
  
  // Buttons - Sharper corners
  static const BorderRadius button = BorderRadius.all(Radius.circular(6));
  static const BorderRadius buttonSmall = BorderRadius.all(Radius.circular(4));
  static const BorderRadius buttonLarge = BorderRadius.all(Radius.circular(8));
  
  // Input fields - Sharper corners
  static const BorderRadius input = BorderRadius.all(Radius.circular(6));
  static const BorderRadius inputSmall = BorderRadius.all(Radius.circular(4));
  
  // Chips/Badges
  static const BorderRadius chip = BorderRadius.all(Radius.circular(16));
  static const BorderRadius badge = BorderRadius.all(Radius.circular(12));
}
```

## Elevation & Shadows

### Shadow Tokens
```dart
class AppShadows {
  static const BoxShadow z1 = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  );
  
  static const BoxShadow z2 = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  );
  
  static const BoxShadow z3 = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 12,
    offset: Offset(0, 6),
  );
  
  static const BoxShadow z4 = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 16,
    offset: Offset(0, 8),
  );
}
```

### Component Shadows
```dart
class ComponentShadows {
  // Cards
  static const List<BoxShadow> card = [AppShadows.z1];
  static const List<BoxShadow> cardHover = [AppShadows.z2];
  static const List<BoxShadow> cardActive = [AppShadows.z3];
  
  // Modals
  static const List<BoxShadow> modal = [AppShadows.z4];
  
  // Buttons
  static const List<BoxShadow> button = [AppShadows.z1];
  static const List<BoxShadow> buttonHover = [AppShadows.z2];
}
```

## Icon Sizes

### Icon Size Tokens
```dart
class AppIconSizes {
  static const double xs = 12.0;
  static const double sm = 16.0;
  static const double md = 20.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
  static const double xxxl = 48.0;
  static const double huge = 64.0;
}
```

### Component Icon Sizes
```dart
class ComponentIconSizes {
  // Navigation
  static const double navIcon = 24.0;
  static const double navIconSmall = 20.0;
  
  // Buttons
  static const double buttonIcon = 20.0;
  static const double buttonIconSmall = 16.0;
  static const double buttonIconLarge = 24.0;
  
  // Cards
  static const double cardIcon = 24.0;
  static const double cardIconSmall = 20.0;
  
  // Status indicators
  static const double statusIcon = 16.0;
  static const double statusIconSmall = 12.0;
}
```

## Animation Durations

### Duration Tokens
```dart
class AppDurations {
  static const Duration instant = Duration(milliseconds: 0);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 750);
  static const Duration slowest = Duration(milliseconds: 1000);
}
```

### Animation Curves
```dart
class AppCurves {
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;
}
```

## Breakpoints

### Screen Breakpoints
```dart
class AppBreakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double wide = 1440;
}
```

### Responsive Utilities
```dart
class ResponsiveUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppBreakpoints.mobile;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppBreakpoints.mobile && width < AppBreakpoints.tablet;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppBreakpoints.desktop;
  }
}
```

## Usage Examples

### Card Component
```dart
Container(
  padding: ComponentSpacing.cardPadding,
  decoration: BoxDecoration(
    color: AppColors.surfaceBackground,
    borderRadius: ComponentBorderRadius.card,
    border: Border.all(
      color: AppColors.borderPrimary,
      width: 1,
    ),
    boxShadow: ComponentShadows.card,
  ),
  child: Text(
    'Card Content',
    style: AppTextStyles.bodyMedium,
  ),
)
```

### Button Component
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: PriorityColors.p1,
    foregroundColor: Colors.white,
    padding: ComponentSpacing.buttonPadding,
    shape: RoundedRectangleBorder(
      borderRadius: ComponentBorderRadius.button,
    ),
    elevation: 0,
  ),
  onPressed: () {},
  child: Text(
    'EMERGENCY STOP',
    style: AppTextStyles.labelLarge,
  ),
)
```

### Status Chip
```dart
Container(
  padding: EdgeInsets.symmetric(
    horizontal: AppSpacing.sm,
    vertical: AppSpacing.xs,
  ),
  decoration: BoxDecoration(
    color: StatusColors.active.withOpacity(0.2),
    borderRadius: ComponentBorderRadius.chip,
    border: Border.all(
      color: StatusColors.active.withOpacity(0.5),
      width: 1,
    ),
  ),
  child: Text(
    'ACTIVE',
    style: AppTextStyles.labelSmall.copyWith(
      color: StatusColors.active,
    ),
  ),
)
```