import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/navigation/navigation_cubit.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_bloc.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_event.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_state.dart';
import 'package:portal_jtv/features/news_detail/presentation/widgets/detail_content.dart';
import 'package:portal_jtv/features/news_detail/presentation/widgets/text_size_sheet.dart';
import 'package:share_plus/share_plus.dart';

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
                  actions: [
                    // Tombol Text Size
                    IconButton(
                      icon: const Icon(Icons.text_fields),
                      onPressed: () => showTextSizeSheet(context),
                    ),

                    // Tombol Bookmark (optimistic update)
                    GestureDetector(
                      onTap: () {
                        context.read<DetailBloc>().add(const ToggleBookmark());
                        if (!state.isSaved) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Text('Berita disimpan'),
                                  BlocBuilder<NavigationCubit, int>(
                                    builder: (context, state) {
                                      return TextButton(
                                        onPressed: () {
                                          context
                                              .read<NavigationCubit>()
                                              .changeIndex(3);
                                          context.go('/bookmark');
                                        },
                                        child: Text(
                                          'Lihat',
                                          style: TextStyle(
                                            color: PortalColors.jtvJingga,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Berita dihapus dari simpanan'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      child: Icon(
                        state.isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: state.isSaved
                            ? PortalColors.jtvJingga
                            : Colors.grey,
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
                        Image.network(
                          args.photo,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              Container(color: Colors.grey),
                        ),
                        // Kategori + Tanggal (dari args, langsung tampil)
                        Text(
                          '${args.category} • ${args.date}',
                          style: TextStyle(color: Colors.blue, fontSize: 13),
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
                        const SizedBox(height: 12),

                        // Author (dari args, langsung tampil)
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(args.picAuthor),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              args.author,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ===== KONTEN DARI API (loading/success) =====
                        buildContent(context, state, args),
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
    final url = 'https://yourdomain.com/${args.seo}';
    SharePlus.instance.share(ShareParams(text: '${args.title}\n\n$url'));
  }
}
