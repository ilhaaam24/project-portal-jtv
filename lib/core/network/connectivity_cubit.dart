import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/connectivity_service.dart';

abstract class ConnectivityState extends Equatable {
  final bool isConnected;
  const ConnectivityState(this.isConnected);

  @override
  List<Object> get props => [isConnected];
}

class ConnectivityInitial extends ConnectivityState {
  const ConnectivityInitial() : super(true);
}

class ConnectivityChanged extends ConnectivityState {
  const ConnectivityChanged(super.isConnected);
}

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final ConnectivityService _connectivityService;
  late StreamSubscription _subscription;

  ConnectivityCubit(this._connectivityService)
    : super(const ConnectivityInitial()) {
    _init();
  }

  void _init() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final connected = await _connectivityService.isConnected;
    emit(ConnectivityChanged(connected));

    _subscription = _connectivityService.connectivityStream.listen((
      results,
    ) async {
      final isNowConnected = await _connectivityService.isConnected;

      if (isNowConnected != state.isConnected) {
        emit(ConnectivityChanged(isNowConnected));
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
