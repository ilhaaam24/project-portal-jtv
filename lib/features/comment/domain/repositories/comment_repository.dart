import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/comment_entity.dart';
import '../entities/toggle_like_result_entity.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<CommentEntity>>> getComments(int idBerita);

  Future<Either<Failure, CommentEntity>> postComment({
    required int idBerita,
    required String content,
    int? parentId,
  });

  Future<Either<Failure, bool>> updateComment({
    required int id,
    required String content,
  });

  Future<Either<Failure, bool>> deleteComment(int id);

  Future<Either<Failure, ToggleLikeResultEntity>> toggleLike(int commentId);
}
