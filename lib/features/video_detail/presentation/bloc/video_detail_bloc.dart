import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:portal_jtv/features/home/domain/entities/video_entity.dart';
import 'package:portal_jtv/features/video_detail/domain/usecases/get_paginated_videos.dart';

// ─── EVENTS ─────────────────────────────────────────────────
abstract class VideoDetailEvent extends Equatable {
  const VideoDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load initial videos (with pre-loaded list from homepage)
class LoadInitialVideos extends VideoDetailEvent {
  final List<VideoEntity> initialVideos;
  final int initialIndex;

  const LoadInitialVideos({
    required this.initialVideos,
    required this.initialIndex,
  });

  @override
  List<Object?> get props => [initialVideos, initialIndex];
}

/// Load more videos (infinite scroll)
class LoadMoreVideos extends VideoDetailEvent {
  const LoadMoreVideos();
}

// ─── STATE ──────────────────────────────────────────────────
enum VideoDetailStatus { initial, loading, success, failure }

class VideoDetailState extends Equatable {
  final VideoDetailStatus status;
  final List<VideoEntity> videos;
  final int initialIndex;
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? errorMessage;

  const VideoDetailState({
    this.status = VideoDetailStatus.initial,
    this.videos = const [],
    this.initialIndex = 0,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  VideoDetailState copyWith({
    VideoDetailStatus? status,
    List<VideoEntity>? videos,
    int? initialIndex,
    int? currentPage,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return VideoDetailState(
      status: status ?? this.status,
      videos: videos ?? this.videos,
      initialIndex: initialIndex ?? this.initialIndex,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    videos,
    initialIndex,
    currentPage,
    hasReachedMax,
    isLoadingMore,
    errorMessage,
  ];
}

// ─── BLOC ───────────────────────────────────────────────────
class VideoDetailBloc extends Bloc<VideoDetailEvent, VideoDetailState> {
  final GetPaginatedVideos getPaginatedVideos;

  VideoDetailBloc({required this.getPaginatedVideos})
    : super(const VideoDetailState()) {
    on<LoadInitialVideos>(_onLoadInitial);
    on<LoadMoreVideos>(_onLoadMore);
  }

  Future<void> _onLoadInitial(
    LoadInitialVideos event,
    Emitter<VideoDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: VideoDetailStatus.success,
        videos: event.initialVideos,
        initialIndex: event.initialIndex,
        currentPage: 1,
        hasReachedMax: false,
      ),
    );

    // Preload next page in background
    final result = await getPaginatedVideos(
      PaginatedVideosParams(page: 2, limit: 10),
    );

    result.fold(
      (failure) {
        // Silently fail — initial videos still available
      },
      (paginated) {
        if (paginated.videos.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
        } else {
          // Filter duplicates
          final existingIds = state.videos.map((v) => v.id).toSet();
          final newVideos = paginated.videos
              .where((v) => !existingIds.contains(v.id))
              .toList();

          emit(
            state.copyWith(
              videos: [...state.videos, ...newVideos],
              currentPage: 2,
              hasReachedMax: !paginated.hasNextPage,
            ),
          );
        }
      },
    );
  }

  Future<void> _onLoadMore(
    LoadMoreVideos event,
    Emitter<VideoDetailState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;
    final result = await getPaginatedVideos(
      PaginatedVideosParams(page: nextPage, limit: 10),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(isLoadingMore: false, errorMessage: failure.message),
        );
      },
      (paginated) {
        if (paginated.videos.isEmpty) {
          emit(state.copyWith(isLoadingMore: false, hasReachedMax: true));
        } else {
          final existingIds = state.videos.map((v) => v.id).toSet();
          final newVideos = paginated.videos
              .where((v) => !existingIds.contains(v.id))
              .toList();

          emit(
            state.copyWith(
              videos: [...state.videos, ...newVideos],
              currentPage: nextPage,
              hasReachedMax: !paginated.hasNextPage,
              isLoadingMore: false,
            ),
          );
        }
      },
    );
  }
}
