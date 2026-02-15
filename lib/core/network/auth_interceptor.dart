import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences _prefs;

  AuthInterceptor(this._prefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // final token = _prefs.getString('auth_token');
    final token = "89|s50rMbFHAfLZ6CkI4cCV0LthzJgOwWzqWW9769jhee957fdb";

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
