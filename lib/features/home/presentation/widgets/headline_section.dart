import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/helper/format_date.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/home/presentation/bloc/terbaru/terbaru_state.dart';
import 'package:portal_jtv/features/home/presentation/widgets/tittle_section.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget buildHeadlinesSection(HomeState state) {
  final PageController pageController = PageController(viewportFraction: 0.9);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TittleSection(title: 'Headline'),
      ),
      SizedBox(
        height: 340, // Total height to accommodate the card content
        child: PageView.builder(
          controller: pageController,
          itemCount: state.headlines.length,
          itemBuilder: (context, index) {
            final headline = state.headlines[index];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Card(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade300, width: .5),
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    final args = DetailArgsEntity.fromNewsEntity(headline);
                    context.pushNamed("detail", extra: args);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton.leaf(
                        enabled: true,
                        child: CachedNetworkImage(
                          imageUrl: headline.photo,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 180,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 180,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // ← ini kuncinya
                            children: [
                              // 🔼 BAGIAN ATAS (kategori, tanggal, judul)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Skeleton.leaf(
                                        enabled: true,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: PortalColors.jtvJingga,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            headline.category,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        formatDate(headline.date),
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  Text(
                                    headline.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          height: 1.3,
                                        ),
                                  ),
                                ],
                              ),

                              // 🔽 BAGIAN BAWAH (author + icons)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/author.svg',
                                          height: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            headline.author,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/bookmark-card.png',
                                        height: 20,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 12),
                                      Image.asset(
                                        'assets/icons/export-card.png',
                                        height: 20,
                                        color: Colors.grey.shade600,
                                      ),
                                    ],
                                  ),
                                ],
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
          },
        ),
      ),
    ],
  );
}
