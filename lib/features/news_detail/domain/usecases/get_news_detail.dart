import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/news_detail/domain/repositories/detail_repository.dart';

class GetNewsDetail implements UseCase<DetailResult, String> {
  final DetailRepository repository;

  GetNewsDetail(this.repository);

  @override
  Future<Either<Failure, DetailResult>> call(String seo) {
    return repository.getNewsDetail(seo);
  }
}
