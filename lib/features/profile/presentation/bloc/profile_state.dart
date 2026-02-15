// lib/features/profile/presentation/bloc/profile_state.dart

import 'package:equatable/equatable.dart';
import 'package:portal_jtv/features/profile/domain/entities/profile_entity.dart';

enum ProfileStatus { initial, loading, loaded, failure }

enum UpdateStatus { idle, submitting, success, failure }

enum LogoutStatus { idle, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final ProfileEntity? profile;
  final String? errorMessage;

  // Update profile status (terpisah dari load)
  final UpdateStatus updateStatus;
  final String? updateMessage;

  // Logout status
  final LogoutStatus logoutStatus;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.updateStatus = UpdateStatus.idle,
    this.updateMessage,
    this.logoutStatus = LogoutStatus.idle,
  });

  factory ProfileState.initial() => const ProfileState();

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? profile,
    String? errorMessage,
    UpdateStatus? updateStatus,
    String? updateMessage,
    LogoutStatus? logoutStatus,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      updateStatus: updateStatus ?? this.updateStatus,
      updateMessage: updateMessage ?? this.updateMessage,
      logoutStatus: logoutStatus ?? this.logoutStatus,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    errorMessage,
    updateStatus,
    updateMessage,
    logoutStatus,
  ];
}
