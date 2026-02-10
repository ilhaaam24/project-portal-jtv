import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/home_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/home_event.dart';
import 'package:portal_jtv/features/home/presentation/bloc/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HomeBloc>().add(const LoadMoreLatestNews());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger 200px sebelum bottom
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Portal Berita'), centerTitle: true),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          switch (state.status) {
            case HomeStatus.initial:
            case HomeStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case HomeStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage ?? 'Terjadi kesalahan'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(const LoadHomeData());
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );

            case HomeStatus.success:
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(const RefreshHomeData());
                },
                child: Scrollbar(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // 1. Breaking News Section
                      if (state.breakingNews.isNotEmpty)
                        SliverToBoxAdapter(
                          child: _buildBreakingNewsSection(state),
                        ),

                      // 2. Headlines Carousel
                      if (state.headlines.isNotEmpty)
                        SliverToBoxAdapter(
                          child: _buildHeadlinesSection(state),
                        ),

                      // 3. Video Section
                      if (state.videos.isNotEmpty)
                        SliverToBoxAdapter(child: _buildVideosSection(state)),

                      // 4. Sorot Section
                      if (state.sorot.isNotEmpty)
                        SliverToBoxAdapter(child: _buildSorotSection(state)),

                      // 5. Section Title - Berita Terbaru
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Berita Terbaru',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // 6. Latest News List (Infinite Scroll)
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index >= state.latestNews.length) {
                            // Loading indicator di bottom
                            return state.hasReachedMax
                                ? const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: Text(
                                        'Semua berita sudah ditampilkan',
                                      ),
                                    ),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                          }

                          final news = state.latestNews[index];
                          return _buildNewsCard(news);
                        }, childCount: state.latestNews.length + 1),
                      ),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }

  Widget _buildBreakingNewsSection(HomeState state) {
    return Container(
      color: Colors.red.shade50,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔴 BREAKING NEWS',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 8),
          ...state.breakingNews.map((news) => Text('• ${news.title}')),
        ],
      ),
    );
  }

  Widget _buildHeadlinesSection(HomeState state) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: state.headlines.length,
        itemBuilder: (context, index) {
          final headline = state.headlines[index];
          return Card(
            margin: const EdgeInsets.all(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  headline.photo,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(color: Colors.grey),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Text(
                    headline.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideosSection(HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '📺 Video Terbaru',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.videos.length,
            itemBuilder: (context, index) {
              final video = state.videos[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          video.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              Container(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSorotSection(HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '🔦 Sorotan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.sorot.length,
            itemBuilder: (context, index) {
              final sorot = state.sorot[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        sorot.photo,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            Container(color: Colors.grey),
                      ),
                      Container(color: Colors.black38),
                      Center(
                        child: Text(
                          sorot.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewsCard(dynamic news) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            news.photo,
            width: 80,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                Container(width: 80, height: 60, color: Colors.grey),
          ),
        ),
        title: Text(news.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text('${news.category} • ${news.date}'),
        onTap: () {},
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
