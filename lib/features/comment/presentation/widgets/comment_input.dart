import 'package:flutter/material.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';

class CommentInput extends StatefulWidget {
  final bool isPosting;
  final String? replyTo;
  final VoidCallback? onCancelReply;
  final Function(String content) onSubmit;

  const CommentInput({
    super.key,
    required this.isPosting,
    this.replyTo,
    this.onCancelReply,
    required this.onSubmit,
  });

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSubmit(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reply indicator
          if (widget.replyTo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: PortalColors.grey100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.reply,
                    size: 14,
                    color: PortalColors.jtvBiru,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Membalas ${widget.replyTo}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: PortalColors.jtvBiru,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: widget.onCancelReply,
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: PortalColors.grey600,
                    ),
                  ),
                ],
              ),
            ),

          // Text input row
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: PortalColors.grey100,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Tulis komentar disini',
                      hintStyle: TextStyle(
                        color: PortalColors.grey500,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _handleSubmit(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Send button
              Container(
                decoration: BoxDecoration(
                  color: PortalColors.jtvJingga,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: widget.isPosting
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send, color: Colors.white, size: 18),
                  onPressed: widget.isPosting ? null : _handleSubmit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
