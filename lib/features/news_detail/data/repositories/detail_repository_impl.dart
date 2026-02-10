import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/exceptions.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/features/news_detail/data/datasources/detail_remote_datasource.dart';
import 'package:portal_jtv/features/news_detail/domain/repositories/detail_repository.dart';

class DetailRepositoryImpl implements DetailRepository {
  final DetailRemoteDataSource remoteDataSource;

  DetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DetailResult>> getNewsDetail(String seo) async {
    try {
      final result = await remoteDataSource.getNewsDetail(seo);

      return Right(
        DetailResult(
          detail: result.detail.toEntity(),
          tags: result.tags.map((t) => t.toEntity()).toList(),
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> sendHitCounter({
    required String seo,
    required String tipe,
  }) async {
    try {
      final result = await remoteDataSource.sendHitCounter(
        seo: seo,
        tipe: tipe,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> checkBookmarkStatus(int idBerita) async {
    try {
      final result = await remoteDataSource.checkBookmarkStatus(idBerita);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> saveBookmark(int idBerita) async {
    try {
      final result = await remoteDataSource.saveBookmark(idBerita);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> removeBookmark(int idBerita) async {
    try {
      final result = await remoteDataSource.removeBookmark(idBerita);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }
}
