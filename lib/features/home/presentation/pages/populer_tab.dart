// lib/features/home/presentation/widgets/populer_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/core/network/connectivity_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/home/presentation/widgets/news_card.dart';
import 'package:portal_jtv/core/widgets/no_internet_widget.dart';
import '../bloc/populer/populer_bloc.dart';
import '../bloc/populer/populer_event.dart';
import '../bloc/populer/populer_state.dart';

class PopulerTab extends StatefulWidget {
  const PopulerTab({super.key});

  @override
  State<PopulerTab> createState() => _PopulerTabState();
}

class _PopulerTabState extends State<PopulerTab>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PopulerBloc>().add(const LoadMorePopuler());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    return _scrollController.offset >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Builder(
      builder: (context) {
        return BlocListener<ConnectivityCubit, ConnectivityState>(
          listener: (context, state) {
            if (state.isConnected) {
              context.read<PopulerBloc>().add(const LoadPopuler());
            }
          },
          child: BlocBuilder<PopulerBloc, PopulerState>(
            builder: (context, state) {
              if (state.status == PopulerStatus.failure) {
                if (state.errorMessage == "No internet connection") {
                  return NoInternetWidget(
                    onRetry: () =>
                        context.read<PopulerBloc>().add(const LoadPopuler()),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(state.errorMessage ?? 'Gagal memuat'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<PopulerBloc>().add(
                          const LoadPopuler(),
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              }

              final isLoading =
                  state.status == PopulerStatus.loading ||
                  state.status == PopulerStatus.initial;

              if (!isLoading && state.status == PopulerStatus.empty) {
                return const Center(child: Text('Tidak ada berita populer'));
              }

              final newsList = isLoading ? _dummyPopulerNews : state.news;

              return Skeletonizer(
                enabled: isLoading,
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<PopulerBloc>().add(const RefreshPopuler());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    controller: _scrollController,
                    itemCount: isLoading
                        ? newsList.length
                        : (state.hasReachedMax
                              ? newsList.length
                              : newsList.length + 1),
                    itemBuilder: (context, index) {
                      if (index >= newsList.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      return NewsCard(news: newsList[index]);
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

const _dummyNews = NewsEntity(
  idBerita: 0,
  title: 'Judul berita populer yang sedang dimuat oleh sistem JTV Portal',
  seo: '',
  seoBiro: '',
  status: '',
  photo: '',
  summary: '',
  caption: '',
  city: 'Surabaya',
  date: '2024-01-01',
  category: 'Populer',
  seoCategory: '',
  author: 'Author',
  seoAuthor: '',
  picAuthor: '',
  isYoutube: false,
);

final _dummyPopulerNews = List.generate(5, (index) => _dummyNews);
