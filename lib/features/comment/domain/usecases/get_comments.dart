import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class GetComments implements UseCase<List<CommentEntity>, int> {
  final CommentRepository repository;

  GetComments(this.repository);

  @override
  Future<Either<Failure, List<CommentEntity>>> call(int idBerita) {
    return repository.getComments(idBerita);
  }
}
