import 'package:flutter/material.dart';

/// Industrial Dark UI System Design Tokens
///
/// Professional-grade design language optimized for outdoor field operations.
/// Built for clarity, precision, and readability under sunlight.
///
/// Design Motto: "Control in Clarity — 현장에서 즉시 인식되는 정교함"
///
/// Key Principles:
/// - Dark gray backgrounds (not pure black) to reduce glare
/// - Outline-based depth (no shadows)
/// - Single accent color for focus
/// - High contrast text (85% / 60% opacity)
/// - Structural clarity over decoration
class IndustrialDarkTokens {
  // Private constructor to prevent instantiation
  IndustrialDarkTokens._();

  // ========================================================================
  // BACKGROUNDS
  // ========================================================================

  /// Main scaffold background - Dark gray, not pure black
  /// Used for: Full-screen base tone
  static const Color bgBase = Color(0xFF1A1A1A);

  /// Elevated surface background
  /// Used for: Cards, sheets, panels
  static const Color bgSurface = Color(0xFF222222);

  /// Map overlay to prevent glare and separate data layer
  static const Color bgOverlay = Color(0x40000000); // rgba(0,0,0,0.25)

  // ========================================================================
  // BORDERS & OUTLINES (replacing shadows)
  // ========================================================================

  /// Primary structural outline
  /// Used for: Card borders, dividers, panel separation
  static const Color outline = Color(0xFF3A3A3A);

  /// Emphasized outline for focus/hover states
  static const Color outlineEmphasis = Color(0xFF505050);

  /// Subtle divider for less important separations
  static const Color outlineSoft = Color(0xFF2A2A2A);

  // ========================================================================
  // TEXT
  // ========================================================================

  /// Primary text - High visibility
  /// Opacity: 85% (0.85)
  /// Used for: Main headings, body text, important labels
  static const Color textPrimary = Color(0xD9FFFFFF); // rgba(255,255,255,0.85)

  /// Secondary text - Supporting information
  /// Opacity: 60% (0.6)
  /// Used for: Metadata, timestamps, secondary labels
  static const Color textSecondary = Color(0x99FFFFFF); // rgba(255,255,255,0.6)

  /// Disabled text - Inactive elements
  /// Opacity: 30% (0.3)
  /// Used for: Disabled buttons, inactive items
  static const Color textDisabled = Color(0x4DFFFFFF); // rgba(255,255,255,0.3)

  // ========================================================================
  // ACCENT & ACTIONS (The ONLY colored accent in the system)
  // ========================================================================

  /// Primary accent color - The single colored element
  /// Used for: Primary buttons, active states, focus indicators, links
  static const Color accentPrimary = Color(0xFF0072E5);

  /// Hover/pressed state of accent
  static const Color accentHover = Color(0xFF005BB5);

  /// Disabled accent state
  static const Color accentDisabled = Color(0x4D0072E5); // 30% opacity

  // ========================================================================
  // FUNCTIONAL STATES (use sparingly, only when necessary)
  // ========================================================================

  /// Error/emergency state - Use only for critical alerts
  static const Color error = Color(0xFFE84545);

  /// Warning/caution state - Use sparingly
  static const Color warning = Color(0xFFFFC107);

  /// Success/confirmation state - Use for positive feedback
  static const Color success = Color(0xFF4CAF50);

  // Legacy status colors (for cart status indicators)
  static const Color statusActive = Color(0xFF4CAF50);
  static const Color statusIdle = Color(0xFFFFC107);
  static const Color statusCharging = Color(0xFF0072E5);
  static const Color statusMaintenance = Color(0xFFE84545);
  static const Color statusOffline = Color(0xFF666666);

  // Priority colors (for work order priority)
  static const Color priorityP1 = Color(0xFFE84545); // Critical
  static const Color priorityP2 = Color(0xFFFFC107); // High
  static const Color priorityP3 = Color(0xFF0072E5); // Normal
  static const Color priorityP4 = Color(0xFF4CAF50); // Low

  // ========================================================================
  // TYPOGRAPHY
  // ========================================================================

  /// Display/Heading font size
  static const double fontSizeDisplay = 24.0;

  /// Body text font size
  static const double fontSizeBody = 16.0;

  /// Label/Caption font size
  static const double fontSizeLabel = 14.0;

  /// Small text font size
  static const double fontSizeSmall = 12.0;

  /// Monospace data display (telemetry, metrics)
  static const double fontSizeData = 18.0;

  // Font weights
  static const FontWeight fontWeightBold = FontWeight.w600;    // Semibold
  static const FontWeight fontWeightMedium = FontWeight.w500;  // Medium
  static const FontWeight fontWeightRegular = FontWeight.w400; // Regular

  /// Line height for outdoor legibility
  static const double lineHeight = 1.4;

  /// Letter spacing for improved contrast
  static const double letterSpacing = 0.2;

  /// Text styles
  static const TextStyle displayStyle = TextStyle(
    fontSize: fontSizeDisplay,
    fontWeight: fontWeightBold,
    color: textPrimary,
    height: lineHeight,
    letterSpacing: letterSpacing,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: fontSizeBody,
    fontWeight: fontWeightRegular,
    color: textPrimary,
    height: lineHeight,
    letterSpacing: letterSpacing,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: fontSizeLabel,
    fontWeight: fontWeightMedium,
    color: textSecondary,
    height: lineHeight,
    letterSpacing: letterSpacing,
  );

  static const TextStyle dataStyle = TextStyle(
    fontSize: fontSizeData,
    fontWeight: fontWeightMedium,
    fontFamily: 'RobotoMono', // Monospace for data
    color: textPrimary,
    height: lineHeight,
  );

  // ========================================================================
  // SPACING
  // ========================================================================

  /// Section spacing (between major sections)
  static const double spacingSection = 24.0;

  /// Card padding
  static const double spacingCard = 16.0;

  /// Item spacing (between list items, components)
  static const double spacingItem = 12.0;

  /// Compact spacing (tight layouts)
  static const double spacingCompact = 8.0;

  /// Minimal spacing
  static const double spacingMinimal = 4.0;

  // ========================================================================
  // BORDER RADIUS
  // ========================================================================

  /// Unified card radius
  static const double radiusCard = 12.0;

  /// Button radius
  static const double radiusButton = 8.0;

  /// Chip/pill radius (fully rounded)
  static const double radiusChip = 20.0;

  /// Small radius for compact elements
  static const double radiusSmall = 4.0;

  // ========================================================================
  // BORDERS
  // ========================================================================

  /// Structural outline width (primary)
  static const double borderWidth = 2.0;

  /// Thin divider width (subtle separations)
  static const double borderWidthThin = 1.0;

  // ========================================================================
  // ELEVATION (DEPRECATED - Use outlines instead)
  // ========================================================================

  /// All elevation values are 0 in Industrial Dark
  /// Depth is expressed through outlines and tone differences
  static const double elevationNone = 0.0;

  // ========================================================================
  // ANIMATION & MOTION
  // ========================================================================

  /// Standard animation duration (fast)
  static const Duration durationFast = Duration(milliseconds: 120);

  /// Medium animation duration
  static const Duration durationMedium = Duration(milliseconds: 200);

  /// Animation curve (no overshoot or bounce)
  static const Curve curveStandard = Curves.easeOut;

  // ========================================================================
  // TOUCH TARGETS (for field usability)
  // ========================================================================

  /// Minimum touch target size (accessibility + glove touch)
  static const double touchTargetMin = 48.0;

  /// List item height range
  static const double listItemMinHeight = 60.0;
  static const double listItemMaxHeight = 72.0;

  /// Minimum horizontal spacing between touch targets
  static const double touchSpacingMin = 8.0;

  // ========================================================================
  // HELPER METHODS
  // ========================================================================

  /// Apply opacity to white color
  static Color withOpacity(double opacity) {
    return Color.fromRGBO(255, 255, 255, opacity);
  }

  /// Create border with standard outline
  static BoxBorder border({Color? color, double? width}) {
    return Border.all(
      color: color ?? outline,
      width: width ?? borderWidth,
    );
  }

  /// Create thin border for subtle dividers
  static BoxBorder borderThin({Color? color}) {
    return Border.all(
      color: color ?? outline,
      width: borderWidthThin,
    );
  }

  /// Create card decoration with Industrial Dark style
  static BoxDecoration cardDecoration({
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    double? radius,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? bgSurface,
      borderRadius: BorderRadius.circular(radius ?? radiusCard),
      border: Border.all(
        color: borderColor ?? outline,
        width: borderWidth ?? IndustrialDarkTokens.borderWidth,
      ),
      // No boxShadow - depth through outlines only
    );
  }

  /// Create button decoration with Industrial Dark style
  static BoxDecoration buttonDecoration({
    required bool isPrimary,
    Color? customColor,
    double? radius,
  }) {
    return BoxDecoration(
      color: isPrimary
          ? (customColor ?? accentPrimary)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(radius ?? radiusButton),
      border: isPrimary
          ? null
          : Border.all(
              color: customColor ?? outline,
              width: borderWidth,
            ),
      // No boxShadow
    );
  }

  /// Get text style with custom color
  static TextStyle textStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? fontSizeBody,
      fontWeight: fontWeight ?? fontWeightRegular,
      color: color ?? textPrimary,
      height: lineHeight,
      letterSpacing: letterSpacing,
    );
  }
}
