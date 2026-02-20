// lib/features/search/presentation/pages/search_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../../../home/domain/entities/news_entity.dart';
import 'package:portal_jtv/config/injection/injection.dart' as di;

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SearchBloc>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SearchBloc>().add(const SearchLoadMore());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (query.trim().isNotEmpty) {
        context.read<SearchBloc>().add(SearchSubmitted(keyword: query));
      }
    });
  }

  void _onSearchSubmit(String query) {
    _debounce?.cancel();
    if (query.trim().isNotEmpty) {
      context.read<SearchBloc>().add(SearchSubmitted(keyword: query));
      FocusScope.of(context).unfocus();
    }
  }

  void _clearSearch() {
    _controller.clear();
    context.read<SearchBloc>().add(const SearchCleared());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text("Pencarian"),
        centerTitle: false,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                switch (state.status) {
                  // ─── INITIAL: Tampilkan History ───
                  case SearchStatus.initial:
                    return _buildHistory(state);

                  // ─── LOADING ───
                  case SearchStatus.loading:
                    return const Center(child: CircularProgressIndicator());

                  // ─── EMPTY ───
                  case SearchStatus.empty:
                    return _buildEmpty(state.keyword);

                  // ─── ERROR ───
                  case SearchStatus.failure:
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
                          Text(state.errorMessage ?? 'Terjadi kesalahan'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<SearchBloc>().add(
                              SearchSubmitted(keyword: state.keyword),
                            ),
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );

                  // ─── SUCCESS: Tampilkan Hasil ───
                  case SearchStatus.success:
                    return _buildResults(state);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── SEARCH BAR ───
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Cari berita...',
          border: InputBorder.none,
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _clearSearch,
                )
              : null,
        ),
        textInputAction: TextInputAction.search,
        onChanged: _onSearchChanged,
        onSubmitted: _onSearchSubmit,
      ),
    );
  }

  // ─── SEARCH HISTORY ───
  Widget _buildHistory(SearchState state) {
    if (state.searchHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Cari berita terkini',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pencarian Terakhir',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () =>
                    context.read<SearchBloc>().add(SearchHistoryCleared()),
                child: const Text(
                  'Hapus Semua',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),

        // History items
        Expanded(
          child: ListView.builder(
            itemCount: state.searchHistory.length,
            itemBuilder: (context, index) {
              final keyword = state.searchHistory[index];
              return ListTile(
                leading: const Icon(
                  Icons.history,
                  size: 20,
                  color: Colors.grey,
                ),
                title: Text(keyword),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                  onPressed: () => context.read<SearchBloc>().add(
                    SearchRemoveHistoryItem(keyword: keyword),
                  ),
                ),
                onTap: () {
                  _controller.text = keyword;
                  _onSearchSubmit(keyword);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── EMPTY STATE ───
  Widget _buildEmpty(String keyword) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Tidak ditemukan hasil untuk',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            '"$keyword"',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ─── SEARCH RESULTS ───
  Widget _buildResults(SearchState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: jumlah hasil
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'Hasil untuk "${state.keyword}" (${state.total})',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax
                ? state.results.length
                : state.results.length + 1,
            itemBuilder: (context, index) {
              // Loading indicator di bawah
              if (index >= state.results.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final news = state.results[index];
              return _SearchResultCard(
                news: news,
                onTap: () => _navigateToDetail(news),
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToDetail(NewsEntity news) {
    final args = DetailArgsEntity.fromNewsEntity(news);
    context.pushNamed('detail', extra: args);
  }
}

// ─── SEARCH RESULT CARD ───
class _SearchResultCard extends StatelessWidget {
  final NewsEntity news;
  final VoidCallback onTap;

  const _SearchResultCard({required this.news, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                news.photo,
                width: 110,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 110,
                  height: 75,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori
                  Text(
                    news.category,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Judul
                  Text(
                    news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Tanggal
                  Text(
                    news.date,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
