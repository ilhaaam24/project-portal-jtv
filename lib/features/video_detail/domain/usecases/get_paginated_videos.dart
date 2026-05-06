import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/video_detail/domain/entities/paginated_videos.dart';
import 'package:portal_jtv/features/video_detail/domain/repositories/video_repository.dart';

class GetPaginatedVideos
    implements UseCase<PaginatedVideos, PaginatedVideosParams> {
  final VideoRepository repository;
  GetPaginatedVideos(this.repository);

  @override
  Future<Either<Failure, PaginatedVideos>> call(PaginatedVideosParams params) {
    return repository.getPaginatedVideos(
      page: params.page,
      limit: params.limit,
    );
  }
}

class PaginatedVideosParams {
  final int page;
  final int limit;

  PaginatedVideosParams({this.page = 1, this.limit = 10});
}
