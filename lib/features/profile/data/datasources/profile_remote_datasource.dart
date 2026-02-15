// lib/features/profile/data/datasources/profile_remote_datasource.dart

import 'package:portal_jtv/core/error/exceptions.dart';
import 'package:portal_jtv/core/network/api_client.dart';
import 'package:portal_jtv/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<bool> updateProfile({
    required String nama,
    required String email,
    required String phone,
    String? password,
  });
  Future<bool> logout();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient client;

  ProfileRemoteDataSourceImpl({required this.client});

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await client.get('/akun/profile');
      return ProfileModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> updateProfile({
    required String nama,
    required String email,
    required String phone,
    String? password,
  }) async {
    try {
      final body = <String, dynamic>{
        'nama': nama,
        'email': email,
        'phone': phone,
      };

      // Hanya kirim password jika user mengisi
      if (password != null && password.isNotEmpty) {
        body['password'] = password;
      }

      final response = await client.post('/akun/update', data: body);
      return response.data['status'] == 'success';
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> logout() async {
    try {
      final response = await client.post('/auth/logout');
      return response.data['status'] == 'success';
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
