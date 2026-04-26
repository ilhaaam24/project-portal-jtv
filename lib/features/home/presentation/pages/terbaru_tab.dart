import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/home/domain/entities/video_entity.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_event.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_state.dart';
import 'package:portal_jtv/features/home/presentation/widgets/headline_section.dart';
import 'package:portal_jtv/features/home/presentation/widgets/news_card.dart';
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
                if (state.status == HomeStatus.failure) {
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
                }

                final isLoading =
                    state.status == HomeStatus.loading ||
                    state.status == HomeStatus.initial;

                return Skeletonizer(
                  enabled: isLoading,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<HomeBloc>().add(const RefreshHomeData());
                    },
                    child: Scrollbar(
                      radius: const Radius.circular(20),
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          // 2. Headlines Carousel
                          if (isLoading || state.headlines.isNotEmpty)
                            SliverToBoxAdapter(
                              child: buildHeadlinesSection(
                                isLoading ? _dummyHomeState : state,
                              ),
                            ),

                          // 3. Video Section
                          if (isLoading || state.videos.isNotEmpty)
                            SliverToBoxAdapter(
                              child: VideoSection(
                                videos: isLoading ? _dummyVideos : state.videos,
                              ),
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
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final newsList = isLoading
                                    ? _dummyLatestNews
                                    : state.latestNews;

                                if (index >= newsList.length) {
                                  if (isLoading) return const SizedBox.shrink();
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

                                final news = newsList[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: NewsCard(news: news),
                                );
                              },
                              childCount: isLoading
                                  ? _dummyLatestNews.length
                                  : state.latestNews.length + 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
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

const _dummyNews = NewsEntity(
  idBerita: 0,
  title: 'Judul berita yang sedang dimuat oleh sistem JTV Portal',
  seo: '',
  seoBiro: '',
  status: '',
  photo: '',
  summary: '',
  caption: '',
  city: 'Surabaya',
  date: '2024-01-01',
  category: 'Kategori',
  seoCategory: '',
  author: 'Author',
  seoAuthor: '',
  picAuthor: '',
  isYoutube: false,
);

final _dummyLatestNews = List.generate(5, (index) => _dummyNews);

const _dummyVideo = VideoEntity(
  id: 0,
  youtubeId: '',
  title: 'Video sedang dimuat...',
  thumbnail: '',
  date: '2024-01-01',
);

final _dummyVideos = List.generate(3, (index) => _dummyVideo);

final _dummyHomeState = HomeState(
  status: HomeStatus.loading,
  headlines: _dummyLatestNews,
  videos: _dummyVideos,
  latestNews: _dummyLatestNews,
);
