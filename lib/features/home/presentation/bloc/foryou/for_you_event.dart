// lib/features/home/presentation/bloc/for_you/for_you_event.dart

import 'package:equatable/equatable.dart';

abstract class ForYouEvent extends Equatable {
  const ForYouEvent();
  @override
  List<Object?> get props => [];
}

class LoadForYou extends ForYouEvent {
  const LoadForYou();
}

class RefreshForYou extends ForYouEvent {
  const RefreshForYou();
}
