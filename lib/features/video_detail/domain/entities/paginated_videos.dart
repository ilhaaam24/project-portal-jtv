import 'package:equatable/equatable.dart';
import 'package:portal_jtv/features/home/domain/entities/video_entity.dart';

class PaginatedVideos extends Equatable {
  final List<VideoEntity> videos;
  final int currentPage;
  final int lastPage;
  final int total;

  const PaginatedVideos({
    required this.videos,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  bool get hasNextPage => currentPage < lastPage;

  @override
  List<Object?> get props => [videos, currentPage, lastPage, total];
}
