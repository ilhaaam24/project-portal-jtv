import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';

class GetBreakingNews implements UseCase<List<NewsEntity>, BreakingNewsParams> {
  final HomeRepository homeRepository;
  GetBreakingNews(this.homeRepository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call(BreakingNewsParams params) {
    return homeRepository.getBreakingNews(limit: params.limit);
  }
}

class BreakingNewsParams {
  final int limit;
  const BreakingNewsParams({this.limit = 3});
}
