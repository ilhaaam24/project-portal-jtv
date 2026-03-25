import 'package:portal_jtv/features/auth/domain/entities/auth_entity.dart';
import 'package:portal_jtv/features/auth/data/models/user_model.dart';
import 'dart:convert';

class AuthModel extends AuthEntity {
  const AuthModel({required super.token, required super.user});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'user': (user as UserModel).toJson()};
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory AuthModel.fromJsonString(String jsonString) {
    return AuthModel.fromJson(jsonDecode(jsonString));
  }
}
