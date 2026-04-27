import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:portal_jtv/config/routes/app_routes.dart';
import 'package:portal_jtv/core/navigation/navigation_cubit.dart';
import 'package:portal_jtv/core/network/connectivity_cubit.dart';
import 'package:portal_jtv/core/services/notification_service.dart';
import 'package:portal_jtv/core/services/toast_service.dart';
import 'package:portal_jtv/core/theme/theme.dart';
import 'package:portal_jtv/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:portal_jtv/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:portal_jtv/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_event.dart';
import 'package:portal_jtv/features/profile/presentation/cubit/language_cubit.dart';
import 'package:portal_jtv/features/profile/presentation/cubit/notification_cubit.dart';
import 'package:portal_jtv/features/profile/presentation/cubit/theme_cubit.dart';
import 'package:portal_jtv/l10n/app_localizations.dart';
import 'config/injection/injection.dart' as di;

Player? _activePlayer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MediaKit.ensureInitialized();
  await di.init();

  await _activePlayer?.dispose();
  _activePlayer = null;

  MediaKit.ensureInitialized();

  // Init push notification (non-blocking)
  di.sl<NotificationService>().init(router);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => di.sl<AuthBloc>()..add(CheckAuthStatus())),
        BlocProvider(create: (_) => di.sl<HomeBloc>()..add(LoadHomeData())),
        BlocProvider(
          create: (_) => di.sl<BookmarkBloc>()..add(const LoadBookmarks()),
        ),
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
        BlocProvider(create: (_) => di.sl<LanguageCubit>()),
        BlocProvider(create: (_) => di.sl<NotificationCubit>()),
        BlocProvider(create: (_) => di.sl<ConnectivityCubit>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: LanguageCubit.supportedLocales,
              locale: locale,
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: PortalTheme.lightTheme,
              darkTheme: PortalTheme.darkTheme,
              routerConfig: router,
              builder: (context, child) {
                return BlocListener<ConnectivityCubit, ConnectivityState>(
                  listener: (context, state) {
                    final navigatorContext = rootNavigatorKey.currentContext;
                    if (navigatorContext == null) return;

                    if (!state.isConnected) {
                      ToastService.showError(
                        navigatorContext,
                        'Koneksi Terputus',
                        description: 'Silakan periksa koneksi internet Anda',
                      );
                    } else {
                      ToastService.showSuccess(navigatorContext, 'Kembali Online');
                    }
                  },
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}
