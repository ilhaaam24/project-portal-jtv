// lib/features/bookmark/presentation/bloc/bookmark_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import '../../domain/usecases/get_saved_news_list.dart';
import '../../domain/usecases/delete_saved_news.dart';
import 'bookmark_event.dart';
import 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final GetSavedNewsList getSavedNewsList;
  final DeleteSavedNews deleteSavedNews;

  BookmarkBloc({required this.getSavedNewsList, required this.deleteSavedNews})
    : super(BookmarkState.initial()) {
    on<LoadBookmarks>(_onLoadBookmarks);
    on<RefreshBookmarks>(_onRefreshBookmarks);
    on<DeleteBookmark>(_onDeleteBookmark);
    on<UndoDeleteBookmark>(_onUndoDelete);
  }

  Future<void> _onLoadBookmarks(
    LoadBookmarks event,
    Emitter<BookmarkState> emit,
  ) async {
    emit(state.copyWith(status: BookmarkStatus.loading));

    final result = await getSavedNewsList(const NoParams());

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BookmarkStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (savedNews) {
        emit(
          state.copyWith(
            status: savedNews.isEmpty
                ? BookmarkStatus.empty
                : BookmarkStatus.success,
            savedNews: savedNews,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshBookmarks(
    RefreshBookmarks event,
    Emitter<BookmarkState> emit,
  ) async {
    await _onLoadBookmarks(const LoadBookmarks(), emit);
  }

  Future<void> _onDeleteBookmark(
    DeleteBookmark event,
    Emitter<BookmarkState> emit,
  ) async {
    // Simpan item untuk undo
    final deletedItem = state.savedNews[event.index];

    // Optimistic update — hapus dari UI dulu
    final updatedList = List.of(state.savedNews)..removeAt(event.index);

    emit(
      state.copyWith(
        savedNews: updatedList,
        status: updatedList.isEmpty
            ? BookmarkStatus.empty
            : BookmarkStatus.success,
        lastDeleted: deletedItem,
        lastDeletedIndex: event.index,
      ),
    );

    // Panggil API delete
    final result = await deleteSavedNews(event.idBerita);

    result.fold(
      (failure) {
        // Gagal? Kembalikan item ke list
        final restoredList = List.of(state.savedNews)
          ..insert(event.index, deletedItem);

        emit(
          state.copyWith(
            savedNews: restoredList,
            status: BookmarkStatus.success,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        // Berhasil, biarkan optimistic state
      },
    );
  }

  Future<void> _onUndoDelete(
    UndoDeleteBookmark event,
    Emitter<BookmarkState> emit,
  ) async {
    if (state.lastDeleted == null || state.lastDeletedIndex == null) return;

    // Kembalikan item ke list
    final restoredList = List.of(state.savedNews)
      ..insert(state.lastDeletedIndex!, state.lastDeleted!);

    emit(
      state.copyWith(
        savedNews: restoredList,
        status: BookmarkStatus.success,
        lastDeleted: null,
        lastDeletedIndex: null,
      ),
    );

    // todo: Re-save ke backend (POST /saved-news/{id})
    // Karena kita tadi sudah DELETE, perlu save ulang
  }
}
