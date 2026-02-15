// lib/features/home/presentation/widgets/populer_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/features/home/presentation/widgets/news_card.dart';
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

    return BlocBuilder<PopulerBloc, PopulerState>(
      builder: (context, state) {
        switch (state.status) {
          case PopulerStatus.initial:
          case PopulerStatus.loading:
            return const Center(child: CircularProgressIndicator());

          case PopulerStatus.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'Gagal memuat'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<PopulerBloc>().add(const LoadPopuler()),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );

          case PopulerStatus.empty:
            return const Center(child: Text('Tidak ada berita populer'));

          case PopulerStatus.success:
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PopulerBloc>().add(const RefreshPopuler());
              },
              child: ListView.builder(
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

                  return buildNewsCard(
                    state.news[index],
                    context,
                  );
                },
              ),
            );
        }
      },
    );
  }
}
