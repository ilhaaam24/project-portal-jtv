import 'package:portal_jtv/features/auth/data/models/auth_model.dart';
import 'package:portal_jtv/core/network/api_client.dart';
import 'package:portal_jtv/core/constants/api_constants.dart';
import 'package:portal_jtv/core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final responseMap = response.data as Map<String, dynamic>;

      if (responseMap['status'] == 'success') {
        return AuthModel.fromJson(responseMap);
      } else {
        throw ServerException(
          message: responseMap['message'] ?? 'Gagal masuk akun',
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
