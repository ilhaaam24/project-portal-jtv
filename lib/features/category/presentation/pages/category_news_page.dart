// lib/features/category/presentation/pages/category_news_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/features/category/presentation/bloc/category_news/category_news_bloc.dart';
import 'package:portal_jtv/features/category/presentation/bloc/category_news/category_news_event.dart';
import 'package:portal_jtv/features/category/presentation/bloc/category_news/category_news_state.dart';
import '../../../home/presentation/widgets/news_card.dart'; // Reuse
import 'package:portal_jtv/config/injection/injection.dart' as di;

class CategoryNewsPage extends StatelessWidget {
  final String seo;
  final String title;
  final bool isBiro;

  const CategoryNewsPage({
    super.key,
    required this.seo,
    required this.title,
    this.isBiro = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          di.sl<CategoryNewsBloc>()
            ..add(LoadCategoryNews(seo: seo, title: title, isBiro: isBiro)),
      child: const _CategoryNewsView(),
    );
  }
}

class _CategoryNewsView extends StatefulWidget {
  const _CategoryNewsView();

  @override
  State<_CategoryNewsView> createState() => _CategoryNewsViewState();
}

class _CategoryNewsViewState extends State<_CategoryNewsView> {
  final ScrollController _scrollController = ScrollController();

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
      context.read<CategoryNewsBloc>().add(const LoadMoreCategoryNews());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    return _scrollController.offset >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryNewsBloc, CategoryNewsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.title.isNotEmpty ? state.title : 'Berita'),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(CategoryNewsState state) {
    switch (state.status) {
      case CategoryNewsStatus.initial:
      case CategoryNewsStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case CategoryNewsStatus.failure:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(state.errorMessage ?? 'Gagal memuat'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<CategoryNewsBloc>().add(
                  LoadCategoryNews(
                    seo: state.seo,
                    title: state.title,
                    isBiro: state.isBiro,
                  ),
                ),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        );

      case CategoryNewsStatus.empty:
        return const Center(child: Text('Tidak ada berita di kategori ini'));

      case CategoryNewsStatus.success:
        return ListView.builder(
          controller: _scrollController,
          itemCount: state.hasReachedMax
              ? state.news.length
              : state.news.length + 1,
          itemBuilder: (context, index) {
            if (index >= state.news.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return buildNewsCard(state.news[index], context);
          },
        );
    }
  }
}
