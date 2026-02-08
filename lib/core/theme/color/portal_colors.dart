import 'package:flutter/material.dart';

/// Kelas yang berisi semua warna brand JTV Portal
/// Berdasarkan Brand Guidelines JTV
class PortalColors {
  PortalColors._();

  // ============================================================
  // WARNA UTAMA (Primary Colors)
  // ============================================================

  /// JTV Biru - Warna utama brand
  /// PANTONE: 295 C | RGB: 15, 45, 82 | HEX: #0F2D52
  static const Color jtvBiru = Color(0xFF0F2D52);

  /// JTV Jingga - Warna aksen utama
  /// PANTONE: 1505 C | RGB: 243, 109, 33 | HEX: #F36D21
  static const Color jtvJingga = Color(0xFFF36D21);

  // ============================================================
  // WARNA SEKUNDER (Secondary Colors)
  // ============================================================

  /// JTV Merah Jambu
  /// PANTONE: 205 C | RGB: 230, 66, 123 | HEX: #E6427B
  static const Color jtvMerahJambu = Color(0xFFE6427B);

  /// JTV Merah Jambu Muda
  /// PANTONE: 197 C | RGB: 236, 155, 172 | HEX: #EC9BAC
  static const Color jtvMerahJambuMuda = Color(0xFFEC9BAC);

  /// JTV Biru Toska
  /// PANTONE: 3262 C | RGB: 0, 176, 173 | HEX: #00B0AD
  static const Color jtvBiruToska = Color(0xFF00B0AD);

  /// JTV Kuning
  /// PANTONE: 128 C | RGB: 246, 212, 76 | HEX: #F6D44C
  static const Color jtvKuning = Color(0xFFF6D44C);

  // ============================================================
  // WARNA NETRAL (Neutral Colors)
  // ============================================================

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  /// Grey scale untuk background dan text
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ============================================================
  // WARNA SEMANTIC (Semantic Colors)
  // ============================================================

  /// Warna untuk status sukses
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);

  /// Warna untuk status error
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);

  /// Warna untuk status warning - menggunakan JTV Kuning
  static const Color warning = jtvKuning;
  static const Color warningLight = Color(0xFFFFF8E1);

  /// Warna untuk status info - menggunakan JTV Biru Toska
  static const Color info = jtvBiruToska;
  static const Color infoLight = Color(0xFFE0F7FA);

  // ============================================================
  // WARNA KHUSUS APLIKASI
  // ============================================================

  /// Background untuk dark mode
  static const Color darkBackground = Color(0xFF0A1929);
  static const Color darkSurface = Color(0xFF132F4C);

  /// Warna untuk live streaming badge
  static const Color liveBadge = jtvMerahJambu;

  /// Warna untuk featured/highlight items
  static const Color featured = jtvKuning;

  /// Warna untuk link text
  static const Color link = jtvBiruToska;
}
