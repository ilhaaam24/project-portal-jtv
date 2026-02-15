// lib/features/home/presentation/bloc/populer/populer_state.dart

import 'package:equatable/equatable.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';

enum PopulerStatus { initial, loading, success, failure, empty }

class PopulerState extends Equatable {
  final PopulerStatus status;
  final List<NewsEntity> news;
  final int currentPage;
  final bool hasReachedMax;
  final String? errorMessage;

  const PopulerState({
    this.status = PopulerStatus.initial,
    this.news = const [],
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.errorMessage,
  });

  factory PopulerState.initial() => const PopulerState();

  PopulerState copyWith({
    PopulerStatus? status,
    List<NewsEntity>? news,
    int? currentPage,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return PopulerState(
      status: status ?? this.status,
      news: news ?? this.news,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    news,
    currentPage,
    hasReachedMax,
    errorMessage,
  ];
}
