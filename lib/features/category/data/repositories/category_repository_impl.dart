// lib/features/category/data/repositories/category_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:portal_jtv/features/category/domain/repositories/category_repository.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CategoryPageData>> getCategories() async {
    try {
      final result = await remoteDataSource.getCategories();
      return Right(
        CategoryPageData(
          categories: result.categories.map((e) => e.toEntity()).toList(),
          biros: result.biros.map((e) => e.toEntity()).toList(),
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message:e.message));
    }
  }

  @override
  Future<Either<Failure, PaginatedNews>> getNewsByCategory({
    required String seo,
    int page = 1,
    int? limit,
  }) async {
    try {
      final result = await remoteDataSource.getNewsByCategory(
        seo: seo,
        page: page,
        limit: limit,
      );
      return Right(
        PaginatedNews(
          news: result.news,
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          total: result.total,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message:e.message));
    }
  }

  @override
  Future<Either<Failure, PaginatedNews>> getNewsByBiro({
    required String seo,
    int page = 1,
    int? limit,
  }) async {
    try {
      final result = await remoteDataSource.getNewsByBiro(
        seo: seo,
        page: page,
        limit: limit,
      );
      return Right(
        PaginatedNews(
          news: result.news,
          currentPage: result.currentPage,
          lastPage: result.lastPage,
          total: result.total,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message:e.message));
    }
  }
}
