import 'package:equatable/equatable.dart';

abstract class PopulerEvent extends Equatable {
  const PopulerEvent();
  @override
  List<Object?> get props => [];
}

class LoadPopuler extends PopulerEvent {
  const LoadPopuler();
}

class LoadMorePopuler extends PopulerEvent {
  const LoadMorePopuler();
}

class RefreshPopuler extends PopulerEvent {
  const RefreshPopuler();
}
