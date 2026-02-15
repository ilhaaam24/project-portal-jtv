import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/exceptions.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/features/search/data/datasources/search_remote_datasource.dart';
import 'package:portal_jtv/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SearchResult>> searchNews({
    required String keyword,
    int? limit,
    int? page,
  }) async {
    try {
      final result = await remoteDataSource.searchNews(
        keyword: keyword,
        limit: limit,
        page: page,
      );

      return Right(
        SearchResult(
          news: result.news,
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          total: result.total,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }
}
