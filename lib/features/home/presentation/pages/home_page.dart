import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_event.dart';
import 'package:portal_jtv/features/home/presentation/bloc/populer/populer_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/populer/populer_event.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_event.dart';
import 'package:portal_jtv/features/home/presentation/pages/foryou_tab.dart';
import 'package:portal_jtv/features/home/presentation/pages/terbaru_tab.dart';
import 'package:portal_jtv/features/home/presentation/pages/populer_tab.dart';
import 'package:portal_jtv/config/injection/injection.dart' as di;
import 'package:portal_jtv/features/search/presentation/pages/search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<HomeBloc>()..add(const LoadHomeData()),
        ),
        BlocProvider(
          create: (_) => di.sl<PopulerBloc>(), // Lazy — belum load
        ),
        BlocProvider(
          create: (_) => di.sl<ForYouBloc>(), // Lazy — belum load
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();
  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  // Track tab mana yang sudah pernah di-load
  final Set<int> _loadedTabs = {0}; // Tab 0 (Terbaru) = auto load
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final index = _tabController.index;
    // Lazy loading: hanya load saat pertama kali tap tab
    if (!_loadedTabs.contains(index)) {
      _loadedTabs.add(index);
      switch (index) {
        case 1:
          context.read<PopulerBloc>().add(const LoadPopuler());
          break;
        case 2:
          context.read<ForYouBloc>().add(const LoadForYou());
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Image.asset('assets/logos/logo-jtv-white.png', height: 24),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
        actions: [
          GestureDetector(
            onTap: () {
              context.pushNamed('search');
            },
            child: Image.asset('assets/icons/search-normal.png', height: 24),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelPadding: const EdgeInsets.all(10),
          tabs: [
            Text(
              "TERBARU",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: PortalColors.white,
                fontSize: 14,
              ),
            ),
            Text(
              "TERPOPULER",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: PortalColors.white,
                fontSize: 14,
              ),
            ),
            Text(
              "FOR YOU",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: PortalColors.white,
                fontSize: 14,
              ),
            ),
          ],
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          indicatorWeight: 3,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [TerbaruTab(), PopulerTab(), ForYouTab()],
      ),
    );
  }
}
