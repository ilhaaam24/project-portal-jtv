import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences _prefs;

  AuthInterceptor(this._prefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // final token = _prefs.getString('auth_token');
    final token = "85|OUdujMKqMCk7uQXQhYHxMeRBIHu0nbicMpecDe8b0d7f19cf";

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
