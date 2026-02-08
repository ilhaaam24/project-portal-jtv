import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/appbar/portal_appbar_theme.dart';
import 'package:portal_jtv/core/theme/button/portal_button_theme.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/core/theme/input/portal_input_theme.dart';
import 'package:portal_jtv/core/theme/navigation/portal_navigation_theme.dart';
import 'package:portal_jtv/core/theme/typography/portal_typography.dart';

/// Theme utama untuk Portal JTV
/// Mendukung Light dan Dark mode dengan warna brand JTV
class PortalTheme {
  PortalTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: PortalColors.jtvBiru,
      colorScheme: const ColorScheme.light(
        primary: PortalColors.jtvBiru,
        onPrimary: PortalColors.white,
        secondary: PortalColors.jtvJingga,
        onSecondary: PortalColors.white,
        tertiary: PortalColors.jtvBiruToska,
        onTertiary: PortalColors.white,
        surface: PortalColors.white,
        onSurface: PortalColors.grey900,
        error: PortalColors.error,
        onError: PortalColors.white,
      ),
      scaffoldBackgroundColor: PortalColors.grey50,

      // AppBar
      appBarTheme: PortalAppBarTheme.lightAppBarTheme,

      // Button Themes
      elevatedButtonTheme: PortalButtonTheme.lightElevatedButtonTheme,
      textButtonTheme: PortalButtonTheme.lightTextButtonTheme,
      outlinedButtonTheme: PortalButtonTheme.lightOutlinedButtonTheme,
      floatingActionButtonTheme: PortalButtonTheme.lightFabTheme,

      // Navigation Themes
      bottomNavigationBarTheme: PortalNavigationTheme.lightBottomNavTheme,
      navigationBarTheme: PortalNavigationTheme.lightNavigationBarTheme,
      tabBarTheme: PortalNavigationTheme.lightTabBarTheme,

      // Input Theme
      inputDecorationTheme: PortalInputTheme.lightInputDecorationTheme,

      // Card Theme
      cardTheme: CardThemeData(
        color: PortalColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: PortalColors.grey100,
        selectedColor: PortalColors.jtvBiru,
        labelStyle: const TextStyle(color: PortalColors.grey700),
        secondaryLabelStyle: const TextStyle(color: PortalColors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: PortalColors.grey200,
        thickness: 1,
      ),

      // Text Theme
      textTheme: _textTheme,
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: PortalColors.jtvBiru,
      colorScheme: const ColorScheme.dark(
        primary: PortalColors.jtvJingga,
        onPrimary: PortalColors.white,
        secondary: PortalColors.jtvBiruToska,
        onSecondary: PortalColors.white,
        tertiary: PortalColors.jtvKuning,
        onTertiary: PortalColors.black,
        surface: PortalColors.darkSurface,
        onSurface: PortalColors.white,
        error: PortalColors.error,
        onError: PortalColors.white,
      ),
      scaffoldBackgroundColor: PortalColors.darkBackground,

      // AppBar
      appBarTheme: PortalAppBarTheme.darkAppBarTheme,

      // Button Themes
      elevatedButtonTheme: PortalButtonTheme.darkElevatedButtonTheme,
      textButtonTheme: PortalButtonTheme.darkTextButtonTheme,
      outlinedButtonTheme: PortalButtonTheme.darkOutlinedButtonTheme,
      floatingActionButtonTheme: PortalButtonTheme.darkFabTheme,

      // Navigation Themes
      bottomNavigationBarTheme: PortalNavigationTheme.darkBottomNavTheme,
      navigationBarTheme: PortalNavigationTheme.darkNavigationBarTheme,
      tabBarTheme: PortalNavigationTheme.darkTabBarTheme,

      // Input Theme
      inputDecorationTheme: PortalInputTheme.darkInputDecorationTheme,

      // Card Theme
      cardTheme: CardThemeData(
        color: PortalColors.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: PortalColors.darkSurface,
        selectedColor: PortalColors.jtvJingga,
        labelStyle: const TextStyle(color: PortalColors.grey300),
        secondaryLabelStyle: const TextStyle(color: PortalColors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: PortalColors.grey700.withValues(alpha: 0.5),
        thickness: 1,
      ),

      // Text Theme
      textTheme: _textTheme,
      useMaterial3: true,
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: PortalTypography.displayLarge,
      displayMedium: PortalTypography.displayMedium,
      displaySmall: PortalTypography.displaySmall,
      headlineLarge: PortalTypography.headlineLarge,
      headlineMedium: PortalTypography.headlineMedium,
      headlineSmall: PortalTypography.headlineSmall,
      titleLarge: PortalTypography.titleLarge,
      titleMedium: PortalTypography.titleMedium,
      titleSmall: PortalTypography.titleSmall,
      bodyLarge: PortalTypography.bodyLargeBold,
      bodyMedium: PortalTypography.bodyLargeMedium,
      bodySmall: PortalTypography.bodyLargeRegular,
      labelLarge: PortalTypography.labelLarge,
      labelMedium: PortalTypography.labelMedium,
      labelSmall: PortalTypography.labelSmall,
    );
  }
}
