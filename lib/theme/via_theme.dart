import 'package:flutter/material.dart';
import 'package:aprofleet_manager/core/theme/via_design_tokens.dart';

/// VIA Design System Theme for AproFleet Golf Cart Manager
///
/// This theme applies the complete VIA design language to the app,
/// ensuring visual consistency across all screens and components.
class ViaTheme {
  // Private constructor to prevent instantiation
  ViaTheme._();

  /// Main dark theme using VIA design tokens
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // ========================================================================
      // COLOR SCHEME
      // ========================================================================
      colorScheme: ColorScheme.dark(
        primary: ViaDesignTokens.primary,
        secondary: ViaDesignTokens.secondary,
        surface: ViaDesignTokens.surfacePrimary,
        error: ViaDesignTokens.critical,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: ViaDesignTokens.textPrimary,
        onError: Colors.white,
      ),

      // ========================================================================
      // BASE COLORS
      // ========================================================================
      primaryColor: ViaDesignTokens.primary,
      scaffoldBackgroundColor: ViaDesignTokens.surfacePrimary,
      canvasColor: ViaDesignTokens.surfacePrimary,
      cardColor: ViaDesignTokens.surfaceTertiary,
      dividerColor: ViaDesignTokens.borderPrimary,

      // ========================================================================
      // APP BAR THEME
      // ========================================================================
      appBarTheme: AppBarTheme(
        backgroundColor: ViaDesignTokens.surfacePrimary,
        foregroundColor: ViaDesignTokens.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: ViaDesignTokens.headingMedium,
        iconTheme: IconThemeData(
          color: ViaDesignTokens.textPrimary,
          size: ViaDesignTokens.iconMd,
        ),
      ),

      // ========================================================================
      // BOTTOM NAVIGATION BAR THEME
      // ========================================================================
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ViaDesignTokens.surfacePrimary,
        selectedItemColor: ViaDesignTokens.primary,
        unselectedItemColor: ViaDesignTokens.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: ViaDesignTokens.labelSmall,
        unselectedLabelStyle: ViaDesignTokens.labelSmall,
      ),

      // ========================================================================
      // CARD THEME
      // ========================================================================
      cardTheme: CardThemeData(
        color: ViaDesignTokens.surfaceTertiary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusLg),
          side: BorderSide(
            color: ViaDesignTokens.borderPrimary,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(0),
      ),

      // ========================================================================
      // TEXT THEME
      // ========================================================================
      textTheme: TextTheme(
        // Display styles
        displayLarge: ViaDesignTokens.displayLarge,
        displayMedium: ViaDesignTokens.displayMedium,
        displaySmall: ViaDesignTokens.displaySmall,

        // Heading styles
        headlineLarge: ViaDesignTokens.headingLarge,
        headlineMedium: ViaDesignTokens.headingMedium,
        headlineSmall: ViaDesignTokens.headingSmall,

        // Title styles (for app bars, card headers)
        titleLarge: ViaDesignTokens.headingLarge,
        titleMedium: ViaDesignTokens.headingMedium,
        titleSmall: ViaDesignTokens.headingSmall,

        // Body styles
        bodyLarge: ViaDesignTokens.bodyLarge,
        bodyMedium: ViaDesignTokens.bodyMedium,
        bodySmall: ViaDesignTokens.bodySmall,

        // Label styles
        labelLarge: ViaDesignTokens.labelLarge,
        labelMedium: ViaDesignTokens.labelMedium,
        labelSmall: ViaDesignTokens.labelSmall,
      ),

      // ========================================================================
      // INPUT DECORATION THEME
      // ========================================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ViaDesignTokens.surfaceSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
          borderSide: BorderSide(
            color: ViaDesignTokens.borderPrimary,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
          borderSide: BorderSide(
            color: ViaDesignTokens.borderPrimary,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
          borderSide: BorderSide(
            color: ViaDesignTokens.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
          borderSide: BorderSide(
            color: ViaDesignTokens.critical,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
          borderSide: BorderSide(
            color: ViaDesignTokens.critical,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ViaDesignTokens.spacingLg,
          vertical: ViaDesignTokens.spacingMd,
        ),
        hintStyle: ViaDesignTokens.bodyMedium.copyWith(
          color: ViaDesignTokens.textMuted,
        ),
        labelStyle: ViaDesignTokens.bodyMedium.copyWith(
          color: ViaDesignTokens.textMuted,
        ),
        floatingLabelStyle: ViaDesignTokens.bodySmall.copyWith(
          color: ViaDesignTokens.primary,
        ),
      ),

      // ========================================================================
      // BUTTON THEMES
      // ========================================================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ViaDesignTokens.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: ViaDesignTokens.spacingXl,
            vertical: ViaDesignTokens.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
          ),
          textStyle: ViaDesignTokens.labelLarge.copyWith(
            color: Colors.white,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ViaDesignTokens.primary,
          side: BorderSide(
            color: ViaDesignTokens.primary,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: ViaDesignTokens.spacingXl,
            vertical: ViaDesignTokens.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
          ),
          textStyle: ViaDesignTokens.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ViaDesignTokens.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: ViaDesignTokens.spacingLg,
            vertical: ViaDesignTokens.spacingSm,
          ),
          textStyle: ViaDesignTokens.labelMedium,
        ),
      ),

      // ========================================================================
      // ICON THEME
      // ========================================================================
      iconTheme: IconThemeData(
        color: ViaDesignTokens.textPrimary,
        size: ViaDesignTokens.iconMd,
      ),

      // ========================================================================
      // DIVIDER THEME
      // ========================================================================
      dividerTheme: DividerThemeData(
        color: ViaDesignTokens.borderPrimary,
        thickness: 1,
        space: 1,
      ),

      // ========================================================================
      // CHIP THEME
      // ========================================================================
      chipTheme: ChipThemeData(
        backgroundColor: ViaDesignTokens.surfaceSecondary,
        deleteIconColor: ViaDesignTokens.textMuted,
        disabledColor: ViaDesignTokens.surfaceSecondary.withOpacity(0.5),
        selectedColor: ViaDesignTokens.primary.withOpacity(0.2),
        secondarySelectedColor: ViaDesignTokens.secondary.withOpacity(0.2),
        labelPadding: const EdgeInsets.symmetric(
          horizontal: ViaDesignTokens.spacingSm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: ViaDesignTokens.spacingMd,
          vertical: ViaDesignTokens.spacingSm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusFull),
          side: BorderSide(
            color: ViaDesignTokens.borderPrimary,
            width: 1,
          ),
        ),
        labelStyle: ViaDesignTokens.labelMedium,
        secondaryLabelStyle: ViaDesignTokens.labelSmall,
        brightness: Brightness.dark,
      ),

      // ========================================================================
      // DIALOG THEME
      // ========================================================================
      dialogTheme: DialogTheme(
        backgroundColor: ViaDesignTokens.surfaceSecondary,
        elevation: ViaDesignTokens.elevationXl,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusXl),
          side: BorderSide(
            color: ViaDesignTokens.borderPrimary,
            width: 1,
          ),
        ),
        titleTextStyle: ViaDesignTokens.headingMedium,
        contentTextStyle: ViaDesignTokens.bodyMedium,
      ),

      // ========================================================================
      // BOTTOM SHEET THEME
      // ========================================================================
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ViaDesignTokens.surfaceSecondary,
        elevation: ViaDesignTokens.elevationXl,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ViaDesignTokens.radiusXl),
            topRight: Radius.circular(ViaDesignTokens.radiusXl),
          ),
        ),
        modalBackgroundColor: ViaDesignTokens.surfaceSecondary,
        modalElevation: ViaDesignTokens.elevationXl,
      ),

      // ========================================================================
      // SNACKBAR THEME
      // ========================================================================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ViaDesignTokens.surfaceTertiary,
        contentTextStyle: ViaDesignTokens.bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusMd),
          side: BorderSide(
            color: ViaDesignTokens.borderPrimary,
            width: 1,
          ),
        ),
      ),

      // ========================================================================
      // PROGRESS INDICATOR THEME
      // ========================================================================
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: ViaDesignTokens.primary,
        linearTrackColor: ViaDesignTokens.surfaceSecondary,
        circularTrackColor: ViaDesignTokens.surfaceSecondary,
      ),

      // ========================================================================
      // SWITCH THEME
      // ========================================================================
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }
            return ViaDesignTokens.textMuted;
          },
        ),
        trackColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return ViaDesignTokens.primary;
            }
            return ViaDesignTokens.surfaceSecondary;
          },
        ),
      ),

      // ========================================================================
      // CHECKBOX THEME
      // ========================================================================
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return ViaDesignTokens.primary;
            }
            return Colors.transparent;
          },
        ),
        checkColor: MaterialStateProperty.all(Colors.white),
        side: BorderSide(
          color: ViaDesignTokens.borderSecondary,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusXs),
        ),
      ),

      // ========================================================================
      // RADIO THEME
      // ========================================================================
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return ViaDesignTokens.primary;
            }
            return ViaDesignTokens.textMuted;
          },
        ),
      ),

      // ========================================================================
      // SLIDER THEME
      // ========================================================================
      sliderTheme: SliderThemeData(
        activeTrackColor: ViaDesignTokens.primary,
        inactiveTrackColor: ViaDesignTokens.surfaceSecondary,
        thumbColor: Colors.white,
        overlayColor: ViaDesignTokens.primary.withOpacity(0.2),
        valueIndicatorColor: ViaDesignTokens.primary,
        valueIndicatorTextStyle: ViaDesignTokens.labelSmall.copyWith(
          color: Colors.white,
        ),
      ),

      // ========================================================================
      // TAB BAR THEME
      // ========================================================================
      tabBarTheme: TabBarTheme(
        labelColor: ViaDesignTokens.primary,
        unselectedLabelColor: ViaDesignTokens.textMuted,
        labelStyle: ViaDesignTokens.labelMedium,
        unselectedLabelStyle: ViaDesignTokens.labelMedium,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: ViaDesignTokens.primary,
            width: 2,
          ),
        ),
      ),

      // ========================================================================
      // LIST TILE THEME
      // ========================================================================
      listTileTheme: ListTileThemeData(
        tileColor: ViaDesignTokens.surfaceTertiary,
        selectedTileColor: ViaDesignTokens.primary.withOpacity(0.1),
        iconColor: ViaDesignTokens.textPrimary,
        textColor: ViaDesignTokens.textPrimary,
        titleTextStyle: ViaDesignTokens.bodyMedium,
        subtitleTextStyle: ViaDesignTokens.bodySmall,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ViaDesignTokens.spacingLg,
          vertical: ViaDesignTokens.spacingSm,
        ),
      ),

      // ========================================================================
      // TOOLTIP THEME
      // ========================================================================
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: ViaDesignTokens.surfaceQuaternary,
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusSm),
          border: Border.all(
            color: ViaDesignTokens.borderPrimary,
            width: 1,
          ),
        ),
        textStyle: ViaDesignTokens.bodySmall,
        padding: const EdgeInsets.symmetric(
          horizontal: ViaDesignTokens.spacingSm,
          vertical: ViaDesignTokens.spacingXs,
        ),
      ),

      // ========================================================================
      // FLOATING ACTION BUTTON THEME
      // ========================================================================
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ViaDesignTokens.primary,
        foregroundColor: Colors.white,
        elevation: ViaDesignTokens.elevationLg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ViaDesignTokens.radiusLg),
        ),
      ),

      // ========================================================================
      // BADGE THEME
      // ========================================================================
      badgeTheme: BadgeThemeData(
        backgroundColor: ViaDesignTokens.critical,
        textColor: Colors.white,
        textStyle: ViaDesignTokens.labelSmall.copyWith(
          color: Colors.white,
          fontSize: ViaDesignTokens.fontSizeXxs,
        ),
      ),
    );
  }
}
