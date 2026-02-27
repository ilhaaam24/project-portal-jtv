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
import 'package:portal_jtv/features/news_detail/presentation/widgets/tts_section.dart';

Widget buildContent(
  BuildContext context,
  DetailState state,
  DetailArgsEntity args,
) {
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
                  Container(
                    width: 4,
                    height: 40,
                    color: PortalColors.jtvJingga,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.detail!.caption,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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

              const SizedBox(height: 8),

              // Tags
              Wrap(
                spacing: 8,
                children: state.tags.map((tag) {
                  return ActionChip(
                    label: Text(
                      tag.name,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: PortalColors.jtvBiru,
                      ),
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
              ),

              // Comment Preview Section
              CommentPreview(
                idBerita: args.idBerita,
                title: args.title,
                category: args.category,
                author: args.author,
                date: args.date,
                photo: args.photo,
                seo: args.seo,
              ),

              const SizedBox(height: 16),
            ],
          );
        },
      );
  }
}

