import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/exceptions.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/features/video_detail/data/datasources/video_remote_datasource.dart';
import 'package:portal_jtv/features/video_detail/domain/entities/paginated_videos.dart';
import 'package:portal_jtv/features/video_detail/domain/repositories/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource remoteDataSource;

  VideoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaginatedVideos>> getPaginatedVideos({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getPaginatedVideos(
        page: page,
        limit: limit,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message:e.message));
    }
  }
}
