import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/comment/domain/entities/comment_entity.dart';
import 'package:portal_jtv/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:portal_jtv/features/comment/presentation/bloc/comment_event.dart';

class CommentCard extends StatelessWidget {
  final CommentEntity comment;
  final bool isReply;
  final VoidCallback? onReply;

  const CommentCard({
    super.key,
    required this.comment,
    this.isReply = false,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: isReply ? 40.0 : 0.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: PortalColors.grey200,
              width: 0.5,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar + Nama + Waktu + Menu
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 16,
                  backgroundColor: PortalColors.jtvBiru,
                  backgroundImage: comment.user?.pic != null
                      ? NetworkImage(comment.user!.pic!)
                      : null,
                  child: comment.user?.pic == null
                      ? Text(
                          _getInitials(comment.user?.nama ?? 'A'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                // Name + Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.user?.nama ?? 'Anonim',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        _timeAgo(comment.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: PortalColors.grey500,
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ),
                ),
                // Menu button (report)
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    size: 18,
                    color: PortalColors.grey500,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Content
            Text(
              comment.content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 8),

            // Actions: Like + Balas
            Row(
              children: [
                // Like Button
                InkWell(
                  onTap: () {
                    context
                        .read<CommentBloc>()
                        .add(ToggleLikeCommentEvent(commentId: comment.id));
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          comment.isLiked
                              ? Icons.thumb_up_alt
                              : Icons.thumb_up_alt_outlined,
                          size: 16,
                          color: comment.isLiked
                              ? PortalColors.jtvJingga
                              : PortalColors.grey600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${comment.likesCount}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: comment.isLiked
                                        ? PortalColors.jtvJingga
                                        : PortalColors.grey600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Balas Button
                if (!isReply)
                  InkWell(
                    onTap: onReply,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Text(
                        'Balas',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: PortalColors.grey600,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  String _timeAgo(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays > 365) {
        return '${(diff.inDays / 365).floor()} tahun yang lalu';
      } else if (diff.inDays > 30) {
        return '${(diff.inDays / 30).floor()} bulan yang lalu';
      } else if (diff.inDays > 0) {
        return '${diff.inDays} hari yang lalu';
      } else if (diff.inHours > 0) {
        return '${diff.inHours} jam yang lalu';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes} menit yang lalu';
      } else {
        return 'Baru saja';
      }
    } catch (_) {
      return dateStr;
    }
  }
}
