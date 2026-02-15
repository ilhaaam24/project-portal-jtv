// lib/features/profile/domain/usecases/logout.dart

import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/profile/domain/repositories/profile_repository.dart';

class Logout implements UseCase<bool, NoParams> {
  final ProfileRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.logout();
  }
}
