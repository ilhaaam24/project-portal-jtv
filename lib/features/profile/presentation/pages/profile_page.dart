import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/l10n/app_localizations.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../cubit/theme_cubit.dart';
import '../cubit/language_cubit.dart';
import '../cubit/notification_cubit.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import 'package:portal_jtv/config/injection/injection.dart' as di;
import 'package:in_app_review/in_app_review.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ProfileBloc>()..add(const LoadProfile()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile), centerTitle: true),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          // Logout berhasil → kembali ke login
          if (state.logoutStatus == LogoutStatus.success) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/login', (route) => false);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // ─── HEADER (Foto, Nama, Email) ───
                _buildHeader(state),

                const Divider(height: 1),

                // ─── SECTION: Akun ───
                _buildSectionTitle(l10n.account),
                ProfileMenuItem(
                  icon: Icons.edit_outlined,
                  title: l10n.editBio,
                  onTap: () => _navigateToEdit(context, state),
                ),

                const Divider(height: 1, indent: 72),

                // ─── SECTION: Pengaturan ───
                _buildSectionTitle(l10n.settings),

                // Notifikasi
                BlocBuilder<NotificationCubit, bool>(
                  builder: (context, isEnabled) {
                    return ProfileMenuItem(
                      icon: Icons.notifications_outlined,
                      title: l10n.notification,

                      trailing: Switch(
                        value: isEnabled,
                        onChanged: (_) =>
                            context.read<NotificationCubit>().toggle(),
                      ),
                      onTap: () => context.read<NotificationCubit>().toggle(),
                    );
                  },
                ),

                // Bahasa
                BlocBuilder<LanguageCubit, Locale>(
                  builder: (context, locale) {
                    return ProfileMenuItem(
                      icon: Icons.language,
                      title: l10n.language,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.read<LanguageCubit>().currentLanguageName,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                      onTap: () => _showLanguageDialog(context),
                    );
                  },
                ),

                // Tema
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    return ProfileMenuItem(
                      icon: themeMode == ThemeMode.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      title: l10n.theme,
                      trailing: Switch(
                        value: context.read<ThemeCubit>().isDark,
                        onChanged: (_) =>
                            context.read<ThemeCubit>().toggleTheme(),
                        thumbIcon: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return const Icon(Icons.dark_mode, size: 16);
                          }
                          return const Icon(Icons.light_mode, size: 16);
                        }),
                      ),
                      onTap: () => context.read<ThemeCubit>().toggleTheme(),
                    );
                  },
                ),

                const Divider(height: 1, indent: 72),

                // ─── SECTION: Lainnya ───
                _buildSectionTitle(l10n.others),

                ProfileMenuItem(
                  icon: Icons.help_outline,
                  title: l10n.faq,
                  onTap: () {
                    context.pushNamed('faq');
                  },
                ),

                ProfileMenuItem(
                  icon: Icons.star_outline,
                  title: l10n.rateUs,
                  onTap: () async {
                    final inAppReview = InAppReview.instance;
                    if (await inAppReview.isAvailable()) {
                      inAppReview.requestReview();
                    }
                  },
                ),

                const Divider(height: 1, indent: 72),
                const SizedBox(height: 8),

                // ─── LOGOUT ───
                ProfileMenuItem(
                  icon: Icons.logout,
                  title: l10n.logout,
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  trailing: const SizedBox.shrink(),
                  onTap: () => _showLogoutDialog(context),
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── HEADER ───
  Widget _buildHeader(ProfileState state) {
    if (state.status == ProfileStatus.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: CircularProgressIndicator(),
      );
    }

    return ProfileHeader(
      nama: state.profile?.nama ?? '-',
      email: state.profile?.email ?? '-',
      photo: state.profile?.photo ?? '',
    );
  }

  // ─── SECTION TITLE ───
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // ─── NAVIGATE EDIT ───
  void _navigateToEdit(BuildContext context, ProfileState state) {
    if (state.profile == null) return;
    context.pushNamed('edit', extra: state.profile);
  }

  // ─── LANGUAGE DIALOG ───
  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCubit = context.read<LanguageCubit>();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(l10n.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: LanguageCubit.supportedLocales.map((locale) {
              final name = LanguageCubit.localeNames[locale.languageCode]!;
              return RadioListTile<String?>(
                title: Text(name),
                value: locale.languageCode,
                groupValue: languageCubit.state.languageCode,
                onChanged: (code) {
                  context.pop();
                  languageCubit.changeLanguage(code!);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // ─── LOGOUT DIALOG ───
  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileBloc>().add(const LogoutRequested());
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}
