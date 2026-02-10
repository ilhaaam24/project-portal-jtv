
import 'package:equatable/equatable.dart';
import 'package:portal_jtv/features/home/domain/entities/category_entity.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/home/domain/entities/sorot_entity.dart';
import 'package:portal_jtv/features/home/domain/entities/video_entity.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final String? errorMessage;

  // Data sections
  final List<NewsEntity> breakingNews;
  final List<NewsEntity> headlines;
  final List<NewsEntity> popularNews;
  final List<NewsEntity> latestNews;
  final List<SorotEntity> sorot;
  final List<VideoEntity> videos;
  final List<CategoryEntity> categories;

  // Pagination state untuk infinite scroll
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const HomeState({
    this.status = HomeStatus.initial,
    this.errorMessage,
    this.breakingNews = const [],
    this.headlines = const [],
    this.popularNews = const [],
    this.latestNews = const [],
    this.sorot = const [],
    this.videos = const [],
    this.categories = const [],
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  // Initial state
  factory HomeState.initial() => const HomeState();

  // CopyWith untuk update state
  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    List<NewsEntity>? breakingNews,
    List<NewsEntity>? headlines,
    List<NewsEntity>? popularNews,
    List<NewsEntity>? latestNews,
    List<SorotEntity>? sorot,
    List<VideoEntity>? videos,
    List<CategoryEntity>? categories,
    int? currentPage,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      breakingNews: breakingNews ?? this.breakingNews,
      headlines: headlines ?? this.headlines,
      popularNews: popularNews ?? this.popularNews,
      latestNews: latestNews ?? this.latestNews,
      sorot: sorot ?? this.sorot,
      videos: videos ?? this.videos,
      categories: categories ?? this.categories,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    breakingNews,
    headlines,
    popularNews,
    latestNews,
    sorot,
    videos,
    categories,
    currentPage,
    hasReachedMax,
    isLoadingMore,
  ];
}
