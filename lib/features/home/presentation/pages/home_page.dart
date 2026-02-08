import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/logos/logo-jtv-blue.png'),
          height: 28,
        ),
      ),
      body: const Center(child: Text('Home Page')),
    );
  }
}
