import 'package:equatable/equatable.dart';
import '../../domain/entities/comment_entity.dart';
import 'comment_event.dart';

enum CommentStatus { initial, loading, success, failure }

class CommentState extends Equatable {
  final CommentStatus status;
  final List<CommentEntity> comments;
  final String? errorMessage;
  final CommentSortOrder sortOrder;
  final bool isPosting;

  const CommentState({
    this.status = CommentStatus.initial,
    this.comments = const [],
    this.errorMessage,
    this.sortOrder = CommentSortOrder.terbaru,
    this.isPosting = false,
  });

  /// Komentar yang sudah di-sort sesuai tab aktif
  List<CommentEntity> get sortedComments {
    final sorted = List<CommentEntity>.from(comments);
    if (sortOrder == CommentSortOrder.terpopuler) {
      sorted.sort((a, b) => b.likesCount.compareTo(a.likesCount));
    }
    // terbaru = default dari API (sudah diurutkan asc, kita reverse)
    return sorted;
  }

  CommentState copyWith({
    CommentStatus? status,
    List<CommentEntity>? comments,
    String? errorMessage,
    CommentSortOrder? sortOrder,
    bool? isPosting,
  }) {
    return CommentState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      errorMessage: errorMessage ?? this.errorMessage,
      sortOrder: sortOrder ?? this.sortOrder,
      isPosting: isPosting ?? this.isPosting,
    );
  }

  @override
  List<Object?> get props =>
      [status, comments, errorMessage, sortOrder, isPosting];
}
