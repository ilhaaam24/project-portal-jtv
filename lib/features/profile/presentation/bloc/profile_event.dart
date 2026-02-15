import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Load profile dari API
class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

/// Update profile
class UpdateProfileSubmit extends ProfileEvent {
  final String nama;
  final String email;
  final String phone;
  final String? password;

  const UpdateProfileSubmit({
    required this.nama,
    required this.email,
    required this.phone,
    this.password,
  });

  @override
  List<Object?> get props => [nama, email, phone, password];
}

/// Logout
class LogoutRequested extends ProfileEvent {
  const LogoutRequested();
}
