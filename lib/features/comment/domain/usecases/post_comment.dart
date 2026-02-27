import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class PostComment implements UseCase<CommentEntity, PostCommentParams> {
  final CommentRepository repository;

  PostComment(this.repository);

  @override
  Future<Either<Failure, CommentEntity>> call(PostCommentParams params) {
    return repository.postComment(
      idBerita: params.idBerita,
      content: params.content,
      parentId: params.parentId,
    );
  }
}

class PostCommentParams extends Equatable {
  final int idBerita;
  final String content;
  final int? parentId;

  const PostCommentParams({
    required this.idBerita,
    required this.content,
    this.parentId,
  });

  @override
  List<Object?> get props => [idBerita, content, parentId];
}
