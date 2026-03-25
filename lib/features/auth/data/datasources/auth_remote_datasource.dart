import 'package:portal_jtv/features/auth/data/models/auth_model.dart';
import 'package:portal_jtv/core/network/api_client.dart';

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
        '/login', // Replace with actual login endpoint
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assume API returns data inside a 'data' object or directly
        final responseData = response.data['data'] ?? response.data;
        return AuthModel.fromJson(responseData);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}

// Ensure this Exception class exists or is created in your core/error folder
class ServerException implements Exception {}
