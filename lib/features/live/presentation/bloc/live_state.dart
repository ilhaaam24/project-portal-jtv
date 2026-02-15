// lib/features/live/presentation/bloc/live_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/livestream_entity.dart';

enum LiveStatus { initial, loading, success, failure }

class LiveState extends Equatable {
  final LiveStatus status;
  final LivestreamEntity? livestream;
  final String? errorMessage;

  const LiveState({
    this.status = LiveStatus.initial,
    this.livestream,
    this.errorMessage,
  });

  factory LiveState.initial() => const LiveState();

  LiveState copyWith({
    LiveStatus? status,
    LivestreamEntity? livestream,
    String? errorMessage,
  }) {
    return LiveState(
      status: status ?? this.status,
      livestream: livestream ?? this.livestream,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, livestream, errorMessage];
}
