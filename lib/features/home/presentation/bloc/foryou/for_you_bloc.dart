// lib/features/home/presentation/bloc/for_you/for_you_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_for_you.dart';
import 'for_you_event.dart';
import 'for_you_state.dart';

class ForYouBloc extends Bloc<ForYouEvent, ForYouState> {
  final GetForYou getForYou;

  ForYouBloc({required this.getForYou}) : super(ForYouState.initial()) {
    on<LoadForYou>(_onLoad);
    on<RefreshForYou>(_onRefresh);
  }

  Future<void> _onLoad(LoadForYou event, Emitter<ForYouState> emit) async {
    emit(state.copyWith(status: ForYouStatus.loading));

    final result = await getForYou(const ForYouParams(limit: 10));

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ForYouStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (news) => emit(
        state.copyWith(
          status: news.isEmpty ? ForYouStatus.empty : ForYouStatus.success,
          news: news,
        ),
      ),
    );
  }

  Future<void> _onRefresh(
    RefreshForYou event,
    Emitter<ForYouState> emit,
  ) async {
    await _onLoad(const LoadForYou(), emit);
  }
}
