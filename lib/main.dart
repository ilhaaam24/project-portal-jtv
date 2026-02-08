import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/portal_colors.dart';
import 'package:portal_jtv/core/theme/theme.dart';
import 'config/injection/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal JTV',
      debugShowCheckedModeBanner: false,
      theme: PortalTheme.lightTheme,
      darkTheme: PortalTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: Center(
        child: Text(
          'Portal JTV App',
          style: TextStyle(fontSize: 20, color: PortalColors.jtvJingga),
        ),
      ),
    );
  }
}
