class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android Emulator
  // static const String baseUrl = 'http://localhost:8000/api'; // iOS Simulator

  // Endpoints
  static const String headlines = '/news/headline';
  static const String breaking = '/news/breaking';
  static const String latest = '/news/terbaru';
  static const String popular = '/news/populer';
  static const String sorot = '/sorot';
  static const String videos = '/video';
  static const String categories = '/navbar/kategori';
  static const String newsDetail = '/news/detail';
  static const String hit = '/hit';
  static const String savedNews = '/saved-news';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
