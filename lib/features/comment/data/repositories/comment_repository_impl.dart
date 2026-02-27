import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/exceptions.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/features/comment/data/datasources/comment_remote_datasource.dart';
import 'package:portal_jtv/features/comment/domain/entities/comment_entity.dart';
import 'package:portal_jtv/features/comment/domain/entities/toggle_like_result_entity.dart';
import 'package:portal_jtv/features/comment/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CommentEntity>>> getComments(
    int idBerita,
  ) async {
    try {
      final models = await remoteDataSource.getComments(idBerita);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, CommentEntity>> postComment({
    required int idBerita,
    required String content,
    int? parentId,
  }) async {
    try {
      final model = await remoteDataSource.postComment(
        idBerita: idBerita,
        content: content,
        parentId: parentId,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> updateComment({
    required int id,
    required String content,
  }) async {
    try {
      final result = await remoteDataSource.updateComment(
        id: id,
        content: content,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteComment(int id) async {
    try {
      final result = await remoteDataSource.deleteComment(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ToggleLikeResultEntity>> toggleLike(
    int commentId,
  ) async {
    try {
      final result = await remoteDataSource.toggleLike(commentId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }
}
