import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/features/home/domain/entities/category_entity.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/home/domain/entities/sorot_entity.dart';
import 'package:portal_jtv/features/home/domain/entities/video_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<NewsEntity>>> getBreakingNews({int limit = 3});

  Future<Either<Failure, List<NewsEntity>>> getHeadlines({int limit = 5});

  Future<Either<Failure, List<NewsEntity>>> getPopularNews({int limit = 5});

  Future<Either<Failure, PaginatedNews>> getLatestNews({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<SorotEntity>>> getSorot({int limit = 5});

  Future<Either<Failure, List<VideoEntity>>> getVideos({int limit = 5});

  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}

class PaginatedNews extends Equatable {
  final List<NewsEntity> news;
  final int currentPage;
  final int lastPage;
  final int total;

  const PaginatedNews({
    required this.news,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  bool get hasNextPage => currentPage < lastPage;

  @override
  List<Object?> get props => [news, currentPage, lastPage, total];
}
