import 'package:equatable/equatable.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';

enum CategoryNewsStatus { initial, loading, success, failure, empty }

class CategoryNewsState extends Equatable {
  final CategoryNewsStatus status;
  final List<NewsEntity> news;
  final String title;
  final String seo;
  final bool isBiro;
  final int currentPage;
  final bool hasReachedMax;
  final String? errorMessage;

  const CategoryNewsState({
    this.status = CategoryNewsStatus.initial,
    this.news = const [],
    this.title = '',
    this.seo = '',
    this.isBiro = false,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  factory CategoryNewsState.initial() => const CategoryNewsState();

  CategoryNewsState copyWith({
    CategoryNewsStatus? status,
    List<NewsEntity>? news,
    String? title,
    String? seo,
    bool? isBiro,
    int? currentPage,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return CategoryNewsState(
      status: status ?? this.status,
      news: news ?? this.news,
      title: title ?? this.title,
      seo: seo ?? this.seo,
      isBiro: isBiro ?? this.isBiro,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    news,
    title,
    seo,
    isBiro,
    currentPage,
    hasReachedMax,
    errorMessage,
  ];
}
