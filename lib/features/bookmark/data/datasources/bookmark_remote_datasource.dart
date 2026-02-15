import 'package:portal_jtv/core/error/exceptions.dart';
import 'package:portal_jtv/core/network/api_client.dart';
import 'package:portal_jtv/features/bookmark/data/models/saved_news_model.dart';

abstract class BookmarkRemoteDataSource {
  Future<List<SavedNewsModel>> getSavedNewsList();

  Future<bool> deleteSavedNews(int idBerita);
}

class BookmarkRemoteDataSourceImpl implements BookmarkRemoteDataSource {
  final ApiClient client;

  BookmarkRemoteDataSourceImpl({required this.client});

  @override
  Future<List<SavedNewsModel>> getSavedNewsList() async {
    try {
      final response = await client.get('/saved-news');

      final data = response.data['data'] as List?;
      if (data == null) return [];

      return data.map((json) => SavedNewsModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> deleteSavedNews(int idBerita) async {
    try {
      final response = await client.delete('/saved-news/$idBerita');
      // Backend returns: {"message": "Berita berhasil dihapus...", "is_saved": false}
      return !(response.data['is_saved'] ?? false);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
