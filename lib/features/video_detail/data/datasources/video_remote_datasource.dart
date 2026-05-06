import 'package:portal_jtv/core/constants/api_constants.dart';
import 'package:portal_jtv/core/error/exceptions.dart';
import 'package:portal_jtv/core/network/api_client.dart';
import 'package:portal_jtv/features/home/data/models/video_model.dart';
import 'package:portal_jtv/features/video_detail/domain/entities/paginated_videos.dart';

abstract class VideoRemoteDataSource {
  Future<PaginatedVideos> getPaginatedVideos({int page = 1, int limit = 10});
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final ApiClient client;

  VideoRemoteDataSourceImpl({required this.client});

  @override
  Future<PaginatedVideos> getPaginatedVideos({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await client.get(
        ApiConstants.videos,
        queryParameters: {'page': page, 'limit': limit},
      );

      final data = response.data;
      final dataList = data['data'] as List? ?? [];
      final meta = data['meta'] ?? {};

      return PaginatedVideos(
        videos: dataList.map((json) => VideoModel.fromJson(json)).toList(),
        currentPage: meta['current_page'] ?? page,
        lastPage: meta['last_page'] ?? 1,
        total: meta['total'] ?? dataList.length,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
