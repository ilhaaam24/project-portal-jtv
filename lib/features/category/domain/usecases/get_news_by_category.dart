// lib/features/category/domain/usecases/get_news_by_category.dart

import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';
import '../../../../core/error/failures.dart';
import '../repositories/category_repository.dart';

class GetNewsByCategory implements UseCase<PaginatedNews, CategoryNewsParams> {
  final CategoryRepository repository;

  GetNewsByCategory(this.repository);

  @override
  Future<Either<Failure, PaginatedNews>> call(CategoryNewsParams params) {
    if (params.isBiro) {
      return repository.getNewsByBiro(
        seo: params.seo,
        page: params.page,
        limit: params.limit,
      );
    }
    return repository.getNewsByCategory(
      seo: params.seo,
      page: params.page,
      limit: params.limit,
    );
  }
}

class CategoryNewsParams {
  final String seo;
  final int page;
  final int? limit;
  final bool isBiro; // true = biro, false = kategori

  const CategoryNewsParams({
    required this.seo,
    this.page = 1,
    this.limit = 10,
    this.isBiro = false,
  });
}
