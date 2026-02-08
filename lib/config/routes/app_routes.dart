import 'package:go_router/go_router.dart';
import 'package:portal_jtv/config/routes/route_names.dart';
import 'package:portal_jtv/core/widgets/main_layout.dart';
import 'package:portal_jtv/features/bookmark/presentation/pages/bookmark_page.dart';
import 'package:portal_jtv/features/home/presentation/pages/home_page.dart';
import 'package:portal_jtv/features/live/presentation/pages/live_page.dart';
import 'package:portal_jtv/features/profile/presentation/pages/profile_page.dart';

final router = GoRouter(
  initialLocation: RouteNames.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(path: RouteNames.home, builder: (_, _) => const HomePage()),
        GoRoute(path: RouteNames.live, builder: (_, _) => const LivePage()),
        GoRoute(
          path: RouteNames.bookmark,
          builder: (_, _) => const BookmarkPage(),
        ),
        GoRoute(
          path: RouteNames.profile,
          builder: (_, _) => const ProfilePage(),
        ),
      ],
    ),
  ],
);
