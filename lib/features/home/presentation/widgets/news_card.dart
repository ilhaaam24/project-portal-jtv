import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/helper/format_date.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/core/utils/auth_guard.dart';
import 'package:portal_jtv/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:portal_jtv/features/bookmark/presentation/bloc/bookmark_event.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';
import 'package:share_plus/share_plus.dart';
import 'package:portal_jtv/core/services/toast_service.dart';

class NewsCard extends StatelessWidget {
  final NewsEntity news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
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
          onTap: () {
            final args = DetailArgsEntity.fromNewsEntity(news);
            context.pushNamed("detail", extra: args);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── GAMBAR ───
              Hero(
                tag: news.idBerita,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    news.photo,
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
                      news.title,
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
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      news.category != ""
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
                                news.category,
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
                                    AddBookmark(news.idBerita),
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
                                    'https://portaljtv.com/${news.seoCategory}/${news.seo}';
                                Share.share('${news.title}\n\n$url');
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
