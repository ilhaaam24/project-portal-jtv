// lib/features/profile/presentation/bloc/profile_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/core/usecase/usecase.dart';
import 'package:portal_jtv/features/profile/domain/usecases/get_profile.dart';
import 'package:portal_jtv/features/profile/domain/usecases/logout.dart';
import 'package:portal_jtv/features/profile/domain/usecases/update_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;
  final Logout logout;
  final SharedPreferences prefs;

  ProfileBloc({
    required this.getProfile,
    required this.updateProfile,
    required this.logout,
    required this.prefs,
  }) : super(ProfileState.initial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileSubmit>(_onUpdateProfile);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await getProfile(const NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (profile) =>
          emit(state.copyWith(status: ProfileStatus.loaded, profile: profile)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileSubmit event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(updateStatus: UpdateStatus.submitting));

    final result = await updateProfile(
      UpdateProfileParams(
        nama: event.nama,
        email: event.email,
        phone: event.phone,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          updateStatus: UpdateStatus.failure,
          updateMessage: failure.message,
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            updateStatus: UpdateStatus.success,
            updateMessage: 'Profile berhasil diupdate!',
          ),
        );
        // Refresh profile setelah update
        add(const LoadProfile());
      },
    );
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(logoutStatus: LogoutStatus.loading));

    final result = await logout(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(logoutStatus: LogoutStatus.failure)),
      (_) {
        // Hapus token dari lokal
        prefs.remove('auth_token');

        emit(state.copyWith(logoutStatus: LogoutStatus.success));
      },
    );
  }
}
