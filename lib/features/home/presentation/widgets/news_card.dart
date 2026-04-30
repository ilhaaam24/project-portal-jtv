import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/helper/format_date.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/core/utils/auth_guard.dart';
import 'package:portal_jtv/features/bookmark/domain/usecases/delete_saved_news.dart';
import 'package:portal_jtv/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:portal_jtv/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:portal_jtv/features/bookmark/presentation/bloc/bookmark_state.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';
import 'package:portal_jtv/features/news_detail/domain/usecases/remove_bookmark.dart';
import 'package:share_plus/share_plus.dart';
import 'package:portal_jtv/core/services/toast_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewsCard extends StatelessWidget {
  final NewsEntity news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: .5),
        ),
      ),
      child: Card(
        elevation: 0,
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            final args = DetailArgsEntity.fromNewsEntity(news);
            context.pushNamed("detail", extra: args);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── GAMBAR ───
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Skeleton.leaf(
                  enabled: true,
                  child: CachedNetworkImage(
                    imageUrl: news.photo,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 90,
                      height: 90,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
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
                            '${news.author} • ${formatDate(news.date)}',
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
              const SizedBox(width: 8),
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      news.category != ""
                          ? Skeleton.leaf(
                              enabled: true,
                              child: Container(
                                width: 70,

                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: PortalColors.jtvJingga,
                                ),
                                child: Text(
                                  news.category,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: PortalColors.white,
                                      ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(
                        width: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocBuilder<BookmarkBloc, BookmarkState>(
                              builder: (context, state) {
                                final isSaved = state.savedNews.any(
                                  (item) => item.idBerita == news.idBerita,
                                );
                                return GestureDetector(
                                  onTap: () {
                                    if (checkAuthAndPrompt(context)) {
                                      if (isSaved) {
                                        context.read<BookmarkBloc>().add(
                                          DeleteBookmark(
                                            idBerita: news.idBerita,
                                            index: state.savedNews.indexWhere(
                                              (item) =>
                                                  item.idBerita ==
                                                  news.idBerita,
                                            ),
                                          ),
                                        );
                                        ToastService.showInfo(
                                          context,
                                          'Berita berhasil dihapus dari daftar simpan',
                                        );
                                      } else {
                                        context.read<BookmarkBloc>().add(
                                          AddBookmark(news.idBerita),
                                        );
                                        ToastService.showSuccess(
                                          context,
                                          'Berita disimpan',
                                        );
                                      }
                                    }
                                  },
                                  child: Image.asset(
                                    isSaved
                                        ? 'assets/icons/bookmark-active.png'
                                        : 'assets/icons/bookmark-card.png',
                                    height: 18,
                                  ),
                                );
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                final url =
                                    'https://portaljtv.com/${news.seoCategory}/${news.seo}';
                                SharePlus.instance.share(
                                  ShareParams(
                                    uri: Uri.parse(url),
                                    subject: news.title,
                                  ),
                                );
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
