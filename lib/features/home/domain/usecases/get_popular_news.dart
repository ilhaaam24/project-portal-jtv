import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';

class GetPopularNews implements UseCase<List<NewsEntity>, PopularNewsParams> {
  final HomeRepository homeRepository;
  GetPopularNews(this.homeRepository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call(PopularNewsParams params) {
    return homeRepository.getPopularNews(limit: params.limit);
  }
}

class PopularNewsParams {
  final int limit;
  PopularNewsParams({this.limit = 5});
}
