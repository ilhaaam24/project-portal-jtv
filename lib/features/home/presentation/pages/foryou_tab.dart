// lib/features/home/presentation/widgets/for_you_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/helper/format_date.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/home/domain/entities/for_you_entity.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_bloc.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_event.dart';
import 'package:portal_jtv/features/home/presentation/bloc/foryou/for_you_state.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';
import 'package:share_plus/share_plus.dart';
import 'package:portal_jtv/core/utils/auth_guard.dart';
import 'package:portal_jtv/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:portal_jtv/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:portal_jtv/core/services/toast_service.dart';

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
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      child: Card(
        elevation: 0,
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _navigateToDetail(context, item),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── GAMBAR ───
              Hero(
                tag: item.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
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
              ),

              const SizedBox(width: 12),

              // ─── TEKS ───
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/author.svg', height: 18),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            formatDate(item.date),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      item.categoryName != ""
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: PortalColors.jtvJingga,
                              ),
                              child: Text(
                                item.categoryName,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: PortalColors.white,
                                    ),
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                        width: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (checkAuthAndPrompt(context)) {
                                  context.read<BookmarkBloc>().add(
                                    AddBookmark(item.id),
                                  );
                                  ToastService.showSuccess(context, 'Berita disimpan');
                                }
                              },
                              child: Image.asset(
                                'assets/icons/bookmark-card.png',
                                height: 18,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                final url =
                                    'https://portaljtv.com/news/${item.seo}';
                                Share.share('${item.title}\n\n$url');
                              },
                              child: Image.asset(
                                'assets/icons/export-card.png',
                                height: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
