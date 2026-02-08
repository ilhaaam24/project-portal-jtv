import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/portal_colors.dart';

/// AppBar Theme untuk Portal JTV
/// Mendukung Light dan Dark mode dengan warna brand JTV
class PortalAppBarTheme {
  PortalAppBarTheme._();

  // ============================================================
  // LIGHT APP BAR THEME
  // ============================================================

  static const AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: PortalColors.jtvBiru,
    foregroundColor: PortalColors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: PortalColors.white),
    actionsIconTheme: IconThemeData(color: PortalColors.white),
    titleTextStyle: TextStyle(
      color: PortalColors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );

  // ============================================================
  // DARK APP BAR THEME
  // ============================================================

  static const AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: PortalColors.darkSurface,
    foregroundColor: PortalColors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: PortalColors.white),
    actionsIconTheme: IconThemeData(color: PortalColors.white),
    titleTextStyle: TextStyle(
      color: PortalColors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );

  // ============================================================
  // TRANSPARENT APP BAR (untuk halaman dengan gambar header)
  // ============================================================

  static const AppBarTheme transparentAppBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: PortalColors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: PortalColors.white),
    actionsIconTheme: IconThemeData(color: PortalColors.white),
  );

  // ============================================================
  // JTV JINGGA APP BAR (untuk halaman khusus)
  // ============================================================

  static const AppBarTheme jinggaAppBarTheme = AppBarTheme(
    backgroundColor: PortalColors.jtvJingga,
    foregroundColor: PortalColors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: PortalColors.white),
    actionsIconTheme: IconThemeData(color: PortalColors.white),
    titleTextStyle: TextStyle(
      color: PortalColors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );
}
