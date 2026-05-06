import 'package:portal_jtv/features/auth/domain/entities/auth_entity.dart';
import 'package:portal_jtv/features/auth/data/models/user_model.dart';
import 'dart:convert';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.accessToken,
    required super.refreshToken,
    required super.user,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      user: UserModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'data': (user as UserModel).toJson(),
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory AuthModel.fromJsonString(String jsonString) {
    return AuthModel.fromJson(jsonDecode(jsonString));
  }
}
