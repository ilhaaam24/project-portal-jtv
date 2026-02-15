import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String nama;
  final String photo;
  final String email;
  final String? phone;
  final String seo;

  const ProfileEntity({
    required this.nama,
    required this.photo,
    required this.email,
    this.phone,
    required this.seo,
  });

  @override
  List<Object?> get props => [nama, photo, email, phone, seo];
}
