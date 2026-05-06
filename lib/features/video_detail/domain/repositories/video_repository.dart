import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/features/video_detail/domain/entities/paginated_videos.dart';

abstract class VideoRepository {
  Future<Either<Failure, PaginatedVideos>> getPaginatedVideos({
    int page = 1,
    int limit = 10,
  });
}
