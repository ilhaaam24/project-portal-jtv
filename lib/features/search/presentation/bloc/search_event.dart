import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// User mengetik keyword baru
class SearchSubmitted extends SearchEvent {
  final String keyword;

  const SearchSubmitted({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

/// Load more (infinite scroll)
class SearchLoadMore extends SearchEvent {
  const SearchLoadMore();
}

/// Clear search / kembali ke history
class SearchCleared extends SearchEvent {
  const SearchCleared();
}

class SearchHistoryCleared extends SearchEvent {
  const SearchHistoryCleared();
}
class SearchRemoveHistoryItem extends SearchEvent {
  final String keyword;

  const SearchRemoveHistoryItem({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}