import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';

/// Button Theme untuk Portal JTV
/// Berisi konfigurasi untuk ElevatedButton, TextButton, OutlinedButton, dan FAB
class PortalButtonTheme {
  PortalButtonTheme._();

  // ============ LIGHT THEME ============

  static ElevatedButtonThemeData get lightElevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: PortalColors.jtvJingga,
        foregroundColor: PortalColors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static TextButtonThemeData get lightTextButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: PortalColors.jtvBiru),
    );
  }

  static OutlinedButtonThemeData get lightOutlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: PortalColors.jtvBiru,
        side: const BorderSide(color: PortalColors.jtvBiru),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static const FloatingActionButtonThemeData lightFabTheme =
      FloatingActionButtonThemeData(
        backgroundColor: PortalColors.jtvJingga,
        foregroundColor: PortalColors.white,
      );

  // ============ DARK THEME ============

  static ElevatedButtonThemeData get darkElevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: PortalColors.jtvJingga,
        foregroundColor: PortalColors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static TextButtonThemeData get darkTextButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: PortalColors.jtvBiruToska),
    );
  }

  static OutlinedButtonThemeData get darkOutlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: PortalColors.jtvJingga,
        side: const BorderSide(color: PortalColors.jtvJingga),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static const FloatingActionButtonThemeData darkFabTheme =
      FloatingActionButtonThemeData(
        backgroundColor: PortalColors.jtvJingga,
        foregroundColor: PortalColors.white,
      );

  // ============ VARIAN BUTTON ============

  /// Secondary button style (menggunakan warna Biru)
  static ButtonStyle get secondaryButtonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: PortalColors.jtvBiru,
      foregroundColor: PortalColors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  /// Danger button style (untuk aksi berbahaya)
  static ButtonStyle get dangerButtonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: PortalColors.error,
      foregroundColor: PortalColors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  /// Success button style
  static ButtonStyle get successButtonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: PortalColors.success,
      foregroundColor: PortalColors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
