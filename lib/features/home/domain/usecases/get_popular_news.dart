// lib/features/home/domain/usecases/get_populer.dart

import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';
import '../../../../core/error/failures.dart';

class GetPopuler implements UseCase<PaginatedNews, PopulerParams> {
  final HomeRepository repository;

  GetPopuler(this.repository);

  @override
  Future<Either<Failure, PaginatedNews>> call(PopulerParams params) {
    return repository.getPopulerNews(page: params.page, limit: params.limit);
  }
}

class PopulerParams {
  final int page;
  final int? limit;

  const PopulerParams({this.page = 1, this.limit = 10});
}
