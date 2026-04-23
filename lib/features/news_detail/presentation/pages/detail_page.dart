import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/helper/format_date.dart';
import 'package:portal_jtv/core/navigation/navigation_cubit.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_bloc.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_event.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_state.dart';
import 'package:portal_jtv/features/news_detail/presentation/widgets/detail_content.dart';
import 'package:portal_jtv/features/news_detail/presentation/widgets/related_news_content.dart';
import 'package:portal_jtv/features/news_detail/presentation/widgets/text_size_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:portal_jtv/core/utils/auth_guard.dart';
import 'package:portal_jtv/core/services/toast_service.dart';

class DetailPage extends StatelessWidget {
  final DetailArgsEntity args;

  const DetailPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailBloc, DetailState>(
        builder: (context, state) {
          return Scrollbar(
            thickness: 4,
            radius: const Radius.circular(20),
            child: CustomScrollView(
              slivers: [
                // AppBar dengan actions
                SliverAppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  pinned: true,
                  centerTitle: false,
                  title: Image.asset(
                    'assets/logos/logo-jtv-white.png',
                    height: 24,
                  ),
                  actions: [
                    // Tombol Text Size
                    IconButton(
                      icon: const Icon(Icons.text_fields),
                      onPressed: () => showTextSizeSheet(context),
                    ),

                    // Tombol Bookmark (optimistic update)
                    GestureDetector(
                      onTap: () {
                        if (!checkAuthAndPrompt(context)) return;
                        context.read<DetailBloc>().add(const ToggleBookmark());
                        if (!state.isSaved) {
                          ToastService.showSuccess(
                            context,
                            'Berita disimpan',
                            action: BlocBuilder<NavigationCubit, int>(
                              builder: (context, state) {
                                return TextButton(
                                  onPressed: () {
                                    context
                                        .read<NavigationCubit>()
                                        .changeIndex(3);
                                    context.go('/bookmark');
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 30),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Lihat',
                                    style: TextStyle(
                                      color: PortalColors.jtvJingga,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          ToastService.showInfo(context, 'Berita dihapus dari simpanan');
                        }
                      },
                      child: Icon(
                        state.isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: state.isSaved
                            ? PortalColors.jtvJingga
                            : PortalColors.white,
                      ),
                    ),

                    // Tombol Share
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => _shareArticle(state),
                    ),
                  ],
                ),

                // Konten
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Categori (dari args, langsung tampil)
                        Text(
                          args.category,
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(
                                color: PortalColors.jtvBiru,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                        ),

                        const SizedBox(height: 8),
                        // Judul (dari args, LANGSUNG TAMPIL)
                        Text(
                          args.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Author (dari args, langsung tampil)
                        Text(
                          '${args.author} • ${formatDate(args.date)}',
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(
                                color: PortalColors.grey700,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Hero(
                          tag: '${args.idBerita}',
                          child: Image.network(
                            args.photo,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                Container(color: Colors.grey),
                          ),
                        ),

                        // Kategori + Tanggal (dari args, langsung tampil)
                        const SizedBox(height: 16),

                        // ===== KONTEN DARI API (loading/success) =====
                        buildContent(context, state, args),

                        const SizedBox(height: 16),

                        if (state.status == DetailStatus.success)
                          RelatedNewsContent(relatedNews: state.relatedNews),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _shareArticle(DetailState state) {
    final url = 'https://portaljtv.com/news/${args.seo}';
    SharePlus.instance.share(ShareParams(text: '${args.title}\n\n$url'));
  }
}
