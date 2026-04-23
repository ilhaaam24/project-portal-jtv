import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/core/services/notification_service.dart';
import 'package:portal_jtv/features/auth/domain/entities/auth_entity.dart';
import 'package:portal_jtv/features/auth/domain/usecases/login.dart';
import 'package:portal_jtv/features/auth/domain/usecases/get_saved_auth.dart';
import 'package:portal_jtv/features/auth/domain/usecases/logout.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final GetSavedAuth getSavedAuth;
  final Logout logout;
  final NotificationService notificationService;

  AuthBloc({
    required this.login,
    required this.getSavedAuth,
    required this.logout,
    required this.notificationService,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await login(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold((failure) => emit(AuthError(failure.message)), (authData) {
      emit(AuthAuthenticated(authData));
      notificationService.registerToken();
    });
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getSavedAuth(NoParams());
    result.fold((failure) => emit(AuthInitial()), (authData) {
      emit(AuthAuthenticated(authData));
      notificationService.registerToken();
    });
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logout(NoParams());
    emit(AuthInitial());
  }
}
