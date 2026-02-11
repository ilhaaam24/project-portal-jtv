import 'package:flutter/material.dart';
import 'package:portal_jtv/core/widgets/bottom_nav_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNavBar(),
      // floatingActionButton: Container(
      //   decoration: BoxDecoration(
      //     shape: BoxShape.circle,
      //     gradient: const LinearGradient(
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //       colors: [PortalColors.jtvJingga, PortalColors.jtvMerahJambu],
      //     ),
      //     boxShadow: [
      //       BoxShadow(
      //         color: PortalColors.jtvJingga.withValues(alpha: 0.4),
      //         blurRadius: 12,
      //         offset: const Offset(0, 4),
      //       ),
      //     ],
      //   ),
      //   child: FloatingActionButton(
      //     onPressed: () => context.go(RouteNames.live),
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Image.asset('assets/icons/live_acti.png', width: 24, height: 24),
      //       ],
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
