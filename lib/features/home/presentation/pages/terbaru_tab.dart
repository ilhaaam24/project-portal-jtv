import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_event.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_state.dart';
import 'package:portal_jtv/features/home/presentation/widgets/headline_carousel.dart';
import 'package:portal_jtv/features/home/presentation/widgets/news_card.dart';
import 'package:portal_jtv/features/home/presentation/widgets/sorot_section.dart';
import 'package:portal_jtv/features/home/presentation/widgets/tittle_section.dart';
import 'package:portal_jtv/features/home/presentation/widgets/video_section2.dart';

class TerbaruTab extends StatefulWidget {
  const TerbaruTab({super.key});

  @override
  State<TerbaruTab> createState() => _TerbaruTabState();
}

class _TerbaruTabState extends State<TerbaruTab> {
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
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
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
                              context.read<HomeBloc>().add(
                                const LoadHomeData(),
                              );
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
                        radius: const Radius.circular(20),
                        child: CustomScrollView(
                          controller: _scrollController,
                          slivers: [
                            // 1. Breaking News Section
                            // if (state.breakingNews.isNotEmpty)
                            //   SliverToBoxAdapter(
                            //     child: buildBreakingNewsSection(state),
                            //   ),

                            // 2. Headlines Carousel
                            if (state.headlines.isNotEmpty)
                              SliverToBoxAdapter(
                                child: HeadlineCarousel(
                                  headlines: state.headlines,
                                ),
                              ),

                            // 3. Video Section
                            if (state.videos.isNotEmpty)
                              SliverToBoxAdapter(
                                child: VideoSection(videos: state.videos),
                              ),

                            // 4. Sorot Section
                            if (state.sorot.isNotEmpty)
                              SliverToBoxAdapter(
                                child: buildSorotSection(state),
                              ),

                            // 5. Section Title - Berita Terbaru
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: TittleSection(title: "Berita Terbaru"),
                              ),
                            ),

                            // 6. Latest News List (Infinite Scroll)
                            SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
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
                                return buildNewsCard(news, context);
                              }, childCount: state.latestNews.length + 1),
                            ),
                          ],
                        ),
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
