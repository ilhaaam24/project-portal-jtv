import 'package:dartz/dartz.dart';
import 'package:portal_jtv/core/error/failures.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/home/domain/entities/video_entity.dart';
import 'package:portal_jtv/features/home/domain/repositories/home_respository.dart';

class GetVideos implements UseCase<List<VideoEntity>, VideosParams> {
  final HomeRepository homeRepository;
  GetVideos(this.homeRepository);

  @override
  Future<Either<Failure, List<VideoEntity>>> call(VideosParams params) {
    return homeRepository.getVideos(limit: params.limit);
  }
}

class VideosParams {
  final int limit;

  VideosParams({this.limit = 5});
}
