import 'package:equatable/equatable.dart';
import '../../domain/entities/saved_news_entity.dart';

enum BookmarkStatus { initial, loading, success, failure, empty }

class BookmarkState extends Equatable {
  final BookmarkStatus status;
  final String? errorMessage;
  final List<SavedNewsEntity> savedNews;

  // Untuk undo delete
  final SavedNewsEntity? lastDeleted;
  final int? lastDeletedIndex;

  const BookmarkState({
    this.status = BookmarkStatus.initial,
    this.errorMessage,
    this.savedNews = const [],
    this.lastDeleted,
    this.lastDeletedIndex,
  });

  factory BookmarkState.initial() => const BookmarkState();

  BookmarkState copyWith({
    BookmarkStatus? status,
    String? errorMessage,
    List<SavedNewsEntity>? savedNews,
    SavedNewsEntity? lastDeleted,
    int? lastDeletedIndex,
  }) {
    return BookmarkState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      savedNews: savedNews ?? this.savedNews,
      lastDeleted: lastDeleted, // Intentionally nullable reset
      lastDeletedIndex: lastDeletedIndex,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    savedNews,
    lastDeleted,
    lastDeletedIndex,
  ];
}
