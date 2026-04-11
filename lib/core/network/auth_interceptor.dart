import 'package:dio/dio.dart';
import 'package:portal_jtv/features/auth/data/datasources/auth_local_datasource.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource _localDataSource;

  AuthInterceptor(this._localDataSource);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final authModel = await _localDataSource.getAuth();
    final token = authModel?.accessToken ?? '';

    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized
    if (err.response?.statusCode == 401) {
      // Token expired / invalid
      await _localDataSource.clearAuth();
    }

    handler.next(err);
  }
}
