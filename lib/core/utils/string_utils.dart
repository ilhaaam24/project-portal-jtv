class StringUtils {
  static String getInitials(String name) {
    if (name.isEmpty) return 'A';
    
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      // Ambil karakter pertama dari kata pertama dan kata kedua
      final first = parts[0].isNotEmpty ? parts[0][0] : '';
      final second = parts[1].isNotEmpty ? parts[1][0] : '';
      return '$first$second'.toUpperCase();
    }
    
    // Jika hanya satu kata, ambil satu karakter pertama
    return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : 'A';
  }
}
