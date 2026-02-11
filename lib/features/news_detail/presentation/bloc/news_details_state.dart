import 'package:equatable/equatable.dart';
import '../../domain/entities/news_detail_entity.dart';
import '../../domain/entities/tag_entity.dart';

enum DetailStatus { initial, loading, success, failure }

class DetailState extends Equatable {
  final DetailStatus status;
  final String? errorMessage;

  // Detail data (di-fetch dari API)
  final NewsDetailEntity? detail;
  final List<TagEntity> tags;

  // Bookmark
  final bool isSaved;
  final bool isBookmarkLoading;

  const DetailState({
    this.status = DetailStatus.initial,
    this.errorMessage,
    this.detail,
    this.tags = const [],
    this.isSaved = false,
    this.isBookmarkLoading = false,
  });

  factory DetailState.initial() => const DetailState();

  DetailState copyWith({
    DetailStatus? status,
    String? errorMessage,
    NewsDetailEntity? detail,
    List<TagEntity>? tags,
    bool? isSaved,
    bool? isBookmarkLoading,
  }) {
    return DetailState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      detail: detail ?? this.detail,
      tags: tags ?? this.tags,
      isSaved: isSaved ?? this.isSaved,
      isBookmarkLoading: isBookmarkLoading ?? this.isBookmarkLoading,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    detail,
    tags,
    isSaved,
    isBookmarkLoading,
  ];
}
