import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/config/injection/injection.dart';
import 'package:portal_jtv/config/routes/route_names.dart';
import 'package:portal_jtv/core/widgets/main_layout.dart';
import 'package:portal_jtv/features/bookmark/presentation/pages/bookmark_page.dart';
import 'package:portal_jtv/features/category/presentation/pages/category_news_page.dart';
import 'package:portal_jtv/features/category/presentation/pages/category_page.dart';
import 'package:portal_jtv/features/home/presentation/pages/home_page.dart';
import 'package:portal_jtv/features/live/presentation/pages/live_page.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_bloc.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_event.dart';
import 'package:portal_jtv/features/news_detail/presentation/cubit/text_size_cubit.dart';
import 'package:portal_jtv/features/news_detail/presentation/cubit/text_to_speech_cubit.dart';
import 'package:portal_jtv/features/news_detail/presentation/pages/detail_page.dart';
import 'package:portal_jtv/features/profile/domain/entities/profile_entity.dart';
import 'package:portal_jtv/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:portal_jtv/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:portal_jtv/features/profile/presentation/pages/faq_page.dart';
import 'package:portal_jtv/features/profile/presentation/pages/profile_page.dart';
import 'package:portal_jtv/features/search/presentation/bloc/search_bloc.dart';
import 'package:portal_jtv/features/search/presentation/pages/search_page.dart';
import 'package:portal_jtv/features/home/domain/entities/video_entity.dart';
import 'package:portal_jtv/features/video_detail/presentation/bloc/video_detail_bloc.dart';
import 'package:portal_jtv/features/video_detail/presentation/pages/video_detail_page.dart';
import 'package:portal_jtv/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:portal_jtv/features/comment/presentation/bloc/comment_event.dart';
import 'package:portal_jtv/features/comment/presentation/pages/comment_page.dart';

final router = GoRouter(
  initialLocation: RouteNames.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainLayout(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.home,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.category,
              builder: (context, state) => const CategoryPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.live,
              builder: (context, state) => const LivePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.bookmark,
              builder: (context, state) => const BookmarkPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.profile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RouteNames.detail,
      name: 'detail',
      builder: (_, state) {
        final args = state.extra as DetailArgsEntity;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<DetailBloc>()..add(LoadDetail(seo: args.seo)),
            ),
            BlocProvider(create: (_) => sl<TextSizeCubit>()),
            BlocProvider(create: (_) => sl<TextToSpeechCubit>()),
          ],
          child: DetailPage(args: args),
        );
      },
    ),
    GoRoute(
      path: RouteNames.faq,
      name: 'faq',
      builder: (context, state) => const FaqPage(),
    ),
    GoRoute(
      path: RouteNames.categoryNews,
      name: 'category-news',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return CategoryNewsPage(
          seo: args['seo'] as String,
          title: args['title'] as String,
          isBiro: args['isBiro'] as bool? ?? false,
        );
      },
    ),
    GoRoute(
      path: RouteNames.edit,
      name: 'edit',
      builder: (context, state) {
        final profile = state.extra as ProfileEntity;
        return BlocProvider(
          create: (_) => sl<ProfileBloc>(),
          child: EditProfilePage(profile: profile),
        );
      },
    ),
    GoRoute(
      path: RouteNames.search,
      name: 'search',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<SearchBloc>(),
          child: const SearchPage(),
        );
      },
    ),
    GoRoute(
      path: RouteNames.videoDetail,
      name: 'video-detail',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final videos = args['videos'] as List<VideoEntity>;
        final index = args['initialIndex'] as int;
        return BlocProvider(
          create: (_) => sl<VideoDetailBloc>(),
          child: VideoDetailPage(initialVideos: videos, initialIndex: index),
        );
      },
    ),
    GoRoute(
      path: RouteNames.comments,
      name: 'comments',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final idBerita = args['idBerita'] as int;
        return BlocProvider(
          create: (_) =>
              sl<CommentBloc>()..add(LoadComments(idBerita: idBerita)),
          child: CommentPage(
            idBerita: idBerita,
            title: args['title'] as String,
            category: args['category'] as String,
            author: args['author'] as String,
            date: args['date'] as String,
          ),
        );
      },
    ),
  ],
);
