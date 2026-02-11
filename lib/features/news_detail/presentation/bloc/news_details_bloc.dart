import 'package:flutter_bloc/flutter_bloc.dart';
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

  // Simpan id_berita untuk bookmark toggle
  int? _currentIdBerita;

  DetailBloc({
    required this.getNewsDetail,
    required this.sendHitCounter,
    required this.checkBookmarkStatus,
    required this.saveBookmark,
    required this.removeBookmark,
  }) : super(DetailState.initial()) {
    on<LoadDetail>(_onLoadDetail);
    on<ToggleBookmark>(_onToggleBookmark);
  }

  Future<void> _onLoadDetail(
    LoadDetail event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(status: DetailStatus.loading));

    // Fetch detail berita + hit counter secara parallel
    // final results = await Future.wait([
    //   getNewsDetail(event.seo),
    //   sendHitCounter(HitCounterParams(seo: event.seo, tipe: 'mobile')),
    // ]);

    final detailResult = await getNewsDetail(event.seo);
    // hit counter result diabaikan (fire-and-forget)

    await detailResult.fold(
      (failure) {
        emit(
          state.copyWith(
            status: DetailStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (detailData) async {
        // Simpan id_berita untuk bookmark
        _currentIdBerita = detailData.detail.idBerita;

        emit(
          state.copyWith(
            status: DetailStatus.success,
            detail: detailData.detail,
            tags: detailData.tags,
          ),
        );

        // Cek bookmark status setelah detail loaded
        await _checkBookmark(emit);
      },
    );
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
