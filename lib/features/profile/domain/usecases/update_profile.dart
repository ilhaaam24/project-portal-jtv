import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfile implements UseCase<bool, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      nama: params.nama,
      email: params.email,
      phone: params.phone,
      password: params.password,
    );
  }
}

class UpdateProfileParams {
  final String nama;
  final String email;
  final String phone;
  final String? password; // Opsional, kosong jika tidak ganti

  const UpdateProfileParams({
    required this.nama,
    required this.email,
    required this.phone,
    this.password,
  });
}
