import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';

class GetLatestNews implements UseCase<PaginatedNews, LatestNewsParams> {
  final HomeRepository homeRepository;
  const GetLatestNews(this.homeRepository);
  @override
  Future<Either<Failure, PaginatedNews>> call(LatestNewsParams params) {
    return homeRepository.getLatestNews(limit: params.limit, page: params.page);
  }
}

class LatestNewsParams {
  final int limit;
  final int page;
  const LatestNewsParams({this.limit = 10, this.page = 1});
}
