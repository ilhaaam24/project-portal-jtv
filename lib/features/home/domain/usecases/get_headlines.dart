import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';

class GetHeadlines implements UseCase<List<NewsEntity>, HeadlinesParams> {
  final HomeRepository homeRepository;
  GetHeadlines(this.homeRepository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call(HeadlinesParams params) {
    return homeRepository.getHeadlines(limit: params.limit);
  }
}

class HeadlinesParams {
  final int limit;
  const HeadlinesParams({this.limit = 5});
}
