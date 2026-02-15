
import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();

  Future<Either<Failure, bool>> updateProfile({
    required String nama,
    required String email,
    required String phone,
    String? password,
  });

  Future<Either<Failure, bool>> logout();
}
