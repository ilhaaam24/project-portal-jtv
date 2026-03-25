import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/auth/presentation/bloc/auth_bloc.dart';

/// Cek apakah user sudah login.
/// Jika belum, tampilkan bottom sheet login prompt.
/// Returns true jika user sudah login, false jika belum.
bool checkAuthAndPrompt(BuildContext context) {
  final authState = context.read<AuthBloc>().state;
  if (authState is AuthAuthenticated) return true;
  _showLoginPromptSheet(context);
  return false;
}

void _showLoginPromptSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _LoginPromptSheet(),
  );
}

class _LoginPromptSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: PortalColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: PortalColors.jtvJingga.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              size: 32,
              color: PortalColors.jtvJingga,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            'Login Diperlukan',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Silakan masuk atau buat akun untuk melanjutkan.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: PortalColors.grey600),
          ),
          const SizedBox(height: 24),

          // Login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                context.pushNamed('sign-in', extra: {'fromGuard': true});
              },
              child: const Text(
                'Masuk / Daftar',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Cancel button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Batal',
                style: TextStyle(color: PortalColors.grey600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
