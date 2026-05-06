// lib/features/live/presentation/bloc/live_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import '../../domain/usecases/get_livestream.dart';
import '../../domain/usecases/get_live_schedule.dart';
import 'live_event.dart';
import 'live_state.dart';

class LiveBloc extends Bloc<LiveEvent, LiveState> {
  final GetLivestream getLivestream;
  final GetLiveSchedule getLiveSchedule;

  LiveBloc({required this.getLivestream, required this.getLiveSchedule})
    : super(LiveState.initial()) {
    on<LoadLivestream>(_onLoad);
    on<RefreshLivestream>(_onRefresh);
    on<LoadSchedule>(_onLoadSchedule);
  }

  Future<void> _onLoad(LoadLivestream event, Emitter<LiveState> emit) async {
    emit(state.copyWith(status: LiveStatus.loading));

    final result = await getLivestream(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LiveStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (livestream) => emit(
        state.copyWith(status: LiveStatus.success, livestream: livestream),
      ),
    );
  }

  Future<void> _onRefresh(
    RefreshLivestream event,
    Emitter<LiveState> emit,
  ) async {
    await _onLoad(const LoadLivestream(), emit);
  }

  Future<void> _onLoadSchedule(
    LoadSchedule event,
    Emitter<LiveState> emit,
  ) async {
    emit(
      state.copyWith(
        scheduleStatus: ScheduleStatus.loading,
        selectedDay: event.dayIndex,
      ),
    );

    final result = await getLiveSchedule(event.dayIndex);

    result.fold(
      (failure) => emit(
        state.copyWith(
          scheduleStatus: ScheduleStatus.failure,
          scheduleError: failure.message,
        ),
      ),
      (schedules) => emit(
        state.copyWith(
          scheduleStatus: ScheduleStatus.success,
          schedules: schedules,
        ),
      ),
    );
  }
}
