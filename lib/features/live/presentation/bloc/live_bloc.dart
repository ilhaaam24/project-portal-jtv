import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'live_event.dart';
part 'live_state.dart';

class LiveBloc extends Bloc<LiveEvent, LiveState> {
  LiveBloc() : super(LiveInitial()) {
    on<LiveEvent>((event, emit) {});
  }
}
