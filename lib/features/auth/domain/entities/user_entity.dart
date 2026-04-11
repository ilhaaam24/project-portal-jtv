import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String name;
  final String seo;
  final String biodata;
  final String photo;
  final String phone;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.seo,
    required this.biodata,
    required this.photo,
    required this.phone,
  });

  @override
  List<Object?> get props => [id, email, name, seo, biodata, photo, phone];
}
