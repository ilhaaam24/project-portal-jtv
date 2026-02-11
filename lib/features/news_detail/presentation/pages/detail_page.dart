import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/core/utils/text_size_preferences.dart';
import 'package:portal_jtv/core/utils/text_to_speech.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_bloc.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_event.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_state.dart';
import 'package:portal_jtv/features/news_detail/presentation/cubit/text_size_cubit.dart';
import 'package:portal_jtv/features/news_detail/presentation/widgets/tts_section.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_html/flutter_html.dart';

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
                  expandedHeight: 250,
                  pinned: true,
                  actions: [
                    // Tombol Text Size
                    IconButton(
                      icon: const Icon(Icons.text_fields),
                      onPressed: () => _showTextSizeSheet(context),
                    ),
                    // Tombol Bookmark (optimistic update)
                    IconButton(
                      icon: Icon(
                        state.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      onPressed: () {
                        context.read<DetailBloc>().add(const ToggleBookmark());
                      },
                    ),
                    // Tombol Share
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => _shareArticle(state),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,

                    // Foto langsung tampil dari args (pre-populated)
                    background: Image.network(
                      args.photo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(color: Colors.grey),
                    ),
                  ),
                ),

                // Konten
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        _buildContent(context, state),
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

  Widget _buildContent(BuildContext context, DetailState state) {
    switch (state.status) {
      case DetailStatus.initial:
      case DetailStatus.loading:
        // Shimmer / loading placeholder
        return Column(
          children: List.generate(
            5,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        );

      case DetailStatus.failure:
        return Center(
          child: Column(
            children: [
              Text(state.errorMessage ?? 'Gagal memuat berita'),
              ElevatedButton(
                onPressed: () {
                  context.read<DetailBloc>().add(LoadDetail(seo: args.seo));
                },
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        );

      case DetailStatus.success:
        return BlocBuilder<TextSizeCubit, double>(
          builder: (context, fontSize) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Views + Editor
                Row(
                  children: [
                    Icon(Icons.visibility, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${state.detail!.hit} views'),
                    const SizedBox(width: 16),
                    if (state.detail!.editorBerita != null) ...[
                      Icon(Icons.edit, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Editor: ${state.detail!.editorBerita}'),
                    ],
                  ],
                ),
                const Divider(height: 24),

                TtsSection(
                  content: TextToSpeech.stripHtml(state.detail!.content),
                ),

                const Divider(height: 24),
                Html(
                  data: state.detail!.content,
                  style: {'body': Style(fontSize: FontSize(fontSize))},
                ),

                const SizedBox(height: 16),

                // Tags
                Wrap(
                  spacing: 8,
                  children: state.tags.map((tag) {
                    return ActionChip(label: Text(tag.name), onPressed: () {});
                  }).toList(),
                ),
              ],
            );
          },
        );
    }
  }

  void _showTextSizeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<TextSizeCubit>(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: BlocBuilder<TextSizeCubit, double>(
              builder: (ctx, fontSize) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Ukuran Teks',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.text_decrease),
                          onPressed: () => ctx.read<TextSizeCubit>().decrease(),
                        ),
                        Text(
                          '${fontSize.toInt()}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.text_increase),
                          onPressed: () => ctx.read<TextSizeCubit>().increase(),
                        ),
                      ],
                    ),
                    Slider(
                      value: fontSize,
                      min: TextSizePreferences.minSize,
                      max: TextSizePreferences.maxSize,
                      divisions: 8,
                      label: '${fontSize.toInt()}',
                      onChanged: (val) =>
                          ctx.read<TextSizeCubit>().setSize(val),
                    ),
                    TextButton(
                      onPressed: () => ctx.read<TextSizeCubit>().reset(),
                      child: const Text('Reset ke Default'),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _shareArticle(DetailState state) {
    final url = 'https://yourdomain.com/${args.seo}';
    SharePlus.instance.share(ShareParams(text: '${args.title}\n\n$url'));
  }
}
