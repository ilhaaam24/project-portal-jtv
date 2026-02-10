
import 'package:portal_jtv/core/constants/api_constants.dart';
import 'package:portal_jtv/core/error/exceptions.dart';
import 'package:portal_jtv/core/network/api_client.dart';
import 'package:portal_jtv/features/news_detail/data/models/news_detail_model.dart';
import 'package:portal_jtv/features/news_detail/data/models/tag_model.dart';

abstract class DetailRemoteDataSource {
  /// Ambil detail berita + tags
  Future<DetailRemoteResult> getNewsDetail(String seo);

  Future<bool> sendHitCounter({required String seo, required String tipe});

  Future<bool> checkBookmarkStatus(int idBerita);

  Future<bool> saveBookmark(int idBerita);

  Future<bool> removeBookmark(int idBerita);
}

/// Wrapper untuk result dari API detail
class DetailRemoteResult {
  final NewsDetailModel detail;
  final List<TagModel> tags;

  DetailRemoteResult({required this.detail, required this.tags});
}

class DetailRemoteDataSourceImpl implements DetailRemoteDataSource {
  final ApiClient client;

  DetailRemoteDataSourceImpl({required this.client});

  @override
  Future<DetailRemoteResult> getNewsDetail(String seo) async {
    try {
      final response = await client.get('${ApiConstants.newsDetail}/$seo');
      final data = response.data;

      // Parse detail berita dari 'data'
      final detail = NewsDetailModel.fromJson(data['data']);

      // Parse tags dari response level atas
      // Backend menaruh tags di response.tags (dari additional())
      List<TagModel> tags = [];
      if (data['tags'] != null) {
        tags = (data['tags'] as List)
            .map((json) => TagModel.fromJson(json))
            .toList();
      }

      return DetailRemoteResult(detail: detail, tags: tags);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> sendHitCounter({
    required String seo,
    required String tipe,
  }) async {
    try {
      final response = await client.post(
        '/hit',
        data: {'id': seo, 'mode': 'production', 'tipe': tipe},
      );

      return response.data['status'] == 'success';
    } catch (e) {
      // Hit counter gagal bukan masalah fatal, return false saja
      return false;
    }
  }

  @override
  Future<bool> checkBookmarkStatus(int idBerita) async {
    try {
      final response = await client.get('/saved-news/check/$idBerita');
      return response.data['is_saved'] ?? false;
    } catch (e) {
      // Jika gagal (misal belum login), anggap belum disimpan
      return false;
    }
  }

  @override
  Future<bool> saveBookmark(int idBerita) async {
    try {
      final response = await client.post('/saved-news/$idBerita');
      return response.data['is_saved'] ?? true;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> removeBookmark(int idBerita) async {
    try {
      // DELETE request - perlu tambah method delete di ApiClient
      final response = await client.delete('/saved-news/$idBerita');
      return !(response.data['is_saved'] ?? false);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
