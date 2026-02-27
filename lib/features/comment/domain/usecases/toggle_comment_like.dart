import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import '../entities/toggle_like_result_entity.dart';
import '../repositories/comment_repository.dart';

class ToggleCommentLike implements UseCase<ToggleLikeResultEntity, int> {
  final CommentRepository repository;

  ToggleCommentLike(this.repository);

  @override
  Future<Either<Failure, ToggleLikeResultEntity>> call(int commentId) {
    return repository.toggleLike(commentId);
  }
}
