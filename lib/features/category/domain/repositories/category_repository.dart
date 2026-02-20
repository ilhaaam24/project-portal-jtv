
import 'package:dartz/dartz.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';
import '../../../../core/error/failures.dart';
import '../entities/category_entity.dart';
import '../entities/biro_entity.dart';

/// Response wrapper karena 1 endpoint return kategori + biro
class CategoryPageData {
  final List<CategoryEntity> categories;
  final List<BiroEntity> biros;

  const CategoryPageData({required this.categories, required this.biros});
}

abstract class CategoryRepository {
  /// GET /api/navbar/kategori — return kategori + biro sekaligus
  Future<Either<Failure, CategoryPageData>> getCategories();

  /// GET /api/news/kategori/{seo} — berita per kategori
  Future<Either<Failure, PaginatedNews>> getNewsByCategory({
    required String seo,
    int page = 1,
    int? limit,
  });

  /// GET /api/news/kanal/{seo} — berita per biro
  Future<Either<Failure, PaginatedNews>> getNewsByBiro({
    required String seo,
    int page = 1,
    int? limit,
  });
}
