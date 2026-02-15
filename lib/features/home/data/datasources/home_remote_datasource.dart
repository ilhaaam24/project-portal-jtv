import 'package:portal_jtv/core/constants/api_constants.dart';
import 'package:portal_jtv/core/error/exceptions.dart';
import 'package:portal_jtv/core/network/api_client.dart';
import 'package:portal_jtv/features/home/data/models/category_model.dart';
import 'package:portal_jtv/features/home/data/models/for_you_model.dart';
import 'package:portal_jtv/features/home/data/models/news_model.dart';
import 'package:portal_jtv/features/home/data/models/pagination_model.dart';
import 'package:portal_jtv/features/home/data/models/sorot_model.dart';
import 'package:portal_jtv/features/home/data/models/video_model.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';

abstract class HomeRemoteDataSource {
  Future<List<NewsModel>> getBreakingNews({int limit = 3});
  Future<List<NewsModel>> getHeadlines({int limit = 5});
  Future<PaginatedNews> getPopularNews({int page = 1, int? limit});
  Future<ApiResponse<NewsModel>> getLatestNews({int page = 1, int limit = 10});
  Future<List<SorotModel>> getSorot({int limit = 5});
  Future<List<VideoModel>> getVideos({int limit = 5});
  Future<List<CategoryModel>> getCategories();
  Future<List<ForYouModel>> getForYou({int? limit});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient client;

  HomeRemoteDataSourceImpl({required this.client});

  @override
  Future<List<NewsModel>> getBreakingNews({int limit = 3}) async {
    try {
      final response = await client.get(
        '${ApiConstants.breaking}/portal-jtv',
        queryParameters: {'limit': limit},
      );

      final data = response.data['data'] as List?;
      if (data == null) return [];

      return data.map((json) => NewsModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<NewsModel>> getHeadlines({int limit = 5}) async {
    try {
      final response = await client.get(
        '${ApiConstants.headlines}/portal-jtv',
        queryParameters: {'limit': limit},
      );

      final data = response.data['data'] as List?;
      if (data == null) return [];

      return data.map((json) => NewsModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PaginatedNews> getPopularNews({int page = 1, int? limit}) async {
    try {
      final queryParams = <String, dynamic>{'page': page};
      if (limit != null) queryParams['limit'] = limit;
      final response = await client.get(
        '/news/populer/portal-jtv',
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
  Future<ApiResponse<NewsModel>> getLatestNews({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await client.get(
        '${ApiConstants.latest}/portal-jtv',
        queryParameters: {'page': page, 'limit': limit},
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => NewsModel.fromJson(json),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<SorotModel>> getSorot({int limit = 5}) async {
    try {
      final response = await client.get(
        ApiConstants.sorot,
        queryParameters: {'limit': limit},
      );

      final data = response.data['data'] as List?;
      if (data == null) return [];

      return data.map((json) => SorotModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<VideoModel>> getVideos({int limit = 5}) async {
    try {
      final response = await client.get(
        ApiConstants.videos,
        queryParameters: {'limit': limit},
      );

      final data = response.data['data'] as List?;
      if (data == null) return [];

      return data.map((json) => VideoModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await client.get(ApiConstants.categories);

      final data = response.data['data'] as List?;
      if (data == null) return [];

      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ForYouModel>> getForYou({int? limit}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      final response = await client.get(
        '/news/for-you',
        queryParameters: queryParams,
      );
      final dataList = response.data['data'] as List? ?? [];
      return dataList.map((json) => ForYouModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
