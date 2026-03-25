import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/auth/domain/entities/auth_entity.dart';
import 'package:portal_jtv/features/auth/domain/repositories/auth_repository.dart';

class GetSavedAuth implements UseCase<AuthEntity, NoParams> {
  final AuthRepository repository;

  GetSavedAuth(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(NoParams params) async {
    return await repository.getSavedAuth();
  }
}
