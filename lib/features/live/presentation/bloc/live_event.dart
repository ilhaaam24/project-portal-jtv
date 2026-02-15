// lib/features/live/presentation/bloc/live_event.dart

import 'package:equatable/equatable.dart';

abstract class LiveEvent extends Equatable {
  const LiveEvent();

  @override
  List<Object?> get props => [];
}

class LoadLivestream extends LiveEvent {
  const LoadLivestream();
}

class RefreshLivestream extends LiveEvent {
  const RefreshLivestream();
}
