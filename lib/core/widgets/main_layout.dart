import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/config/routes/route_names.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/core/widgets/bottom_nav_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [PortalColors.jtvJingga, PortalColors.jtvMerahJambu],
          ),
          boxShadow: [
            BoxShadow(
              color: PortalColors.jtvJingga.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => context.go(RouteNames.live),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.live_tv, color: PortalColors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
