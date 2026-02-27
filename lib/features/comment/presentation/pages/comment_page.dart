import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_jtv/core/helper/format_date.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/comment/domain/entities/comment_entity.dart';
import 'package:portal_jtv/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:portal_jtv/features/comment/presentation/bloc/comment_event.dart';
import 'package:portal_jtv/features/comment/presentation/bloc/comment_state.dart';
import 'package:portal_jtv/features/comment/presentation/widgets/comment_card.dart';
import 'package:portal_jtv/features/comment/presentation/widgets/comment_input.dart';

class CommentPage extends StatefulWidget {
  final int idBerita;
  final String title;
  final String category;
  final String author;
  final String date;

  const CommentPage({
    super.key,
    required this.idBerita,
    required this.title,
    required this.category,
    required this.author,
    required this.date,
  });

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  int? _replyToId;
  String? _replyToName;

  void _setReplyTo(CommentEntity comment) {
    setState(() {
      _replyToId = comment.id;
      _replyToName = comment.user?.nama ?? 'Anonim';
    });
  }

  void _cancelReply() {
    setState(() {
      _replyToId = null;
      _replyToName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Komentar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Expanded content area
          Expanded(
            child: BlocBuilder<CommentBloc, CommentState>(
              builder: (context, state) {
                return CustomScrollView(
                  slivers: [
                    // News Info Header
                    SliverToBoxAdapter(
                      child: _buildNewsInfo(context),
                    ),

                    // Sort Tabs
                    SliverToBoxAdapter(
                      child: _buildSortTabs(context, state),
                    ),

                    // Comment List
                    _buildCommentList(context, state),
                  ],
                );
              },
            ),
          ),

          // Bottom Input
          BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              return CommentInput(
                isPosting: state.isPosting,
                replyTo: _replyToName,
                onCancelReply: _cancelReply,
                onSubmit: (content) {
                  context.read<CommentBloc>().add(PostCommentEvent(
                        idBerita: widget.idBerita,
                        content: content,
                        parentId: _replyToId,
                      ));
                  _cancelReply();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNewsInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PortalColors.jtvBiru,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.category,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PortalColors.jtvJingga,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.author} • ${formatDate(widget.date)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PortalColors.grey300,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortTabs(BuildContext context, CommentState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildTabChip(
            context,
            label: 'Terbaru',
            isSelected: state.sortOrder == CommentSortOrder.terbaru,
            onTap: () => context.read<CommentBloc>().add(
                  const ChangeSortOrder(sortOrder: CommentSortOrder.terbaru),
                ),
          ),
          const SizedBox(width: 8),
          _buildTabChip(
            context,
            label: 'Terpopuler',
            isSelected: state.sortOrder == CommentSortOrder.terpopuler,
            onTap: () => context.read<CommentBloc>().add(
                  const ChangeSortOrder(
                      sortOrder: CommentSortOrder.terpopuler),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? PortalColors.jtvJingga : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? PortalColors.jtvJingga : PortalColors.grey400,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected ? Colors.white : PortalColors.grey700,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  Widget _buildCommentList(BuildContext context, CommentState state) {
    switch (state.status) {
      case CommentStatus.initial:
      case CommentStatus.loading:
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );

      case CommentStatus.failure:
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errorMessage ?? 'Gagal memuat komentar'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context
                      .read<CommentBloc>()
                      .add(LoadComments(idBerita: widget.idBerita)),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        );

      case CommentStatus.success:
        final comments = state.sortedComments;

        if (comments.isEmpty) {
          return const SliverFillRemaining(
            child: Center(
              child: Text('Belum ada komentar. Jadilah yang pertama!'),
            ),
          );
        }

        // Separate root comments and replies
        final rootComments =
            comments.where((c) => c.parentId == null).toList();

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final rootComment = rootComments[index];
                // Find replies for this root comment
                final replies = comments
                    .where((c) => c.parentId == rootComment.id)
                    .toList();

                return Column(
                  children: [
                    CommentCard(
                      comment: rootComment,
                      onReply: () => _setReplyTo(rootComment),
                    ),
                    ...replies.map(
                      (reply) => CommentCard(
                        comment: reply,
                        isReply: true,
                        onReply: () => _setReplyTo(rootComment),
                      ),
                    ),
                  ],
                );
              },
              childCount: rootComments.length,
            ),
          ),
        );
    }
  }
}
