import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/helper/format_date.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/home/domain/entities/news_entity.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';

Widget buildNewsCard(NewsEntity news, BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
      ),
    ),
    child: Card(
      // shape: RoundedRectangleBorder(
      //   side: BorderSide(
      //     color: isDark ? Colors.grey.shade700 : Colors.grey.shade500,
      //   ),
      //   borderRadius: BorderRadius.circular(8),
      // ),
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
                  height: 100, // ← bebas atur tinggi di sini
                  fit: BoxFit.cover, // ← cover lebih baik untuk thumbnail
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
                // mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    maxLines: 3, // ← bisa lebih banyak baris
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
                  crossAxisAlignment: .end,
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    news.category != ""
                        ? Container(
                            padding: EdgeInsets.symmetric(
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
                        : SizedBox(),
                    SizedBox(
                      width: 50,
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Image.asset(
                            'assets/icons/bookmark-card.png',
                            height: 18,
                          ),
                          Image.asset(
                            'assets/icons/export-card.png',
                            height: 18,
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
