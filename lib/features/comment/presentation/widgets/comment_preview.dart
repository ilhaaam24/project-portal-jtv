import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/config/injection/injection.dart';
import 'package:portal_jtv/config/routes/route_names.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:portal_jtv/features/comment/presentation/bloc/comment_event.dart';
import 'package:portal_jtv/features/comment/presentation/bloc/comment_state.dart';

class CommentPreview extends StatelessWidget {
  final int idBerita;
  final String title;
  final String category;
  final String author;
  final String date;
  final String photo;
  final String seo;

  const CommentPreview({
    super.key,
    required this.idBerita,
    required this.title,
    required this.category,
    required this.author,
    required this.date,
    required this.photo,
    required this.seo,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<CommentBloc>()..add(LoadComments(idBerita: idBerita)),
      child: BlocBuilder<CommentBloc, CommentState>(
        builder: (context, state) {
          if (state.status != CommentStatus.success ||
              state.comments.isEmpty) {
            // Jangan tampilkan apa-apa kalau belum loaded / kosong
            // Tetap tampilkan tombol lihat komentar
            return _buildContainer(context, state);
          }
          return _buildContainer(context, state);
        },
      ),
    );
  }

  Widget _buildContainer(BuildContext context, CommentState state) {
    final commentCount = state.comments.length;
    final lastComment =
        state.comments.isNotEmpty ? state.comments.last : null;

    return GestureDetector(
      onTap: () {
        context.push(
          RouteNames.comments,
          extra: {
            'idBerita': idBerita,
            'title': title,
            'category': category,
            'author': author,
            'date': date,
            'photo': photo,
            'seo': seo,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: PortalColors.grey300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                Text(
                  'Lihat $commentCount Komentar',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: PortalColors.grey600,
                ),
              ],
            ),

            // Last comment preview
            if (lastComment != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: PortalColors.jtvJingga,
                    backgroundImage: lastComment.user?.pic != null
                        ? NetworkImage(lastComment.user!.pic!)
                        : null,
                    child: lastComment.user?.pic == null
                        ? Text(
                            (lastComment.user?.nama ?? 'A')[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      lastComment.content,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
