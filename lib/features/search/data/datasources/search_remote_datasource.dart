
import 'package:portal_jtv/core/error/exceptions.dart';
import 'package:portal_jtv/core/network/api_client.dart';
import 'package:portal_jtv/features/home/data/models/news_model.dart';

/// Wrapper result dari API search
class SearchRemoteResult {
  final List<NewsModel> news;
  final int currentPage;
  final int lastPage;
  final int total;

  SearchRemoteResult({
    required this.news,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}

abstract class SearchRemoteDataSource {
  Future<SearchRemoteResult> searchNews({
    required String keyword,
    int? limit,
    int? page,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient client;

  SearchRemoteDataSourceImpl({required this.client});

  @override
  Future<SearchRemoteResult> searchNews({
    required String keyword,
    int? limit,
    int? page,
  }) async {
    try {
      // Encode keyword untuk URL safety
      final encodedKeyword = Uri.encodeComponent(keyword);

      // Build query params
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (page != null) queryParams['page'] = page;

      final response = await client.get(
        '/news/search/$encodedKeyword',
        queryParameters: queryParams,
      );

      final data = response.data;

      // Parse news list
      final newsList = (data['data'] as List? ?? [])
          .map((json) => NewsModel.fromJson(json))
          .toList();

      // Parse pagination dari meta
      final meta = data['meta'] ?? {};

      return SearchRemoteResult(
        news: newsList,
        currentPage: meta['current_page'] ?? 1,
        lastPage: meta['last_page'] ?? 1,
        total: meta['total'] ?? newsList.length,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
