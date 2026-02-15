// lib/features/home/presentation/bloc/for_you/for_you_state.dart

import 'package:equatable/equatable.dart';
import '../../../domain/entities/for_you_entity.dart';

enum ForYouStatus { initial, loading, success, failure, empty }

class ForYouState extends Equatable {
  final ForYouStatus status;
  final List<ForYouEntity> news;
  final String? errorMessage;

  const ForYouState({
    this.status = ForYouStatus.initial,
    this.news = const [],
    this.errorMessage,
  });

  factory ForYouState.initial() => const ForYouState();

  ForYouState copyWith({
    ForYouStatus? status,
    List<ForYouEntity>? news,
    String? errorMessage,
  }) {
    return ForYouState(
      status: status ?? this.status,
      news: news ?? this.news,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, news, errorMessage];
}
