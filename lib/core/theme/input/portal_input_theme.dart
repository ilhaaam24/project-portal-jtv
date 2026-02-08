import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';

/// Input Theme untuk Portal JTV
/// Berisi konfigurasi untuk TextField, SearchBar, dan input lainnya
class PortalInputTheme {
  PortalInputTheme._();

  // ============ LIGHT THEME ============

  static InputDecorationTheme get lightInputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: PortalColors.grey100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: PortalColors.jtvBiru, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: PortalColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: PortalColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: const TextStyle(color: PortalColors.grey500),
      labelStyle: const TextStyle(color: PortalColors.grey700),
      floatingLabelStyle: const TextStyle(color: PortalColors.jtvBiru),
      errorStyle: const TextStyle(color: PortalColors.error),
      prefixIconColor: PortalColors.grey500,
      suffixIconColor: PortalColors.grey500,
    );
  }

  // ============ DARK THEME ============

  static InputDecorationTheme get darkInputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: PortalColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: PortalColors.jtvJingga, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: PortalColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: PortalColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: const TextStyle(color: PortalColors.grey500),
      labelStyle: const TextStyle(color: PortalColors.grey300),
      floatingLabelStyle: const TextStyle(color: PortalColors.jtvJingga),
      errorStyle: const TextStyle(color: PortalColors.error),
      prefixIconColor: PortalColors.grey500,
      suffixIconColor: PortalColors.grey500,
    );
  }

  // ============ VARIAN INPUT ============

  /// Search bar decoration
  static InputDecoration searchBarDecoration({String? hintText}) {
    return InputDecoration(
      filled: true,
      fillColor: PortalColors.grey100,
      hintText: hintText ?? 'Cari...',
      hintStyle: const TextStyle(color: PortalColors.grey500),
      prefixIcon: const Icon(Icons.search, color: PortalColors.grey500),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: PortalColors.jtvBiru, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  /// Dark search bar decoration
  static InputDecoration darkSearchBarDecoration({String? hintText}) {
    return InputDecoration(
      filled: true,
      fillColor: PortalColors.darkSurface,
      hintText: hintText ?? 'Cari...',
      hintStyle: const TextStyle(color: PortalColors.grey500),
      prefixIcon: const Icon(Icons.search, color: PortalColors.grey500),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: PortalColors.jtvJingga, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
