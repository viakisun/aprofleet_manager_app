import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/industrial_dark_tokens.dart';

/// Industrial Dark UI System Theme
///
/// Professional-grade theme for outdoor field operations at golf courses.
/// Optimized for sunlight readability, glove touch, and operational clarity.
///
/// Key Features:
/// - Outline-based depth (NO shadows/elevation)
/// - Single accent color (#0072E5)
/// - High contrast text (85% / 60% opacity)
/// - Dark gray backgrounds (not pure black)
/// - Structural clarity over decoration
class IndustrialDarkTheme {
  // Private constructor to prevent instantiation
  IndustrialDarkTheme._();

  /// Main dark theme using Industrial Dark design tokens
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // ========================================================================
      // COLOR SCHEME
      // ========================================================================
      colorScheme: ColorScheme.dark(
        primary: IndustrialDarkTokens.accentPrimary,
        secondary: IndustrialDarkTokens.accentPrimary,
        surface: IndustrialDarkTokens.bgSurface,
        error: IndustrialDarkTokens.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: IndustrialDarkTokens.textPrimary,
        onError: Colors.white,
        outline: IndustrialDarkTokens.outline,
      ),

      // ========================================================================
      // BASE COLORS
      // ========================================================================
      primaryColor: IndustrialDarkTokens.accentPrimary,
      scaffoldBackgroundColor: IndustrialDarkTokens.bgBase,
      canvasColor: IndustrialDarkTokens.bgBase,
      cardColor: IndustrialDarkTokens.bgSurface,
      dividerColor: IndustrialDarkTokens.outline,

      // ========================================================================
      // APP BAR THEME
      // ========================================================================
      appBarTheme: AppBarTheme(
        backgroundColor: IndustrialDarkTokens.bgBase,
        foregroundColor: IndustrialDarkTokens.textPrimary,
        elevation: 0, // No elevation - outline only
        centerTitle: true,
        titleTextStyle: IndustrialDarkTokens.displayStyle,
        iconTheme: const IconThemeData(
          color: IndustrialDarkTokens.textPrimary,
          size: 24,
        ),
        shape: Border(
          bottom: BorderSide(
            color: IndustrialDarkTokens.outline,
            width: IndustrialDarkTokens.borderWidth,
          ),
        ),
      ),

      // ========================================================================
      // BOTTOM NAVIGATION BAR THEME
      // ========================================================================
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: IndustrialDarkTokens.bgBase,
        selectedItemColor: IndustrialDarkTokens.accentPrimary,
        unselectedItemColor: IndustrialDarkTokens.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: IndustrialDarkTokens.labelStyle,
        unselectedLabelStyle: IndustrialDarkTokens.labelStyle,
      ),

      // ========================================================================
      // CARD THEME
      // ========================================================================
      cardTheme: CardThemeData(
        color: IndustrialDarkTokens.bgSurface,
        elevation: 0, // No elevation - use borders
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusCard),
          side: BorderSide(
            color: IndustrialDarkTokens.outline,
            width: IndustrialDarkTokens.borderWidth,
          ),
        ),
        margin: const EdgeInsets.all(0),
      ),

      // ========================================================================
      // TEXT THEME
      // ========================================================================
      textTheme: const TextTheme(
        // Display styles
        displayLarge: TextStyle(
          fontSize: IndustrialDarkTokens.fontSizeDisplay,
          fontWeight: IndustrialDarkTokens.fontWeightBold,
          color: IndustrialDarkTokens.textPrimary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),
        displayMedium: TextStyle(
          fontSize: 22,
          fontWeight: IndustrialDarkTokens.fontWeightBold,
          color: IndustrialDarkTokens.textPrimary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: IndustrialDarkTokens.fontWeightBold,
          color: IndustrialDarkTokens.textPrimary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),

        // Heading styles
        headlineLarge: TextStyle(
          fontSize: IndustrialDarkTokens.fontSizeDisplay,
          fontWeight: IndustrialDarkTokens.fontWeightBold,
          color: IndustrialDarkTokens.textPrimary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: IndustrialDarkTokens.fontWeightBold,
          color: IndustrialDarkTokens.textPrimary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: IndustrialDarkTokens.fontWeightMedium,
          color: IndustrialDarkTokens.textPrimary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),

        // Title styles
        titleLarge: TextStyle(
          fontSize: IndustrialDarkTokens.fontSizeBody,
          fontWeight: IndustrialDarkTokens.fontWeightMedium,
          color: IndustrialDarkTokens.textPrimary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),
        titleMedium: TextStyle(
          fontSize: IndustrialDarkTokens.fontSizeLabel,
          fontWeight: IndustrialDarkTokens.fontWeightMedium,
          color: IndustrialDarkTokens.textPrimary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),
        titleSmall: TextStyle(
          fontSize: IndustrialDarkTokens.fontSizeSmall,
          fontWeight: IndustrialDarkTokens.fontWeightMedium,
          color: IndustrialDarkTokens.textPrimary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),

        // Body styles
        bodyLarge: TextStyle(
          fontSize: IndustrialDarkTokens.fontSizeBody,
          fontWeight: IndustrialDarkTokens.fontWeightRegular,
          color: IndustrialDarkTokens.textPrimary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),
        bodyMedium: TextStyle(
          fontSize: IndustrialDarkTokens.fontSizeLabel,
          fontWeight: IndustrialDarkTokens.fontWeightRegular,
          color: IndustrialDarkTokens.textPrimary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),
        bodySmall: TextStyle(
          fontSize: IndustrialDarkTokens.fontSizeSmall,
          fontWeight: IndustrialDarkTokens.fontWeightRegular,
          color: IndustrialDarkTokens.textSecondary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),

        // Label styles
        labelLarge: TextStyle(
          fontSize: IndustrialDarkTokens.fontSizeLabel,
          fontWeight: IndustrialDarkTokens.fontWeightMedium,
          color: IndustrialDarkTokens.textPrimary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),
        labelMedium: TextStyle(
          fontSize: IndustrialDarkTokens.fontSizeSmall,
          fontWeight: IndustrialDarkTokens.fontWeightMedium,
          color: IndustrialDarkTokens.textSecondary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: IndustrialDarkTokens.fontWeightMedium,
          color: IndustrialDarkTokens.textSecondary,
          height: IndustrialDarkTokens.lineHeight,
          letterSpacing: IndustrialDarkTokens.letterSpacing,
        ),
      ),

      // ========================================================================
      // INPUT DECORATION THEME
      // ========================================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: IndustrialDarkTokens.bgSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          borderSide: BorderSide(
            color: IndustrialDarkTokens.outline,
            width: IndustrialDarkTokens.borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          borderSide: BorderSide(
            color: IndustrialDarkTokens.outline,
            width: IndustrialDarkTokens.borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          borderSide: BorderSide(
            color: IndustrialDarkTokens.accentPrimary,
            width: IndustrialDarkTokens.borderWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          borderSide: BorderSide(
            color: IndustrialDarkTokens.error,
            width: IndustrialDarkTokens.borderWidth,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          borderSide: BorderSide(
            color: IndustrialDarkTokens.error,
            width: IndustrialDarkTokens.borderWidth,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: IndustrialDarkTokens.spacingCard,
          vertical: IndustrialDarkTokens.spacingItem,
        ),
        hintStyle: IndustrialDarkTokens.labelStyle,
        labelStyle: IndustrialDarkTokens.labelStyle,
        floatingLabelStyle: TextStyle(
          fontSize: IndustrialDarkTokens.fontSizeSmall,
          color: IndustrialDarkTokens.accentPrimary,
        ),
      ),

      // ========================================================================
      // BUTTON THEMES
      // ========================================================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: IndustrialDarkTokens.accentPrimary,
          foregroundColor: Colors.white,
          elevation: 0, // No elevation
          padding: const EdgeInsets.symmetric(
            horizontal: IndustrialDarkTokens.spacingSection,
            vertical: IndustrialDarkTokens.spacingItem,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          ),
          textStyle: const TextStyle(
            fontSize: IndustrialDarkTokens.fontSizeBody,
            fontWeight: IndustrialDarkTokens.fontWeightMedium,
            letterSpacing: IndustrialDarkTokens.letterSpacing,
          ),
          minimumSize: const Size(IndustrialDarkTokens.touchTargetMin, IndustrialDarkTokens.touchTargetMin),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: IndustrialDarkTokens.textPrimary,
          side: BorderSide(
            color: IndustrialDarkTokens.outline,
            width: IndustrialDarkTokens.borderWidth,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: IndustrialDarkTokens.spacingSection,
            vertical: IndustrialDarkTokens.spacingItem,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          ),
          textStyle: const TextStyle(
            fontSize: IndustrialDarkTokens.fontSizeBody,
            fontWeight: IndustrialDarkTokens.fontWeightMedium,
            letterSpacing: IndustrialDarkTokens.letterSpacing,
          ),
          minimumSize: const Size(IndustrialDarkTokens.touchTargetMin, IndustrialDarkTokens.touchTargetMin),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: IndustrialDarkTokens.accentPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: IndustrialDarkTokens.spacingCard,
            vertical: IndustrialDarkTokens.spacingCompact,
          ),
          textStyle: const TextStyle(
            fontSize: IndustrialDarkTokens.fontSizeLabel,
            fontWeight: IndustrialDarkTokens.fontWeightMedium,
            letterSpacing: IndustrialDarkTokens.letterSpacing,
          ),
        ),
      ),

      // ========================================================================
      // ICON THEME
      // ========================================================================
      iconTheme: const IconThemeData(
        color: IndustrialDarkTokens.textPrimary,
        size: 24,
      ),

      // ========================================================================
      // DIVIDER THEME
      // ========================================================================
      dividerTheme: DividerThemeData(
        color: IndustrialDarkTokens.outline,
        thickness: IndustrialDarkTokens.borderWidthThin,
        space: IndustrialDarkTokens.borderWidthThin,
      ),

      // ========================================================================
      // DIALOG THEME
      // ========================================================================
      dialogTheme: DialogTheme(
        backgroundColor: IndustrialDarkTokens.bgSurface,
        elevation: 0, // No elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusCard),
          side: BorderSide(
            color: IndustrialDarkTokens.outline,
            width: IndustrialDarkTokens.borderWidth,
          ),
        ),
        titleTextStyle: IndustrialDarkTokens.displayStyle,
        contentTextStyle: IndustrialDarkTokens.bodyStyle,
      ),

      // ========================================================================
      // BOTTOM SHEET THEME
      // ========================================================================
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: IndustrialDarkTokens.bgSurface,
        elevation: 0, // No elevation
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(IndustrialDarkTokens.radiusCard),
            topRight: Radius.circular(IndustrialDarkTokens.radiusCard),
          ),
          side: BorderSide(
            color: IndustrialDarkTokens.outline,
            width: IndustrialDarkTokens.borderWidth,
          ),
        ),
        modalBackgroundColor: IndustrialDarkTokens.bgSurface,
        modalElevation: 0,
      ),

      // ========================================================================
      // SNACKBAR THEME
      // ========================================================================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: IndustrialDarkTokens.bgSurface,
        contentTextStyle: IndustrialDarkTokens.bodyStyle,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusButton),
          side: BorderSide(
            color: IndustrialDarkTokens.outline,
            width: IndustrialDarkTokens.borderWidth,
          ),
        ),
      ),

      // ========================================================================
      // PROGRESS INDICATOR THEME
      // ========================================================================
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: IndustrialDarkTokens.accentPrimary,
        linearTrackColor: IndustrialDarkTokens.outline,
        circularTrackColor: IndustrialDarkTokens.outline,
      ),

      // ========================================================================
      // FLOATING ACTION BUTTON THEME
      // ========================================================================
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: IndustrialDarkTokens.accentPrimary,
        foregroundColor: Colors.white,
        elevation: 0, // No elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusCard),
          side: BorderSide(
            color: IndustrialDarkTokens.outline,
            width: IndustrialDarkTokens.borderWidth,
          ),
        ),
      ),

      // ========================================================================
      // LIST TILE THEME
      // ========================================================================
      listTileTheme: ListTileThemeData(
        tileColor: IndustrialDarkTokens.bgSurface,
        selectedTileColor: IndustrialDarkTokens.accentPrimary.withOpacity(0.1),
        iconColor: IndustrialDarkTokens.textPrimary,
        textColor: IndustrialDarkTokens.textPrimary,
        titleTextStyle: IndustrialDarkTokens.bodyStyle,
        subtitleTextStyle: IndustrialDarkTokens.labelStyle,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: IndustrialDarkTokens.spacingCard,
          vertical: IndustrialDarkTokens.spacingCompact,
        ),
        minVerticalPadding: IndustrialDarkTokens.spacingCompact,
        minLeadingWidth: IndustrialDarkTokens.touchTargetMin,
      ),

      // ========================================================================
      // TOOLTIP THEME
      // ========================================================================
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: IndustrialDarkTokens.bgSurface,
          borderRadius: BorderRadius.circular(IndustrialDarkTokens.radiusSmall),
          border: Border.all(
            color: IndustrialDarkTokens.outline,
            width: IndustrialDarkTokens.borderWidthThin,
          ),
        ),
        textStyle: IndustrialDarkTokens.labelStyle,
        padding: const EdgeInsets.symmetric(
          horizontal: IndustrialDarkTokens.spacingCompact,
          vertical: IndustrialDarkTokens.spacingMinimal,
        ),
      ),
    );
  }
}
