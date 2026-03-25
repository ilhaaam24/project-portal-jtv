// lib/features/home/presentation/bloc/home_bloc.dart

import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_headlines.dart';
import '../../../domain/usecases/get_breaking_news.dart';
import '../../../domain/usecases/get_latest_news.dart';
import '../../../domain/usecases/get_popular_news.dart';
import '../../../domain/usecases/get_sorot.dart';
import '../../../domain/usecases/get_videos.dart';
import 'terbaru_event.dart';
import 'terbaru_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHeadlines getHeadlines;
  final GetBreakingNews getBreakingNews;
  final GetLatestNews getLatestNews;
  final GetPopuler getPopularNews;
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
      developer.log('🏠 [HomeBloc] Starting LoadHomeData...');

      // Extract results
      developer.log('🏠 [HomeBloc] Fetching breaking news...');
      final breakingResult = await getBreakingNews(
        BreakingNewsParams(limit: 3),
      );
      developer.log(
        '🏠 [HomeBloc] Breaking result: ${breakingResult.isRight() ? "SUCCESS" : "FAILURE"}',
      );

      developer.log('🏠 [HomeBloc] Fetching headlines...');
      final headlinesResult = await getHeadlines(HeadlinesParams(limit: 5));
      developer.log(
        '🏠 [HomeBloc] Headlines result: ${headlinesResult.isRight() ? "SUCCESS" : "FAILURE"}',
      );

      developer.log('🏠 [HomeBloc] Fetching latest news...');
      final latestResult = await getLatestNews(
        LatestNewsParams(page: 1, limit: 10),
      );
      developer.log(
        '🏠 [HomeBloc] Latest result: ${latestResult.isRight() ? "SUCCESS" : "FAILURE"}',
      );

      developer.log('🏠 [HomeBloc] Fetching videos...');
      final videosResult = await getVideos(VideosParams(limit: 5));
      developer.log(
        '🏠 [HomeBloc] Videos result: ${videosResult.isRight() ? "SUCCESS" : "FAILURE"}',
      );

      // Check for any failures
      String? errorMessage;

      final breaking = breakingResult.fold(
        (failure) {
          developer.log('❌ [HomeBloc] Breaking FAILURE: ${failure.message}');
          errorMessage = failure.message;
          return <dynamic>[];
        },
        (data) {
          developer.log('✅ [HomeBloc] Breaking data count: ${data.length}');
          return data;
        },
      );

      final headlines = headlinesResult.fold(
        (failure) {
          developer.log('❌ [HomeBloc] Headlines FAILURE: ${failure.message}');
          errorMessage ??= failure.message;
          return <dynamic>[];
        },
        (data) {
          developer.log('✅ [HomeBloc] Headlines data count: ${data.length}');
          return data;
        },
      );

      final latestPaginated = latestResult.fold(
        (failure) {
          developer.log('❌ [HomeBloc] Latest FAILURE: ${failure.message}');
          errorMessage ??= failure.message;
          return null;
        },
        (data) {
          developer.log('✅ [HomeBloc] Latest data count: ${data.news.length}');
          return data;
        },
      );

      final videos = videosResult.fold(
        (failure) {
          developer.log('❌ [HomeBloc] Videos FAILURE: ${failure.message}');
          errorMessage ??= failure.message;
          return <dynamic>[];
        },
        (data) {
          developer.log('✅ [HomeBloc] Videos data count: ${data.length}');
          return data;
        },
      );

      // Jika semua gagal, emit failure
      if (errorMessage != null &&
          breaking.isEmpty &&
          headlines.isEmpty &&
          latestPaginated == null) {
        developer.log('💀 [HomeBloc] ALL FAILED! Error: $errorMessage');
        emit(
          state.copyWith(
            status: HomeStatus.failure,
            errorMessage: errorMessage,
          ),
        );
        return;
      }

      developer.log('🎉 [HomeBloc] Emitting SUCCESS state');
      // Emit success dengan data
      emit(
        state.copyWith(
          status: HomeStatus.success,
          breakingNews: List.from(breaking),
          headlines: List.from(headlines),
          latestNews: latestPaginated?.news ?? [],
          // sorot: List.from(sorot),
          videos: List.from(videos),
          currentPage: latestPaginated?.currentPage ?? 1,
          hasReachedMax: !(latestPaginated?.hasNextPage ?? false),
        ),
      );
    } catch (e, stackTrace) {
      developer.log('💀 [HomeBloc] EXCEPTION: $e');
      developer.log('💀 [HomeBloc] StackTrace: $stackTrace');
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
