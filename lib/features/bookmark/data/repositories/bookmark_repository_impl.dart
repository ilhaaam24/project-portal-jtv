import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/exceptions.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/features/bookmark/data/datasources/bookmark_remote_datasource.dart';
import 'package:portal_jtv/features/bookmark/domain/entities/saved_news_entity.dart';
import 'package:portal_jtv/features/bookmark/domain/repositories/bookmark_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkRemoteDataSource remoteDataSource;

  BookmarkRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SavedNewsEntity>>> getSavedNewsList() async {
    try {
      final result = await remoteDataSource.getSavedNewsList();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSavedNews(int idBerita) async {
    try {
      final result = await remoteDataSource.deleteSavedNews(idBerita);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }
}
