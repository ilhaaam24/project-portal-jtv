// lib/features/home/presentation/widgets/for_you_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_event.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_state.dart';

class ForYouTab extends StatefulWidget {
  const ForYouTab({super.key});

  @override
  State<ForYouTab> createState() => _ForYouTabState();
}

class _ForYouTabState extends State<ForYouTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<ForYouBloc, ForYouState>(
      builder: (context, state) {
        switch (state.status) {
          case ForYouStatus.initial:
          case ForYouStatus.loading:
            return const Center(child: CircularProgressIndicator());

          case ForYouStatus.failure:
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
                        context.read<ForYouBloc>().add(const LoadForYou()),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );

          case ForYouStatus.empty:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.recommend, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada rekomendasi',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Login dan pilih minat Anda untuk mendapatkan rekomendasi',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );

          case ForYouStatus.success:
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ForYouBloc>().add(const RefreshForYou());
              },
              child: ListView.builder(
                itemCount: state.news.length,
                itemBuilder: (context, index) {
                  final item = state.news[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.photo,
                        width: 80,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 80,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image),
                        ),
                      ),
                    ),
                    title: Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      '${item.categoryName} • ${item.date}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    onTap: () {
                      // Navigate ke detail
                    },
                  );
                },
              ),
            );
        }
      },
    );
  }
}
