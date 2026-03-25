import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences _prefs;

  AuthInterceptor(this._prefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // final token = _prefs.getString('auth_token');
    final token = "89|NqA6vhI5ZY5e60Z8d709Sz9ojbAZ6dnyDK7Jf9Rs247f11b5";

    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401) {
      // Token expired / invalid
      _prefs.remove('auth_token');
    }

    handler.next(err);
  }
}
