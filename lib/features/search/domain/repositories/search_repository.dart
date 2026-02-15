import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';

class SearchResult {
  final List<NewsEntity> news;
  final int currentPage;
  final int lastPage;
  final int total;

  const SearchResult({
    required this.news,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  bool get hasReachedMax => currentPage >= lastPage;
}

abstract class SearchRepository {
  Future<Either<Failure, SearchResult>> searchNews({
    required String keyword,
    int? limit,
    int? page,
  });
}
