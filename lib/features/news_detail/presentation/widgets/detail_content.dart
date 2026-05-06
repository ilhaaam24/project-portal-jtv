import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/core/utils/text_to_speech.dart';
import 'package:portal_jtv/features/comment/presentation/widgets/comment_preview.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/detail_args_entity.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_bloc.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_event.dart';
import 'package:portal_jtv/features/news_detail/presentation/bloc/news_details_state.dart';
import 'package:portal_jtv/features/news_detail/presentation/cubit/text_size_cubit.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/news_detail_entity.dart';
import 'package:portal_jtv/features/news_detail/domain/entities/tag_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:portal_jtv/features/news_detail/presentation/widgets/tts_section.dart';

Widget buildContent(
  BuildContext context,
  DetailState state,
  DetailArgsEntity args,
) {
  return BlocBuilder<TextSizeCubit, double>(
    builder: (context, fontSize) {
      if (state.status == DetailStatus.failure) {
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
      }

      final isLoading =
          state.status == DetailStatus.loading ||
          state.status == DetailStatus.initial;

      return Skeletonizer(
        enabled: isLoading,
        // config: const SkeletonizerConfigData(
        //   boneBorderRadius: BorderRadius.all(Radius.circular(0)),
        // ),
        child: _ContentBody(
          detail: isLoading ? _dummyDetail : state.detail!,
          tags: isLoading ? const [] : state.tags,
          args: args,
          fontSize: fontSize,
        ),
      );
    },
  );
}

class _ContentBody extends StatelessWidget {
  final NewsDetailEntity detail;
  final List<TagEntity> tags;
  final DetailArgsEntity args;
  final double fontSize;

  const _ContentBody({
    required this.detail,
    required this.tags,
    required this.args,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeleton.leaf(
          enabled: true,
          child: CachedNetworkImage(
            imageUrl: detail.photo,
            fit: BoxFit.cover,
            placeholder: (context, url) => AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.grey.shade200,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
            errorWidget: (context, url, error) => AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(color: Colors.grey),
            ),
          ),
        ),
        // else
        //   AspectRatio(
        //     aspectRatio: 16 / 9,
        //     child: Container(color: Colors.grey.shade200),
        //   ),
        // Views + Editor
        const SizedBox(height: 16),
        Row(
          children: [
            Container(width: 4, height: 40, color: PortalColors.jtvJingga),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                detail.caption.isEmpty ? 'Loading caption...' : detail.caption,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const Divider(height: 24),

        TtsSection(content: TextToSpeech.stripHtml(detail.content)),

        const Divider(height: 24),

        Skeleton.replace(
          replacement: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Bone(
                  height: 14,
                  width: index == 4 ? 200 : double.infinity,
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
          child: Html(
            data: detail.content,
            style: {
              'body': Style(
                fontSize: FontSize(fontSize),
                textAlign: TextAlign.justify,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            },
          ),
        ),
        const SizedBox(height: 8),

        // Tags
        if (tags.isNotEmpty)
          Wrap(
            spacing: 8,
            children: tags.map((tag) {
              return ActionChip(
                label: Text(
                  tag.name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: PortalColors.jtvBiru),
                ),
                tooltip: tag.name,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: PortalColors.jtvBiru.withValues(alpha: 0.5),
                  ),
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                backgroundColor: PortalColors.white,
                onPressed: () {},
              );
            }).toList(),
          )
        else if (Skeletonizer.of(context).enabled)
          Wrap(
            spacing: 8,
            children: List.generate(
              3,
              (index) => const Bone(width: 60, borderRadius: BorderRadius.zero),
            ),
          ),

        // Comment Preview Section
        CommentPreview(
          idBerita: detail.idBerita,
          title: detail.title,
          category: detail.category,
          author: detail.author,
          date: detail.date,
          photo: detail.photo,
          seo: detail.seo,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

const _dummyDetail = NewsDetailEntity(
  idBerita: 0,
  title:
      'Judul berita yang sedang dimuat oleh sistem JTV Portal untuk memberikan visualisasi loading yang presisi',
  seoBiro: '',
  seo: '',
  content:
      '<p><strong>SURABAYA - </strong> Ini adalah konten dummy untuk skeleton loader agar terlihat natural saat memuat data dari API JTV Portal. Konten ini sengaja dibuat lebih panjang untuk meniru tampilan berita aslinya yang biasanya terdiri dari beberapa paragraf dengan informasi yang detail.</p><p>Paragraf kedua ditambahkan untuk memastikan layout skeleton mencakup area konten yang cukup luas, sehingga tidak terjadi lonjakan visual (layout shift) yang signifikan saat data asli berhasil dimuat.</p>',
  summary: '',
  photo: '',
  caption: 'Caption berita yang sedang dimuat...',
  status: '',
  city: 'Surabaya',
  date: '',
  category: 'Kategori',
  seoCategory: '',
  author: 'Author',
  seoAuthor: '',
  hit: 0,
);
