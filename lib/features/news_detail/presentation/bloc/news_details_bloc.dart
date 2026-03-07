import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/news_detail/domain/usecases/get_related_news.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_event.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_state.dart';
import '../../domain/usecases/get_news_detail.dart';
import '../../domain/usecases/send_hit_counter.dart';
import '../../domain/usecases/check_bookmark_status.dart';
import '../../domain/usecases/save_bookmark.dart';
import '../../domain/usecases/remove_bookmark.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetNewsDetail getNewsDetail;
  final SendHitCounter sendHitCounter;
  final CheckBookmarkStatus checkBookmarkStatus;
  final SaveBookmark saveBookmark;
  final RemoveBookmark removeBookmark;
  final GetRelatedNews getRelatedNews;

  // Simpan id_berita untuk bookmark toggle
  int? _currentIdBerita;

  DetailBloc({
    required this.getNewsDetail,
    required this.sendHitCounter,
    required this.checkBookmarkStatus,
    required this.saveBookmark,
    required this.removeBookmark,
    required this.getRelatedNews,
  }) : super(DetailState.initial()) {
    on<LoadDetail>(_onLoadDetail);
    on<ToggleBookmark>(_onToggleBookmark);
  }

  Future<void> _onLoadDetail(
    LoadDetail event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(status: DetailStatus.loading));

    try {
      // 1) Fetch detail berita
      final detailResult = await getNewsDetail(event.seo);

      // Handle detail failure → langsung emit failure & return
      final detailData = detailResult.fold((failure) {
        emit(
          state.copyWith(
            status: DetailStatus.failure,
            errorMessage: failure.message,
          ),
        );
        return null;
      }, (data) => data);
      if (detailData == null) return;

      // Simpan id_berita untuk bookmark
      _currentIdBerita = detailData.detail.idBerita;

      // 2) Fetch related news berdasarkan kategori (non-blocking, failure = empty list)
      final relatedNewsResult = await getRelatedNews(
        GetRelatedNewsParams(
          limit: event.limit,
          seoCategory: event.seoCategory,
        ),
      );
      final allRelated = relatedNewsResult.fold(
        (_) => <NewsEntity>[],
        (data) => data,
      );

      // Filter out berita yang sedang dilihat agar tidak muncul di related news
      final relatedNews = allRelated.where((n) => n.seo != event.seo).toList();

      // 3) Emit success dengan detail, tags, dan related news
      emit(
        state.copyWith(
          status: DetailStatus.success,
          detail: detailData.detail,
          tags: detailData.tags,
          relatedNews: relatedNews,
        ),
      );

      // 4) Cek bookmark status setelah detail loaded
      await _checkBookmark(emit);
    } catch (e) {
      emit(
        state.copyWith(
          status: DetailStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _checkBookmark(Emitter<DetailState> emit) async {
    if (_currentIdBerita == null) return;

    final result = await checkBookmarkStatus(_currentIdBerita!);
    result.fold(
      (_) {}, // Gagal cek? Abaikan, default false
      (isSaved) {
        emit(state.copyWith(isSaved: isSaved));
      },
    );
  }

  Future<void> _onToggleBookmark(
    ToggleBookmark event,
    Emitter<DetailState> emit,
  ) async {
    if (_currentIdBerita == null) return;

    // Optimistic update — UI langsung berubah
    final previousSaved = state.isSaved;
    emit(state.copyWith(isSaved: !previousSaved, isBookmarkLoading: true));

    // Panggil API
    final result = previousSaved
        ? await removeBookmark(_currentIdBerita!)
        : await saveBookmark(_currentIdBerita!);

    result.fold(
      (failure) {
        // Gagal? Revert ke state sebelumnya
        emit(state.copyWith(isSaved: previousSaved, isBookmarkLoading: false));
      },
      (_) {
        // Berhasil, biarkan optimistic state
        emit(state.copyWith(isBookmarkLoading: false));
      },
    );
  }
}
