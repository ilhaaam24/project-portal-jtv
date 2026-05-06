import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import '../repositories/comment_repository.dart';

class UpdateComment implements UseCase<bool, UpdateCommentParams> {
  final CommentRepository repository;

  UpdateComment(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateCommentParams params) {
    return repository.updateComment(id: params.id, content: params.content);
  }
}

class UpdateCommentParams extends Equatable {
  final int id;
  final String content;

  const UpdateCommentParams({required this.id, required this.content});

  @override
  List<Object?> get props => [id, content];
}
