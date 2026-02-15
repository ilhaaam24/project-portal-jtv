// lib/features/home/domain/usecases/get_for_you.dart

import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';
import '../../../../core/error/failures.dart';
import '../entities/for_you_entity.dart';

class GetForYou implements UseCase<List<ForYouEntity>, ForYouParams> {
  final HomeRepository repository;

  GetForYou(this.repository);

  @override
  Future<Either<Failure, List<ForYouEntity>>> call(ForYouParams params) {
    return repository.getForYou(limit: params.limit);
  }
}

class ForYouParams {
  final int? limit;
  const ForYouParams({this.limit = 10});
}
