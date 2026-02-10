import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/config/routes/app_routes.dart';
import 'package:portal_jtv/core/navigation/navigation_cubit.dart';
import 'package:portal_jtv/core/theme/theme.dart';
import 'package:portal_jtv/features/home/presentation/bloc/home_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/home_event.dart';
import 'config/injection/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => di.sl<HomeBloc>()..add(LoadHomeData())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: PortalTheme.lightTheme,
      darkTheme: PortalTheme.darkTheme,
      themeMode: ThemeMode.light,
    );
  }
}
