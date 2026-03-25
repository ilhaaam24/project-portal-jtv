import 'package:portal_jtv/features/auth/data/models/auth_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<AuthModel?> getAuth();
  Future<void> saveAuth(AuthModel authToCache);
  Future<void> clearAuth();
}

const cachedAuthDataKey = 'CACHED_AUTH_DATA';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<AuthModel?> getAuth() async {
    final authJsonString = await secureStorage.read(key: cachedAuthDataKey);

    if (authJsonString != null && authJsonString.isNotEmpty) {
      try {
        return AuthModel.fromJsonString(authJsonString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> saveAuth(AuthModel authToCache) async {
    await secureStorage.write(
      key: cachedAuthDataKey,
      value: authToCache.toJsonString(),
    );
  }

  @override
  Future<void> clearAuth() async {
    await secureStorage.delete(key: cachedAuthDataKey);
  }
}
