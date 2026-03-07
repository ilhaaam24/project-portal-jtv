import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/news_detail/domain/repositories/detail_repository.dart';

class GetRelatedNews
    implements UseCase<List<NewsEntity>, GetRelatedNewsParams> {
  DetailRepository detailRepository;
  GetRelatedNews(this.detailRepository);
  @override
  Future<Either<Failure, List<NewsEntity>>> call(GetRelatedNewsParams params) {
    return detailRepository.getRelatedNews(
      limit: params.limit,
      seoCategory: params.seoCategory,
    );
  }
}

class GetRelatedNewsParams extends Equatable {
  final int limit;
  final String seoCategory;
  const GetRelatedNewsParams({required this.limit, required this.seoCategory});
  @override
  List<Object?> get props => [limit, seoCategory];
}
