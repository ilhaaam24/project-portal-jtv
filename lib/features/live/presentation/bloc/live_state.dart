part of 'live_bloc.dart';

abstract class LiveState extends Equatable {
  const LiveState();  

  @override
  List<Object> get props => [];
}
class LiveInitial extends LiveState {}
