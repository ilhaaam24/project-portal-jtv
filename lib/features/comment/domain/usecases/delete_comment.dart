import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import '../repositories/comment_repository.dart';

class DeleteComment implements UseCase<bool, int> {
  final CommentRepository repository;

  DeleteComment(this.repository);

  @override
  Future<Either<Failure, bool>> call(int id) {
    return repository.deleteComment(id);
  }
}
