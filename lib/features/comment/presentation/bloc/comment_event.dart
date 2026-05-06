import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

class LoadComments extends CommentEvent {
  final int idBerita;

  const LoadComments({required this.idBerita});

  @override
  List<Object?> get props => [idBerita];
}

class PostCommentEvent extends CommentEvent {
  final int idBerita;
  final String content;
  final int? parentId;

  const PostCommentEvent({
    required this.idBerita,
    required this.content,
    this.parentId,
  });

  @override
  List<Object?> get props => [idBerita, content, parentId];
}

class DeleteCommentEvent extends CommentEvent {
  final int commentId;

  const DeleteCommentEvent({required this.commentId});

  @override
  List<Object?> get props => [commentId];
}

class ToggleLikeCommentEvent extends CommentEvent {
  final int commentId;

  const ToggleLikeCommentEvent({required this.commentId});

  @override
  List<Object?> get props => [commentId];
}

class ChangeSortOrder extends CommentEvent {
  final CommentSortOrder sortOrder;

  const ChangeSortOrder({required this.sortOrder});

  @override
  List<Object?> get props => [sortOrder];
}

enum CommentSortOrder { terbaru, terpopuler }
