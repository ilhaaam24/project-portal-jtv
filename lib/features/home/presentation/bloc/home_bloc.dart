// lib/features/home/presentation/bloc/home_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_headlines.dart';
import '../../domain/usecases/get_breaking_news.dart';
import '../../domain/usecases/get_latest_news.dart';
import '../../domain/usecases/get_popular_news.dart';
import '../../domain/usecases/get_sorot.dart';
import '../../domain/usecases/get_videos.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHeadlines getHeadlines;
  final GetBreakingNews getBreakingNews;
  final GetLatestNews getLatestNews;
  final GetPopularNews getPopularNews;
  final GetSorot getSorot;
  final GetVideos getVideos;

  HomeBloc({
    required this.getHeadlines,
    required this.getBreakingNews,
    required this.getLatestNews,
    required this.getPopularNews,
    required this.getSorot,
    required this.getVideos,
  }) : super(HomeState.initial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<LoadMoreLatestNews>(_onLoadMoreLatestNews);
  }

  /// Handler untuk load data pertama kali
  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      // Fetch semua data secara parallel untuk performa optimal
      // final results = await Future .wait([
      //   getBreakingNews(const BreakingNewsParams(limit: 3)),
      //   getHeadlines(const HeadlinesParams(limit: 5)),
      //   getPopularNews(PopularNewsParams(limit: 5)),
      //   getLatestNews(const LatestNewsParams(page: 1, limit: 10)),
      //   getSorot(SorotParams(limit: 5)),
      //   getVideos(VideosParams(limit: 5)),
      // ]);

      // Extract results
      final breakingResult = await getBreakingNews(
        BreakingNewsParams(limit: 3),
      );
      final headlinesResult = await getHeadlines(HeadlinesParams(limit: 5));
      final popularResult = await getPopularNews(PopularNewsParams(limit: 5));
      final latestResult = await getLatestNews(
        LatestNewsParams(page: 1, limit: 10),
      );
      final sorotResult = await getSorot(SorotParams(limit: 5));
      final videosResult = await getVideos(VideosParams(limit: 5));

      // Extract results
      // final breakingResult = results[0];
      // final headlinesResult = results[1];
      // final popularResult = results[2];
      // final latestResult = results[3];
      // final sorotResult = results[4];
      // final videosResult = results[5];

      // Check for any failures
      String? errorMessage;

      final breaking = breakingResult.fold((failure) {
        errorMessage = failure.message;
        return <dynamic>[];
      }, (data) => data);

      final headlines = headlinesResult.fold((failure) {
        errorMessage ??= failure.message;
        return <dynamic>[];
      }, (data) => data);

      final popular = popularResult.fold((failure) {
        errorMessage ??= failure.message;
        return <dynamic>[];
      }, (data) => data);

      final latestPaginated = latestResult.fold((failure) {
        errorMessage ??= failure.message;
        return null;
      }, (data) => data);

      final sorot = sorotResult.fold((failure) {
        errorMessage ??= failure.message;
        return <dynamic>[];
      }, (data) => data);

      final videos = videosResult.fold((failure) {
        errorMessage ??= failure.message;
        return <dynamic>[];
      }, (data) => data);

      // Jika semua gagal, emit failure
      if (errorMessage != null &&
          breaking.isEmpty &&
          headlines.isEmpty &&
          popular.isEmpty &&
          latestPaginated == null) {
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            errorMessage: errorMessage,
          ),
        );
        return;
      }

      // Emit success dengan data
      emit(
        state.copyWith(
          status: HomeStatus.success,
          breakingNews: List.from(breaking),
          headlines: List.from(headlines),
          popularNews: List.from(popular),
          latestNews: latestPaginated?.news ?? [],
          sorot: List.from(sorot),
          videos: List.from(videos),
          currentPage: latestPaginated?.currentPage ?? 1,
          hasReachedMax: !(latestPaginated?.hasNextPage ?? false),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  /// Handler untuk refresh (pull-to-refresh)
  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    // Reset state dan load ulang
    emit(state.copyWith(currentPage: 1, hasReachedMax: false));

    // Panggil load data
    await _onLoadHomeData(const LoadHomeData(), emit);
  }

  /// Handler untuk infinite scroll
  Future<void> _onLoadMoreLatestNews(
    LoadMoreLatestNews event,
    Emitter<HomeState> emit,
  ) async {
    // Jangan load jika sudah mencapai max atau sedang loading
    if (state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;

    final result = await getLatestNews(
      LatestNewsParams(page: nextPage, limit: 10),
    );

    result.fold(
      (failure) {
        // Jika gagal, tetap di page sekarang
        emit(state.copyWith(isLoadingMore: false));
      },
      (paginatedNews) {
        // Append data baru ke list yang ada
        final updatedNews = [...state.latestNews, ...paginatedNews.news];

        emit(
          state.copyWith(
            latestNews: updatedNews,
            currentPage: nextPage,
            hasReachedMax: !paginatedNews.hasNextPage,
            isLoadingMore: false,
          ),
        );
      },
    );
  }
}
