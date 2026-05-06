import 'package:portal_jtv/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.seo,
    required super.biodata,
    required super.photo,
    required super.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      seo: json['seo'] ?? '',
      biodata: json['biodata'] ?? '',
      photo: json['photo'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'seo': seo,
      'biodata': biodata,
      'photo': photo,
      'phone': phone,
    };
  }
}
