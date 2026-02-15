import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/news_entity.dart';

enum SearchStatus { initial, loading, success, failure, empty }

class SearchState extends Equatable {
  final SearchStatus status;
  final String keyword;
  final List<NewsEntity> results;
  final int currentPage;
  final bool hasReachedMax;
  final int total;
  final String? errorMessage;

  // Search history
  final List<String> searchHistory;

  const SearchState({
    this.status = SearchStatus.initial,
    this.keyword = '',
    this.results = const [],
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.total = 0,
    this.errorMessage,
    this.searchHistory = const [],
  });

  factory SearchState.initial({List<String> history = const []}) {
    return SearchState(searchHistory: history);
  }

  SearchState copyWith({
    SearchStatus? status,
    String? keyword,
    List<NewsEntity>? results,
    int? currentPage,
    bool? hasReachedMax,
    int? total,
    String? errorMessage,
    List<String>? searchHistory,
  }) {
    return SearchState(
      status: status ?? this.status,
      keyword: keyword ?? this.keyword,
      results: results ?? this.results,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      total: total ?? this.total,
      errorMessage: errorMessage ?? this.errorMessage,
      searchHistory: searchHistory ?? this.searchHistory,
    );
  }

  @override
  List<Object?> get props => [
    status,
    keyword,
    results,
    currentPage,
    hasReachedMax,
    total,
    errorMessage,
    searchHistory,
  ];
}
