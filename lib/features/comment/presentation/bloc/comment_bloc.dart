import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_comments.dart';
import '../../domain/usecases/post_comment.dart';
import '../../domain/usecases/delete_comment.dart';
import '../../domain/usecases/toggle_comment_like.dart';
import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final GetComments getComments;
  final PostComment postComment;
  final DeleteComment deleteComment;
  final ToggleCommentLike toggleCommentLike;

  CommentBloc({
    required this.getComments,
    required this.postComment,
    required this.deleteComment,
    required this.toggleCommentLike,
  }) : super(const CommentState()) {
    on<LoadComments>(_onLoadComments);
    on<PostCommentEvent>(_onPostComment);
    on<DeleteCommentEvent>(_onDeleteComment);
    on<ToggleLikeCommentEvent>(_onToggleLike);
    on<ChangeSortOrder>(_onChangeSortOrder);
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentState> emit,
  ) async {
    emit(state.copyWith(status: CommentStatus.loading));

    final result = await getComments(event.idBerita);

    result.fold(
      (failure) => emit(state.copyWith(
        status: CommentStatus.failure,
        errorMessage: failure.message,
      )),
      (comments) => emit(state.copyWith(
        status: CommentStatus.success,
        comments: comments,
      )),
    );
  }

  Future<void> _onPostComment(
    PostCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(state.copyWith(isPosting: true));

    final result = await postComment(PostCommentParams(
      idBerita: event.idBerita,
      content: event.content,
      parentId: event.parentId,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        isPosting: false,
        errorMessage: failure.message,
      )),
      (newComment) {
        final updatedComments = List.of(state.comments)..add(newComment);
        emit(state.copyWith(
          isPosting: false,
          comments: updatedComments,
        ));
      },
    );
  }

  Future<void> _onDeleteComment(
    DeleteCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    final result = await deleteComment(event.commentId);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final updatedComments =
            state.comments.where((c) => c.id != event.commentId).toList();
        emit(state.copyWith(comments: updatedComments));
      },
    );
  }

  Future<void> _onToggleLike(
    ToggleLikeCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    // Optimistic update
    final updatedComments = state.comments.map((c) {
      if (c.id == event.commentId) {
        return c.copyWith(
          isLiked: !c.isLiked,
          likesCount: c.isLiked ? c.likesCount - 1 : c.likesCount + 1,
        );
      }
      return c;
    }).toList();
    emit(state.copyWith(comments: updatedComments));

    // API call
    final result = await toggleCommentLike(event.commentId);

    result.fold(
      (failure) {
        // Revert optimistic update
        final revertedComments = state.comments.map((c) {
          if (c.id == event.commentId) {
            return c.copyWith(
              isLiked: !c.isLiked,
              likesCount: c.isLiked ? c.likesCount - 1 : c.likesCount + 1,
            );
          }
          return c;
        }).toList();
        emit(state.copyWith(comments: revertedComments));
      },
      (likeResult) {
        // Sync with server response
        final syncedComments = state.comments.map((c) {
          if (c.id == event.commentId) {
            return c.copyWith(
              isLiked: likeResult.liked,
              likesCount: likeResult.totalLikes,
            );
          }
          return c;
        }).toList();
        emit(state.copyWith(comments: syncedComments));
      },
    );
  }

  void _onChangeSortOrder(
    ChangeSortOrder event,
    Emitter<CommentState> emit,
  ) {
    emit(state.copyWith(sortOrder: event.sortOrder));
  }
}
