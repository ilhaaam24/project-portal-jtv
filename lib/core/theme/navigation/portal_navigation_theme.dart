import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/portal_colors.dart';

/// Navigation Theme untuk Portal JTV
/// Berisi konfigurasi untuk BottomNavigationBar dan NavigationBar (Material 3)
class PortalNavigationTheme {
  PortalNavigationTheme._();

  // ============ LIGHT THEME ============

  static const BottomNavigationBarThemeData lightBottomNavTheme =
      BottomNavigationBarThemeData(
        backgroundColor: PortalColors.white,
        selectedItemColor: PortalColors.jtvBiru,
        unselectedItemColor: PortalColors.grey500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      );

  static NavigationBarThemeData get lightNavigationBarTheme {
    return NavigationBarThemeData(
      backgroundColor: PortalColors.white,
      indicatorColor: PortalColors.jtvBiru.withValues(alpha: 0.1),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: PortalColors.jtvBiru);
        }
        return const IconThemeData(color: PortalColors.grey500);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: PortalColors.jtvBiru,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(color: PortalColors.grey500);
      }),
    );
  }

  // ============ DARK THEME ============

  static const BottomNavigationBarThemeData darkBottomNavTheme =
      BottomNavigationBarThemeData(
        backgroundColor: PortalColors.darkSurface,
        selectedItemColor: PortalColors.jtvJingga,
        unselectedItemColor: PortalColors.grey500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      );

  static NavigationBarThemeData get darkNavigationBarTheme {
    return NavigationBarThemeData(
      backgroundColor: PortalColors.darkSurface,
      indicatorColor: PortalColors.jtvJingga.withValues(alpha: 0.2),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: PortalColors.jtvJingga);
        }
        return const IconThemeData(color: PortalColors.grey500);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: PortalColors.jtvJingga,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(color: PortalColors.grey500);
      }),
    );
  }

  // ============ TAB BAR THEME ============

  static TabBarThemeData get lightTabBarTheme {
    return TabBarThemeData(
      labelColor: PortalColors.jtvBiru,
      unselectedLabelColor: PortalColors.grey500,
      indicatorColor: PortalColors.jtvJingga,
      indicatorSize: TabBarIndicatorSize.tab,
    );
  }

  static TabBarThemeData get darkTabBarTheme {
    return TabBarThemeData(
      labelColor: PortalColors.jtvJingga,
      unselectedLabelColor: PortalColors.grey500,
      indicatorColor: PortalColors.jtvJingga,
      indicatorSize: TabBarIndicatorSize.tab,
    );
  }
}
