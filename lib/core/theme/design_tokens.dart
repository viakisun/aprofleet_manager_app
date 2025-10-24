import 'package:flutter/material.dart';

/// Design tokens for consistent UI styling across the AproFleet Manager App
/// Based on reference HTML designs with dark monochrome theme
class DesignTokens {
  // Private constructor to prevent instantiation
  DesignTokens._();

  // ============================================================================
  // COLORS
  // ============================================================================

  /// Primary background color - Pure black
  static const Color bgPrimary = Color(0xFF000000);

  /// Secondary background color - Very dark gray
  static const Color bgSecondary = Color(0xFF0A0A0A);

  /// Tertiary background color - Dark gray for cards
  static const Color bgTertiary = Color(0xFF1A1A1A);

  /// Quaternary background color - Slightly lighter for elevated surfaces
  static const Color bgQuaternary = Color(0xFF2A2A2A);

  // Border Colors - More subtle for monochrome design
  static Color borderPrimary = Colors.white.withValues(alpha: 0.04);
  static Color borderSecondary = Colors.white.withValues(alpha: 0.08);
  static Color borderTertiary = Colors.white.withValues(alpha: 0.12);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static Color textSecondary = Colors.white.withValues(alpha: 0.7);
  static Color textTertiary = Colors.white.withValues(alpha: 0.4);
  static Color textDisabled = Colors.white.withValues(alpha: 0.2);

  // ============================================================================
  // STATUS COLORS
  // ============================================================================

  /// Active status - Bright green
  static const Color statusActive = Color(0xFF00FF00);

  /// Idle status - Orange
  static const Color statusIdle = Color(0xFFFFAA00);

  /// Charging status - Blue
  static const Color statusCharging = Color(0xFF0088FF);

  /// Maintenance status - Red
  static const Color statusMaintenance = Color(0xFFFF4444);

  /// Offline status - Gray
  static const Color statusOffline = Color(0xFF666666);

  /// Warning status - Orange (alias for statusIdle)
  static const Color statusWarning = Color(0xFFFFAA00);

  /// Critical status - Red (alias for statusMaintenance)
  static const Color statusCritical = Color(0xFFFF4444);

  // ============================================================================
  // PRIORITY COLORS
  // ============================================================================

  /// Priority P1 (Critical) - Red
  static const Color priorityP1 = Color(0xFFFF4444);

  /// Priority P2 (High) - Orange
  static const Color priorityP2 = Color(0xFFFFAA00);

  /// Priority P3 (Normal) - Blue
  static const Color priorityP3 = Color(0xFF0088FF);

  /// Priority P4 (Low) - Green
  static const Color priorityP4 = Color(0xFF00FF00);

  // ============================================================================
  // ALERT SEVERITY COLORS
  // ============================================================================

  /// Critical alerts - Red
  static const Color alertCritical = Color(0xFFFF4444);

  /// Warning alerts - Orange
  static const Color alertWarning = Color(0xFFFFAA00);

  /// Info alerts - Blue
  static const Color alertInfo = Color(0xFF0088FF);

  // ============================================================================
  // ALERT METHODS
  // ============================================================================

  /// Get alert color based on severity
  static Color getAlertColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return alertCritical;
      case 'warning':
        return alertWarning;
      case 'info':
        return alertInfo;
      default:
        return alertInfo;
    }
  }

  // ============================================================================

  /// Success alerts - Green
  static const Color alertSuccess = Color(0xFF00FF00);

  // ============================================================================
  // SPACING SYSTEM
  // ============================================================================

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2xl = 48.0;
  static const double spacing3xl = 64.0;

  // ============================================================================
  // BORDER RADIUS
  // ============================================================================

  // Border Radius - Sharper corners for monochrome design
  static const double radiusXs = 2.0;
  static const double radiusSm = 4.0;
  static const double radiusMd = 6.0;
  static const double radiusLg = 8.0;
  static const double radiusXl = 12.0;
  static const double radius2xl = 16.0;

  // ============================================================================
  // TYPOGRAPHY
  // ============================================================================

  static const String fontFamily = 'SF Pro Display';
  static const String fontFamilyFallback = 'Segoe UI';

  // Font Sizes
  static const double fontSizeXs = 10.0;
  static const double fontSizeSm = 12.0;
  static const double fontSizeMd = 14.0;
  static const double fontSizeLg = 16.0;
  static const double fontSizeXl = 18.0;
  static const double fontSize2xl = 24.0;
  static const double fontSize3xl = 32.0;
  static const double fontSize4xl = 40.0;

  // Font Weights
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemibold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Line Heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.6;

  // Letter Spacing - Tighter tracking for professional look
  static const double letterSpacingTight = 0.0;
  static const double letterSpacingNormal = 0.2;
  static const double letterSpacingWide = 0.5;

  // ============================================================================
  // ELEVATION & SHADOWS
  // ============================================================================

  static const double elevationNone = 0.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;

  // ============================================================================
  // ICON SIZES
  // ============================================================================

  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;
  static const double icon2xl = 48.0;

  // ============================================================================
  // ANIMATION DURATIONS
  // ============================================================================

  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ============================================================================
  // BREAKPOINTS
  // ============================================================================

  static const double breakpointSm = 640.0;
  static const double breakpointMd = 768.0;
  static const double breakpointLg = 1024.0;
  static const double breakpointXl = 1280.0;
  static const double breakpoint2xl = 1536.0;

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get status color for cart status
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

  /// Get priority color for work order priority
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

  /// Get text style for uppercase labels
  static TextStyle getUppercaseLabelStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize ?? fontSizeSm,
      fontWeight: fontWeight ?? fontWeightMedium,
      color: color ?? textSecondary,
      letterSpacing: letterSpacingWide,
      height: lineHeightNormal,
    );
  }

  /// Get card decoration with minimal styling
  static BoxDecoration getCardDecoration({
    Color? backgroundColor,
    double? borderRadius,
    Color? borderColor,
    double? elevation,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? bgTertiary,
      borderRadius: BorderRadius.circular(borderRadius ?? radiusLg),
      border: Border.all(
        color: borderColor ?? borderPrimary,
        width: 1.0,
      ),
      // Minimal shadows - prefer flat design
      boxShadow: elevation != null && elevation > 0
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: elevation,
                offset: Offset(0, elevation / 2),
              ),
            ]
          : null,
    );
  }

  /// Get gradient for map background
  static LinearGradient getMapGradient() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF0A1F0A), // Dark green
        Color(0xFF061506), // Very dark green
      ],
    );
  }

  /// Get glass morphism effect decoration
  static BoxDecoration getGlassMorphismDecoration({
    double? borderRadius,
    double? opacity,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius ?? radiusMd),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.1),
        width: 1.0,
      ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: opacity ?? 0.05),
          Colors.white.withValues(alpha: (opacity ?? 0.05) * 0.5),
        ],
      ),
    );
  }

  /// Get icon background square decoration (CraneEyes style)
  static BoxDecoration getIconBackgroundDecoration({
    double? size,
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? bgPrimary,
      borderRadius: BorderRadius.circular(radiusXs),
    );
  }

  /// Get button decoration with minimal styling
  static BoxDecoration getButtonDecoration({
    Color? backgroundColor,
    double? borderRadius,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? bgPrimary,
      borderRadius: BorderRadius.circular(borderRadius ?? radiusMd),
      border: borderColor != null
          ? Border.all(color: borderColor, width: 1.0)
          : null,
    );
  }
}
