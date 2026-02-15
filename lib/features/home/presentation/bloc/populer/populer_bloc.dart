// lib/features/home/presentation/bloc/populer/populer_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/features/home/domain/usecases/get_popular_news.dart';
import 'populer_event.dart';
import 'populer_state.dart';

class PopulerBloc extends Bloc<PopulerEvent, PopulerState> {
  final GetPopuler getPopuler;

  PopulerBloc({required this.getPopuler}) : super(PopulerState.initial()) {
    on<LoadPopuler>(_onLoad);
    on<LoadMorePopuler>(_onLoadMore);
    on<RefreshPopuler>(_onRefresh);
  }

  Future<void> _onLoad(LoadPopuler event, Emitter<PopulerState> emit) async {
    emit(state.copyWith(status: PopulerStatus.loading));

    final result = await getPopuler( PopulerParams(page: 1, limit: 10));

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PopulerStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (paginated) => emit(
        state.copyWith(
          status: paginated.news.isEmpty
              ? PopulerStatus.empty
              : PopulerStatus.success,
          news: paginated.news,
          currentPage: paginated.currentPage,
          hasReachedMax: !paginated.hasNextPage,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    LoadMorePopuler event,
    Emitter<PopulerState> emit,
  ) async {
    if (state.hasReachedMax) return;

    final nextPage = state.currentPage + 1;
    final result = await getPopuler(PopulerParams(page: nextPage, limit: 10));

    result.fold(
      (_) {},
      (paginated) => emit(
        state.copyWith(
          news: [...state.news, ...paginated.news],
          currentPage: paginated.currentPage,
          hasReachedMax: !paginated.hasNextPage,
        ),
      ),
    );
  }

  Future<void> _onRefresh(
    RefreshPopuler event,
    Emitter<PopulerState> emit,
  ) async {
    emit(state.copyWith(currentPage: 1, hasReachedMax: false, news: []));
    await _onLoad(const LoadPopuler(), emit);
  }
}
