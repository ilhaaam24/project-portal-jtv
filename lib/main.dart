import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:portal_jtv/config/routes/app_routes.dart';
import 'package:portal_jtv/core/navigation/navigation_cubit.dart';
import 'package:portal_jtv/core/services/notification_service.dart';
import 'package:portal_jtv/core/theme/theme.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_event.dart';
import 'package:portal_jtv/features/profile/presentation/cubit/language_cubit.dart';
import 'package:portal_jtv/features/profile/presentation/cubit/notification_cubit.dart';
import 'package:portal_jtv/features/profile/presentation/cubit/theme_cubit.dart';
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
        BlocProvider(create: (_) => di.sl<HomeBloc>()..add(LoadHomeData())),
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
        BlocProvider(create: (_) => di.sl<LanguageCubit>()),
        BlocProvider(create: (_) => di.sl<NotificationCubit>()),
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
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: themeMode, // ← dari ThemeCubit
          theme: PortalTheme.lightTheme,
          darkTheme: PortalTheme.darkTheme,
          // locale: context.watch<LanguageCubit>().state,
          routerConfig: router,
        );
      },
    );
  }
}
