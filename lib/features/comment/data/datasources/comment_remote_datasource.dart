import 'package:portal_jtv/core/constants/api_constants.dart';
import 'package:portal_jtv/core/error/exceptions.dart';
import 'package:portal_jtv/core/network/api_client.dart';
import 'package:portal_jtv/features/comment/data/models/comment_model.dart';
import 'package:portal_jtv/features/comment/data/models/toggle_like_result_model.dart';

abstract class CommentRemoteDataSource {
  Future<List<CommentModel>> getComments(int idBerita);

  Future<CommentModel> postComment({
    required int idBerita,
    required String content,
    int? parentId,
  });

  Future<bool> updateComment({required int id, required String content});

  Future<bool> deleteComment(int id);

  Future<ToggleLikeResultModel> toggleLike(int commentId);
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final ApiClient client;

  CommentRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CommentModel>> getComments(int idBerita) async {
    try {
      final response = await client.get(
        '${ApiConstants.comments}/$idBerita/comments',
      );
      final data = response.data;

      if (data['success'] == true && data['data'] != null) {
        return (data['data'] as List)
            .map((json) => CommentModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CommentModel> postComment({
    required int idBerita,
    required String content,
    int? parentId,
  }) async {
    try {
      final body = <String, dynamic>{'content': content};
      if (parentId != null) {
        body['parent_id'] = parentId;
      }

      final response = await client.post(
        '${ApiConstants.comments}/$idBerita/comments',
        data: body,
      );
      final data = response.data;

      return CommentModel.fromJson(data['data']);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> updateComment({
    required int id,
    required String content,
  }) async {
    try {
      final response = await client.put(
        '${ApiConstants.commentAction}/$id',
        data: {'content': content},
      );
      return response.data['success'] == true;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> deleteComment(int id) async {
    try {
      final response = await client.delete(
        '${ApiConstants.commentAction}/$id',
      );
      return response.data['success'] == true;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ToggleLikeResultModel> toggleLike(int commentId) async {
    try {
      final response = await client.post(
        '${ApiConstants.commentAction}/$commentId/like',
      );
      return ToggleLikeResultModel.fromJson(response.data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
