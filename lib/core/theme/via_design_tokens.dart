import 'dart:ui';
import 'package:flutter/material.dart';

/// VIA Design System Tokens for AproFleet Golf Cart Manager
///
/// This design token system aligns with the VIA design language used across
/// CraneEyes and Golf Cart Admin System, ensuring visual consistency while
/// maintaining the unique functionality of the golf cart fleet management system.
///
/// Key Design Principles:
/// - Dark theme with high-contrast surfaces
/// - Subtle glassmorphism and light diffusion
/// - Pretendard Variable typography
/// - OLED-optimized with soft elevation shadows
/// - Professional, modern, and functional
class ViaDesignTokens {
  // Private constructor to prevent instantiation
  ViaDesignTokens._();

  // ============================================================================
  // COLOR SYSTEM - VIA Palette
  // ============================================================================

  /// Primary color - Active/Connected state
  /// Used for: Active carts, success states, primary actions
  static const Color primary = Color(0xFF00C97B);

  /// Secondary color - Charging/Info state
  /// Used for: Charging carts, informational elements
  static const Color secondary = Color(0xFF3B83CC);

  /// Warning color - Attention needed
  /// Used for: Warning states, medium priority alerts
  static const Color warning = Color(0xFFD67500);

  /// Critical color - Urgent attention required
  /// Used for: Critical alerts, emergency actions, high priority
  static const Color critical = Color(0xFFC23D3D);

  // Surface Colors
  /// Primary surface - Pure black (OLED friendly)
  static const Color surfacePrimary = Color(0xFF0F0F0F);

  /// Secondary surface - Slightly elevated
  static const Color surfaceSecondary = Color(0xFF181818);

  /// Tertiary surface - Card backgrounds
  static const Color surfaceTertiary = Color(0xFF1E1E1E);

  /// Quaternary surface - Elevated elements
  static const Color surfaceQuaternary = Color(0xFF242424);

  // Border Colors (standardized opacity)
  /// Primary border - Subtle dividers
  static Color borderPrimary = Colors.white.withValues(alpha: 0.08);

  /// Secondary border - More visible borders
  static Color borderSecondary = Colors.white.withValues(alpha: 0.12);

  /// Tertiary border - Emphasized borders
  static Color borderTertiary = Colors.white.withValues(alpha: 0.16);

  /// Accent border - Highlighted borders
  static Color borderAccent = Colors.white.withValues(alpha: 0.24);

  // Text Colors
  /// Primary text - Highest contrast
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Secondary text - Standard content
  static Color textSecondary = Colors.white.withValues(alpha: 0.87);

  /// Muted text - Supporting information
  static const Color textMuted = Color(0xFF8A8A8A);

  /// Subtle text - Least prominent
  static const Color textSubtle = Color(0xFF6B7280);

  /// Disabled text
  static Color textDisabled = Colors.white.withValues(alpha: 0.38);

  // ============================================================================
  // STATUS COLORS - Golf Cart States
  // ============================================================================

  /// Active cart status
  static const Color statusActive = primary; // #00C97B

  /// Idle cart status
  static const Color statusIdle = Color(0xFFFFAA00); // Orange

  /// Charging cart status
  static const Color statusCharging = secondary; // #3B83CC

  /// Maintenance cart status
  static const Color statusMaintenance = warning; // #D67500

  /// Offline cart status
  static const Color statusOffline = Color(0xFF666666); // Gray

  // ============================================================================
  // PRIORITY COLORS - Work Order & Alert Priority
  // ============================================================================

  /// P1 - Critical priority
  static const Color priorityP1 = critical; // #C23D3D

  /// P2 - High priority
  static const Color priorityP2 = warning; // #D67500

  /// P3 - Normal priority
  static const Color priorityP3 = secondary; // #3B83CC

  /// P4 - Low priority
  static const Color priorityP4 = primary; // #00C97B

  // ============================================================================
  // ALERT SEVERITY COLORS
  // ============================================================================

  /// Critical alert severity
  static const Color alertCritical = critical; // #C23D3D

  /// Warning alert severity
  static const Color alertWarning = warning; // #D67500

  /// Info alert severity
  static const Color alertInfo = secondary; // #3B83CC

  /// Success alert severity
  static const Color alertSuccess = primary; // #00C97B

  // ============================================================================
  // TYPOGRAPHY SYSTEM - Pretendard Variable
  // ============================================================================

  /// Primary font family
  static const String fontFamily = 'Pretendard Variable';

  /// Fallback font family
  static const String fontFamilyFallback = 'SF Pro Display';

  // Font Sizes - VIA Scale (11, 13, 15, 17, 20, 24)
  static const double fontSizeXxs = 11.0;
  static const double fontSizeXs = 13.0;
  static const double fontSizeSm = 15.0;
  static const double fontSizeMd = 17.0;
  static const double fontSizeLg = 20.0;
  static const double fontSizeXl = 24.0;
  static const double fontSize2xl = 32.0;
  static const double fontSize3xl = 40.0;

  // Font Weights - Variable font supports 100-900
  static const FontWeight fontWeightThin = FontWeight.w100;
  static const FontWeight fontWeightExtraLight = FontWeight.w200;
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemibold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;
  static const FontWeight fontWeightBlack = FontWeight.w900;

  // Line Heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;

  // Letter Spacing - Precision alignment
  static const double letterSpacingTight = -0.02;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.02;
  static const double letterSpacingExtraWide = 0.05;

  // ============================================================================
  // SPACING SYSTEM - 4px Base Unit
  // ============================================================================

  static const double spacingXxs = 2.0;
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 20.0;
  static const double spacing2xl = 24.0;
  static const double spacing3xl = 32.0;
  static const double spacing4xl = 40.0;
  static const double spacing5xl = 48.0;
  static const double spacing6xl = 64.0;
  static const double spacing7xl = 80.0;
  static const double spacing8xl = 96.0;

  // ============================================================================
  // BORDER RADIUS
  // ============================================================================

  static const double radiusNone = 0.0;
  static const double radiusXs = 2.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 6.0;
  static const double radiusLg = 8.0;
  static const double radiusXl = 12.0;
  static const double radius2xl = 16.0;
  static const double radius3xl = 20.0;
  static const double radiusFull = 9999.0;

  // ============================================================================
  // ELEVATION & SHADOWS - OLED Optimized
  // ============================================================================

  static const double elevationNone = 0.0;
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;
  static const double elevation2xl = 24.0;

  /// Soft elevation shadow for cards
  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  /// Medium elevation shadow
  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  /// Large elevation shadow
  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  /// Extra large elevation shadow
  static List<BoxShadow> get shadowXl => [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];

  // ============================================================================
  // ICON SIZES
  // ============================================================================

  static const double iconXxs = 12.0;
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 28.0;
  static const double iconXl = 32.0;
  static const double icon2xl = 40.0;
  static const double icon3xl = 48.0;

  // Icon stroke width for custom icons
  static const double iconStrokeWidth = 2.0;

  // ============================================================================
  // ANIMATION SYSTEM
  // ============================================================================

  // Durations
  static const Duration durationInstant = Duration(milliseconds: 0);
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationSlower = Duration(milliseconds: 700);

  // Curves - VIA Standard
  /// Standard easing curve for most animations
  static const Curve curveStandard = Curves.easeInOut;

  /// Deceleration curve for enter animations
  static const Curve curveDeceleration = Curves.easeOut;

  /// Acceleration curve for exit animations
  static const Curve curveAcceleration = Curves.easeIn;

  /// Sharp curve for instant transitions
  static const Curve curveSharp = Curves.linear;

  /// Custom cubic bezier matching VIA spec
  static const Curve curveVia = Cubic(0.4, 0.0, 0.2, 1.0);

  // ============================================================================
  // BREAKPOINTS - Responsive Design
  // ============================================================================

  static const double breakpointXs = 320.0;
  static const double breakpointSm = 640.0;
  static const double breakpointMd = 768.0;
  static const double breakpointLg = 1024.0;
  static const double breakpointXl = 1280.0;
  static const double breakpoint2xl = 1536.0;

  // ============================================================================
  // OPACITY LEVELS
  // ============================================================================

  static const double opacityDisabled = 0.38;
  static const double opacityMuted = 0.60;
  static const double opacitySubtle = 0.87;
  static const double opacityFull = 1.0;

  // Glassmorphism opacity
  static const double glassOpacityLight = 0.05;
  static const double glassOpacityMedium = 0.10;
  static const double glassOpacityStrong = 0.15;

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get status color by cart status string
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return statusActive;
      case 'idle':
        return statusIdle;
      case 'charging':
        return statusCharging;
      case 'maintenance':
        return statusMaintenance;
      case 'offline':
        return statusOffline;
      default:
        return statusOffline;
    }
  }

  /// Get priority color by priority string
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'p1':
      case 'critical':
        return priorityP1;
      case 'p2':
      case 'high':
        return priorityP2;
      case 'p3':
      case 'normal':
      case 'medium':
        return priorityP3;
      case 'p4':
      case 'low':
        return priorityP4;
      default:
        return priorityP3;
    }
  }

  /// Get alert severity color
  static Color getAlertSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return alertCritical;
      case 'warning':
        return alertWarning;
      case 'info':
        return alertInfo;
      case 'success':
        return alertSuccess;
      default:
        return alertInfo;
    }
  }

  // ============================================================================
  // GLASSMORPHISM EFFECTS
  // ============================================================================

  /// Glass decoration with backdrop blur effect
  ///
  /// Use sparingly for performance - limit to 3-4 visible elements
  static BoxDecoration getGlassDecoration({
    double blur = 10.0,
    double opacity = glassOpacityMedium,
    Color? backgroundColor,
    Color? borderColor,
    double borderRadius = radiusLg,
    double borderWidth = 1.0,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? Colors.white.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? borderPrimary,
        width: borderWidth,
      ),
    );
  }

  /// Glass panel with subtle gradient
  static BoxDecoration getGlassPanelDecoration({
    double opacity = glassOpacityMedium,
    double borderRadius = radiusLg,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderPrimary,
        width: 1.0,
      ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: opacity),
          Colors.white.withValues(alpha: opacity * 0.5),
        ],
      ),
    );
  }

  // ============================================================================
  // CARD DECORATIONS
  // ============================================================================

  /// Standard card decoration
  static BoxDecoration getCardDecoration({
    Color? backgroundColor,
    Color? borderColor,
    double borderRadius = radiusLg,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? surfaceTertiary,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? borderPrimary,
        width: 1.0,
      ),
      boxShadow: shadows,
    );
  }

  /// Elevated card with soft shadow
  static BoxDecoration getElevatedCardDecoration({
    Color? backgroundColor,
    Color? borderColor,
    double borderRadius = radiusLg,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? surfaceTertiary,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? borderPrimary,
        width: 1.0,
      ),
      boxShadow: shadowMd,
    );
  }

  // ============================================================================
  // BUTTON DECORATIONS
  // ============================================================================

  /// Primary button decoration
  static BoxDecoration getPrimaryButtonDecoration({
    Color? backgroundColor,
    double borderRadius = radiusMd,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? primary,
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  /// Secondary button decoration
  static BoxDecoration getSecondaryButtonDecoration({
    Color? borderColor,
    double borderRadius = radiusMd,
  }) {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? primary,
        width: 1.5,
      ),
    );
  }

  /// Danger button decoration
  static BoxDecoration getDangerButtonDecoration({
    double borderRadius = radiusMd,
  }) {
    return BoxDecoration(
      color: critical,
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }

  // ============================================================================
  // INPUT DECORATIONS
  // ============================================================================

  /// Glass-style input decoration
  static InputDecoration getInputDecoration({
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: surfaceSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: BorderSide(
          color: borderPrimary,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: BorderSide(
          color: borderPrimary,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(
          color: primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(
          color: critical,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingLg,
        vertical: spacingMd,
      ),
    );
  }

  // ============================================================================
  // TEXT STYLES
  // ============================================================================

  /// Display text style (largest)
  static TextStyle get displayLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize3xl,
        fontWeight: fontWeightBold,
        letterSpacing: letterSpacingTight,
        height: lineHeightTight,
        color: textPrimary,
      );

  /// Display medium
  static TextStyle get displayMedium => const TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize2xl,
        fontWeight: fontWeightBold,
        letterSpacing: letterSpacingTight,
        height: lineHeightTight,
        color: textPrimary,
      );

  /// Display small
  static TextStyle get displaySmall => const TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSizeXl,
        fontWeight: fontWeightSemibold,
        letterSpacing: letterSpacingNormal,
        height: lineHeightNormal,
        color: textPrimary,
      );

  /// Heading large
  static TextStyle get headingLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSizeLg,
        fontWeight: fontWeightSemibold,
        letterSpacing: letterSpacingNormal,
        height: lineHeightNormal,
        color: textPrimary,
      );

  /// Heading medium
  static TextStyle get headingMedium => const TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSizeMd,
        fontWeight: fontWeightSemibold,
        letterSpacing: letterSpacingNormal,
        height: lineHeightNormal,
        color: textPrimary,
      );

  /// Heading small
  static TextStyle get headingSmall => const TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSizeSm,
        fontWeight: fontWeightSemibold,
        letterSpacing: letterSpacingNormal,
        height: lineHeightNormal,
        color: textPrimary,
      );

  /// Body large
  static TextStyle get bodyLarge => TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSizeMd,
        fontWeight: fontWeightNormal,
        letterSpacing: letterSpacingNormal,
        height: lineHeightNormal,
        color: textSecondary,
      );

  /// Body medium
  static TextStyle get bodyMedium => TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSizeSm,
        fontWeight: fontWeightNormal,
        letterSpacing: letterSpacingNormal,
        height: lineHeightNormal,
        color: textSecondary,
      );

  /// Body small
  static TextStyle get bodySmall => const TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSizeXs,
        fontWeight: fontWeightNormal,
        letterSpacing: letterSpacingNormal,
        height: lineHeightNormal,
        color: textMuted,
      );

  /// Label large
  static TextStyle get labelLarge => const TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSizeSm,
        fontWeight: fontWeightSemibold,
        letterSpacing: letterSpacingWide,
        height: lineHeightNormal,
        color: textPrimary,
      );

  /// Label medium
  static TextStyle get labelMedium => const TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSizeXs,
        fontWeight: fontWeightSemibold,
        letterSpacing: letterSpacingWide,
        height: lineHeightNormal,
        color: textPrimary,
      );

  /// Label small
  static TextStyle get labelSmall => const TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSizeXxs,
        fontWeight: fontWeightSemibold,
        letterSpacing: letterSpacingWide,
        height: lineHeightNormal,
        color: textMuted,
      );

  // ============================================================================
  // SPECIAL EFFECTS
  // ============================================================================

  /// Glow effect for active elements
  static List<BoxShadow> getGlowEffect(Color color, {double opacity = 0.5}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: 12,
        spreadRadius: 2,
      ),
    ];
  }

  /// Pulse animation glow (for critical alerts)
  static List<BoxShadow> getPulseGlow(Color color) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.6),
        blurRadius: 16,
        spreadRadius: 4,
      ),
    ];
  }
}
