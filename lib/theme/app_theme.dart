import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the application.
/// Implements Contemporary Educational Minimalism with Adaptive Academic Palette
class AppTheme {
  AppTheme._();

  // Adaptive Academic Palette - Color Specifications
  static const Color primaryLight = Color(0xFF2E7D32); // Deep academic green
  static const Color primaryDark =
      Color(0xFF4CAF50); // Lighter green for dark mode
  static const Color secondaryLight = Color(0xFF1565C0); // Professional blue
  static const Color secondaryDark =
      Color(0xFF42A5F5); // Lighter blue for dark mode
  static const Color surfaceLight =
      Color(0xFFFAFAFA); // Warm neutral background
  static const Color surfaceDark = Color(0xFF121212); // Dark surface
  static const Color onSurfaceLight = Color(0xFF1C1B1F); // High contrast text
  static const Color onSurfaceDark =
      Color(0xFFE6E1E5); // Light text for dark mode
  static const Color accentLight = Color(0xFFF57C00); // Energetic orange
  static const Color accentDark =
      Color(0xFFFFB74D); // Lighter orange for dark mode
  static const Color errorLight =
      Color(0xFFD32F2F); // Clear error communication
  static const Color errorDark =
      Color(0xFFEF5350); // Lighter error for dark mode
  static const Color successLight = Color(0xFF388E3C); // Positive feedback
  static const Color successDark =
      Color(0xFF66BB6A); // Lighter success for dark mode
  static const Color warningLight =
      Color(0xFFF9A825); // Attention-drawing yellow
  static const Color warningDark =
      Color(0xFFFFCA28); // Lighter warning for dark mode
  static const Color outlineLight =
      Color(0xFF79747E); // Subtle boundary definition
  static const Color outlineDark =
      Color(0xFF938F99); // Lighter outline for dark mode
  static const Color shadowColor = Color(0x1F000000); // 12% opacity shadow

  // Text emphasis colors
  static const Color textHighEmphasisLight = Color(0xDE000000); // 87% opacity
  static const Color textMediumEmphasisLight = Color(0x99000000); // 60% opacity
  static const Color textDisabledLight = Color(0x61000000); // 38% opacity

  static const Color textHighEmphasisDark = Color(0xDEFFFFFF); // 87% opacity
  static const Color textMediumEmphasisDark = Color(0x99FFFFFF); // 60% opacity
  static const Color textDisabledDark = Color(0x61FFFFFF); // 38% opacity

  // Card and dialog colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color dialogLight = Color(0xFFFFFFFF);
  static const Color dialogDark = Color(0xFF2D2D2D);

  /// Light theme implementing Contemporary Educational Minimalism
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: Colors.white,
      primaryContainer: primaryLight.withValues(alpha: 0.1),
      onPrimaryContainer: primaryLight,
      secondary: secondaryLight,
      onSecondary: Colors.white,
      secondaryContainer: secondaryLight.withValues(alpha: 0.1),
      onSecondaryContainer: secondaryLight,
      tertiary: accentLight,
      onTertiary: Colors.white,
      tertiaryContainer: accentLight.withValues(alpha: 0.1),
      onTertiaryContainer: accentLight,
      error: errorLight,
      onError: Colors.white,
      surface: surfaceLight,
      onSurface: onSurfaceLight,
      onSurfaceVariant: textMediumEmphasisLight,
      outline: outlineLight,
      outlineVariant: outlineLight.withValues(alpha: 0.2),
      shadow: shadowColor,
      scrim: shadowColor,
      inverseSurface: surfaceDark,
      onInverseSurface: onSurfaceDark,
      inversePrimary: primaryDark,
    ),
    scaffoldBackgroundColor: surfaceLight,
    cardColor: cardLight,
    dividerColor: outlineLight.withValues(alpha: 0.2),

    // AppBar theme for clean, focused interface
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: onSurfaceLight,
      elevation: 2.0,
      shadowColor: shadowColor,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onSurfaceLight,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(color: onSurfaceLight),
      actionsIconTheme: IconThemeData(color: onSurfaceLight),
    ),

    // Card theme with subtle elevation
    cardTheme: CardTheme(
      color: cardLight,
      elevation: 2.0,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation for main app navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primaryLight,
      unselectedItemColor: textMediumEmphasisLight,
      elevation: 8.0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating action button for primary actions
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes for consistent interaction
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryLight,
        elevation: 2.0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(color: primaryLight, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // Typography using Inter font family
    textTheme: _buildTextTheme(isLight: true),

    // Input decoration for forms
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceLight,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: outlineLight.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: outlineLight.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primaryLight, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorLight, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorLight, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textMediumEmphasisLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Interactive elements
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return Colors.grey[300];
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight.withValues(alpha: 0.5);
        }
        return Colors.grey[300];
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: BorderSide(color: outlineLight, width: 1.5),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return outlineLight;
      }),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryLight,
      linearTrackColor: primaryLight.withValues(alpha: 0.2),
      circularTrackColor: primaryLight.withValues(alpha: 0.2),
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: primaryLight,
      thumbColor: primaryLight,
      overlayColor: primaryLight.withValues(alpha: 0.2),
      inactiveTrackColor: primaryLight.withValues(alpha: 0.3),
      valueIndicatorColor: primaryLight,
    ),

    tabBarTheme: TabBarTheme(
      labelColor: primaryLight,
      unselectedLabelColor: textMediumEmphasisLight,
      indicatorColor: primaryLight,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: onSurfaceLight.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: GoogleFonts.inter(
        color: surfaceLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: onSurfaceLight,
      contentTextStyle: GoogleFonts.inter(
        color: surfaceLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
    ), dialogTheme: DialogThemeData(backgroundColor: dialogLight),
  );

  /// Dark theme implementing Contemporary Educational Minimalism
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: Colors.black,
      primaryContainer: primaryDark.withValues(alpha: 0.2),
      onPrimaryContainer: primaryDark,
      secondary: secondaryDark,
      onSecondary: Colors.black,
      secondaryContainer: secondaryDark.withValues(alpha: 0.2),
      onSecondaryContainer: secondaryDark,
      tertiary: accentDark,
      onTertiary: Colors.black,
      tertiaryContainer: accentDark.withValues(alpha: 0.2),
      onTertiaryContainer: accentDark,
      error: errorDark,
      onError: Colors.black,
      surface: surfaceDark,
      onSurface: onSurfaceDark,
      onSurfaceVariant: textMediumEmphasisDark,
      outline: outlineDark,
      outlineVariant: outlineDark.withValues(alpha: 0.2),
      shadow: shadowColor,
      scrim: shadowColor,
      inverseSurface: surfaceLight,
      onInverseSurface: onSurfaceLight,
      inversePrimary: primaryLight,
    ),
    scaffoldBackgroundColor: surfaceDark,
    cardColor: cardDark,
    dividerColor: outlineDark.withValues(alpha: 0.2),

    // AppBar theme for dark mode
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: onSurfaceDark,
      elevation: 2.0,
      shadowColor: shadowColor,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onSurfaceDark,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(color: onSurfaceDark),
      actionsIconTheme: IconThemeData(color: onSurfaceDark),
    ),

    // Card theme for dark mode
    cardTheme: CardTheme(
      color: cardDark,
      elevation: 2.0,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation for dark mode
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryDark,
      unselectedItemColor: textMediumEmphasisDark,
      elevation: 8.0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating action button for dark mode
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: Colors.black,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes for dark mode
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: primaryDark,
        elevation: 2.0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(color: primaryDark, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // Typography for dark mode
    textTheme: _buildTextTheme(isLight: false),

    // Input decoration for dark mode
    inputDecorationTheme: InputDecorationTheme(
      fillColor: cardDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: outlineDark.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: outlineDark.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primaryDark, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorDark, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorDark, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textMediumEmphasisDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Interactive elements for dark mode
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return Colors.grey[600];
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark.withValues(alpha: 0.5);
        }
        return Colors.grey[600];
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.black),
      side: BorderSide(color: outlineDark, width: 1.5),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return outlineDark;
      }),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryDark,
      linearTrackColor: primaryDark.withValues(alpha: 0.2),
      circularTrackColor: primaryDark.withValues(alpha: 0.2),
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: primaryDark,
      thumbColor: primaryDark,
      overlayColor: primaryDark.withValues(alpha: 0.2),
      inactiveTrackColor: primaryDark.withValues(alpha: 0.3),
      valueIndicatorColor: primaryDark,
    ),

    tabBarTheme: TabBarTheme(
      labelColor: primaryDark,
      unselectedLabelColor: textMediumEmphasisDark,
      indicatorColor: primaryDark,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: onSurfaceDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: GoogleFonts.inter(
        color: surfaceDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: onSurfaceDark,
      contentTextStyle: GoogleFonts.inter(
        color: surfaceDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
    ), dialogTheme: DialogThemeData(backgroundColor: dialogDark),
  );

  /// Helper method to build text theme using Inter font family
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis =
        isLight ? textHighEmphasisLight : textHighEmphasisDark;
    final Color textMediumEmphasis =
        isLight ? textMediumEmphasisLight : textMediumEmphasisDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
      // Display styles - for large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
      ),

      // Headline styles - for section headings
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),

      // Title styles - for card titles and important text
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),

      // Body styles - for main content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
      ),

      // Label styles - for buttons and small text
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textDisabled,
        letterSpacing: 0.5,
      ),
    );
  }
}
