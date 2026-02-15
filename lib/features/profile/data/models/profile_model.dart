

import 'package:portal_jtv/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.nama,
    required super.photo,
    required super.email,
    super.phone,
    required super.seo,
  });

  /// Mapping dari response GET /api/akun/profile
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      nama: json['nama'] ?? '',
      photo: json['photo'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      seo: json['seo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'photo': photo,
      'email': email,
      'phone': phone,
      'seo': seo,
    };
  }

  ProfileEntity toEntity() => this;
}
