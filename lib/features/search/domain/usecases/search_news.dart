import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/search/domain/repositories/search_repository.dart';

class SearchNews implements UseCase<SearchResult, SearchNewsParams> {
  final SearchRepository repository;

  SearchNews(this.repository);

  @override
  Future<Either<Failure, SearchResult>> call(SearchNewsParams params) {
    return repository.searchNews(
      keyword: params.keyword,
      limit: params.limit,
      page: params.page,
    );
  }
}

class SearchNewsParams extends Equatable {
  final String keyword;
  final int? limit;
  final int? page;

  const SearchNewsParams({required this.keyword, this.limit, this.page});

  @override
  List<Object?> get props => [keyword, limit, page];
}
