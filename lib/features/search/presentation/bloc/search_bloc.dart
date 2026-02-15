import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/features/search/domain/usecases/search_news.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchNews searchNews;
  final SharedPreferences prefs;

  static const String _historyKey = 'search_history';
  static const int _historyLimit = 10;
  static const int _limit = 10;

  SearchBloc({required this.searchNews, required this.prefs})
    : super(SearchState.initial(history: _loadHistory(prefs))) {
    on<SearchSubmitted>(_onSearchSubmitted);
    on<SearchLoadMore>(_onSearchLoadMore);
    on<SearchCleared>(_onSearchCleared);
    on<SearchHistoryCleared>(clearHistory);
    on<SearchRemoveHistoryItem>(removeHistoryItem);
  }

  // ─── Load history dari SharedPreferences ───
  static List<String> _loadHistory(SharedPreferences prefs) {
    return prefs.getStringList(_historyKey) ?? [];
  }

  // ─── Simpan keyword ke history ───
  void _saveToHistory(String keyword) {
    final history = List<String>.from(state.searchHistory);

    // Hapus duplikat
    history.remove(keyword);
    // Tambah di awal
    history.insert(0, keyword);
    // Batasi jumlah
    if (history.length > _historyLimit) {
      history.removeRange(_historyLimit, history.length);
    }

    prefs.setStringList(_historyKey, history);
  }

  // ─── SEARCH BARU ───
  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    final keyword = event.keyword.trim();
    if (keyword.isEmpty) return;

    emit(
      state.copyWith(
        status: SearchStatus.loading,
        keyword: keyword,
        results: [], // Reset results
        currentPage: 1,
        hasReachedMax: false,
      ),
    );

    final result = await searchNews(
      SearchNewsParams(keyword: keyword, limit: _limit, page: 1),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (searchResult) {
        // Simpan ke history
        _saveToHistory(keyword);
        final updatedHistory = _loadHistory(prefs);

        emit(
          state.copyWith(
            status: searchResult.news.isEmpty
                ? SearchStatus.empty
                : SearchStatus.success,
            results: searchResult.news,
            currentPage: searchResult.currentPage,
            hasReachedMax: searchResult.hasReachedMax,
            total: searchResult.total,
            searchHistory: updatedHistory,
          ),
        );
      },
    );
  }

  // ─── LOAD MORE ───
  Future<void> _onSearchLoadMore(
    SearchLoadMore event,
    Emitter<SearchState> emit,
  ) async {
    if (state.hasReachedMax || state.status == SearchStatus.loading) return;

    final nextPage = state.currentPage + 1;

    final result = await searchNews(
      SearchNewsParams(keyword: state.keyword, limit: _limit, page: nextPage),
    );

    result.fold(
      (_) {}, // Gagal load more? Abaikan, biarkan data yang ada
      (searchResult) {
        emit(
          state.copyWith(
            results: [...state.results, ...searchResult.news],
            currentPage: searchResult.currentPage,
            hasReachedMax: searchResult.hasReachedMax,
          ),
        );
      },
    );
  }

  // ─── CLEAR ───
  void _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(
      state.copyWith(
        status: SearchStatus.initial,
        keyword: '',
        results: [],
        currentPage: 1,
        hasReachedMax: false,
        total: 0,
      ),
    );
  }

  // ─── Hapus 1 item history ───
  void removeHistoryItem(
    SearchRemoveHistoryItem event,
    Emitter<SearchState> emit,
  ) {
    final history = List<String>.from(state.searchHistory)
      ..remove(event.keyword);
    prefs.setStringList(_historyKey, history);
    emit(state.copyWith(searchHistory: history));
  }

  // ─── Hapus semua history ───
  void clearHistory(SearchHistoryCleared event, Emitter<SearchState> emit) {
    prefs.remove(_historyKey);
    emit(state.copyWith(searchHistory: []));
  }
}
