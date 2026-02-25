// lib/features/live/presentation/bloc/live_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/livestream_entity.dart';
import '../../domain/entities/schedule_entity.dart';

enum LiveStatus { initial, loading, success, failure }

enum ScheduleStatus { initial, loading, success, failure }

class LiveState extends Equatable {
  final LiveStatus status;
  final LivestreamEntity? livestream;
  final String? errorMessage;

  // Schedule
  final ScheduleStatus scheduleStatus;
  final List<ScheduleEntity> schedules;
  final int selectedDay;
  final String? scheduleError;

  const LiveState({
    this.status = LiveStatus.initial,
    this.livestream,
    this.errorMessage,
    this.scheduleStatus = ScheduleStatus.initial,
    this.schedules = const [],
    this.selectedDay = -1, // -1 = belum diset, akan otomatis hari ini
    this.scheduleError,
  });

  factory LiveState.initial() => const LiveState();

  LiveState copyWith({
    LiveStatus? status,
    LivestreamEntity? livestream,
    String? errorMessage,
    ScheduleStatus? scheduleStatus,
    List<ScheduleEntity>? schedules,
    int? selectedDay,
    String? scheduleError,
  }) {
    return LiveState(
      status: status ?? this.status,
      livestream: livestream ?? this.livestream,
      errorMessage: errorMessage ?? this.errorMessage,
      scheduleStatus: scheduleStatus ?? this.scheduleStatus,
      schedules: schedules ?? this.schedules,
      selectedDay: selectedDay ?? this.selectedDay,
      scheduleError: scheduleError ?? this.scheduleError,
    );
  }

  @override
  List<Object?> get props => [
    status,
    livestream,
    errorMessage,
    scheduleStatus,
    schedules,
    selectedDay,
    scheduleError,
  ];
}
