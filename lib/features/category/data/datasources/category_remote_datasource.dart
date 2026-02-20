// lib/features/category/data/datasources/category_remote_datasource.dart

import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/category_model.dart';
import '../models/biro_model.dart';
import '../../../home/data/models/news_model.dart';

class CategoryPageRaw {
  final List<CategoryModel> categories;
  final List<BiroModel> biros;

  CategoryPageRaw({required this.categories, required this.biros});
}

abstract class CategoryRemoteDataSource {
  Future<CategoryPageRaw> getCategories();
  Future<PaginatedNews> getNewsByCategory({
    required String seo,
    int page,
    int? limit,
  });
  Future<PaginatedNews> getNewsByBiro({
    required String seo,
    int page,
    int? limit,
  });
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiClient client;

  CategoryRemoteDataSourceImpl({required this.client});

  @override
  Future<CategoryPageRaw> getCategories() async {
    try {
      final response = await client.get('/navbar/kategori');
      final data = response.data;

      // Kategori dari "data"
      final categoryList = (data['data'] as List? ?? [])
          .map((json) => CategoryModel.fromJson(json))
          .toList();

      // Biro dari "biro" (additional field)
      final biroList = (data['biro'] as List? ?? [])
          .map((json) => BiroModel.fromJson(json))
          .toList();

      return CategoryPageRaw(categories: categoryList, biros: biroList);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PaginatedNews> getNewsByCategory({
    required String seo,
    int page = 1,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page};
      if (limit != null) queryParams['limit'] = limit;

      final response = await client.get(
        '/news/kategori/$seo',
        queryParameters: queryParams,
      );

      final data = response.data;
      final dataList = data['data'] as List? ?? [];
      final meta = data['meta'] ?? {};

      return PaginatedNews(
        news: dataList.map((json) => NewsModel.fromJson(json)).toList(),
        currentPage: meta['current_page'] ?? page,
        lastPage: meta['last_page'] ?? 1,
        total: meta['total'] ?? dataList.length,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PaginatedNews> getNewsByBiro({
    required String seo,
    int page = 1,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page};
      if (limit != null) queryParams['limit'] = limit;

      final response = await client.get(
        '/news/kanal/$seo',
        queryParameters: queryParams,
      );

      final data = response.data;
      final dataList = data['data'] as List? ?? [];
      final meta = data['meta'] ?? {};

      return PaginatedNews(
        news: dataList.map((json) => NewsModel.fromJson(json)).toList(),
        currentPage: meta['current_page'] ?? page,
        lastPage: meta['last_page'] ?? 1,
        total: meta['total'] ?? dataList.length,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
