import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/exceptions.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/features/home/data/datasources/home_remote_datasource.dart';
import 'package:portal_jtv/features/home/domain/entities/category_entity.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/home/domain/entities/sorot_entity.dart';
import 'package:portal_jtv/features/home/domain/entities/video_entity.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NewsEntity>>> getBreakingNews({
    int limit = 3,
  }) async {
    try {
      final result = await remoteDataSource.getBreakingNews(limit: limit);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getHeadlines({
    int limit = 5,
  }) async {
    try {
      final result = await remoteDataSource.getHeadlines(limit: limit);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<NewsEntity>>> getPopularNews({
    int limit = 5,
  }) async {
    try {
      final result = await remoteDataSource.getPopularNews(limit: limit);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, PaginatedNews>> getLatestNews({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getLatestNews(
        page: page,
        limit: limit,
      );

      final paginatedNews = PaginatedNews(
        news: result.data.map((model) => model.toEntity()).toList(),
        currentPage: result.meta?.currentPage ?? page,
        lastPage: result.meta?.lastPage ?? 1,
        total: result.meta?.total ?? result.data.length,
      );

      return Right(paginatedNews);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<SorotEntity>>> getSorot({int limit = 5}) async {
    try {
      final result = await remoteDataSource.getSorot(limit: limit);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<VideoEntity>>> getVideos({int limit = 5}) async {
    try {
      final result = await remoteDataSource.getVideos(limit: limit);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final result = await remoteDataSource.getCategories();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }
}
