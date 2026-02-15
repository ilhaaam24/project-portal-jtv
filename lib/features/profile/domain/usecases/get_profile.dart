// lib/features/profile/domain/usecases/get_profile.dart

import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/profile/domain/entities/profile_entity.dart';
import 'package:portal_jtv/features/profile/domain/repositories/profile_repository.dart';

class GetProfile implements UseCase<ProfileEntity, NoParams> {
  final ProfileRepository repository;

  GetProfile(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(NoParams params) {
    return repository.getProfile();
  }
}
