class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android Emulator
  // static const String baseUrl ='https://9474-114-8-224-253.ngrok-free.app/api'; 
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
  static const String fcmRegister = '/fcm/register';
  static const String fcmUnregister = '/fcm/unregister';
  static const String comments = '/berita'; // /berita/{id}/comments
  static const String commentAction = '/comments'; // /comments/{id}

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
