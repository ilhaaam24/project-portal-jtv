import 'package:equatable/equatable.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object?> get props => [];
}

/// Load semua bookmark
class LoadBookmarks extends BookmarkEvent {
  const LoadBookmarks();
}

/// Refresh bookmark (pull-to-refresh)
class RefreshBookmarks extends BookmarkEvent {
  const RefreshBookmarks();
}

/// Hapus bookmark dari list
class DeleteBookmark extends BookmarkEvent {
  final int idBerita;
  final int index; // index di list, untuk undo

  const DeleteBookmark({required this.idBerita, required this.index});

  @override
  List<Object?> get props => [idBerita, index];
}

/// Undo hapus bookmark
class UndoDeleteBookmark extends BookmarkEvent {
  const UndoDeleteBookmark();
}
