import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}
/// Event untuk load data pertama kali
class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}
/// Event untuk refresh semua data (pull-to-refresh)
class RefreshHomeData extends HomeEvent {
  const RefreshHomeData();
}
/// Event untuk load more berita terbaru (infinite scroll)
class LoadMoreLatestNews extends HomeEvent {
  const LoadMoreLatestNews();
}