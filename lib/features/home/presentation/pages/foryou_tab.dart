// lib/features/home/presentation/widgets/for_you_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/helper/format_date.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/home/domain/entities/for_you_entity.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_event.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_state.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';

class ForYouTab extends StatefulWidget {
  const ForYouTab({super.key});

  @override
  State<ForYouTab> createState() => _ForYouTabState();
}

class _ForYouTabState extends State<ForYouTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _navigateToDetail(BuildContext context, ForYouEntity item) {
    final args = DetailArgsEntity(
      idBerita: item.id,
      seo: item.seo,
      title: item.title,
      photo: item.photo,
      date: item.date,
      category: item.categoryName,
      seoCategory: '', // Akan di-load dari API detail
      author: '', // Akan di-load dari API detail
      picAuthor: '', // Akan di-load dari API detail
    );
    context.pushNamed('detail', extra: args);
  }

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
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.news.length,
                itemBuilder: (context, index) {
                  final item = state.news[index];
                  return _buildForYouCard(context, item);
                },
              ),
            );
        }
      },
    );
  }

  Widget _buildForYouCard(BuildContext context, ForYouEntity item) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _navigateToDetail(context, item),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── GAMBAR ───
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.photo,
                  width: 110,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 110,
                    height: 100,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ─── TEKS ───
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kategori
                    Text(
                      item.categoryName,
                      style: TextStyle(
                        fontSize: 12,
                        color: PortalColors.jtvBiru,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Judul
                    Text(
                      item.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Tanggal
                    Text(
                      formatDate(item.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
