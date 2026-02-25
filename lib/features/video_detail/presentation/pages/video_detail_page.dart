import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:portal_jtv/features/home/domain/entities/video_entity.dart';
import 'package:portal_jtv/features/video_detail/presentation/bloc/video_detail_bloc.dart';

class VideoDetailPage extends StatefulWidget {
  final List<VideoEntity> initialVideos;
  final int initialIndex;

  const VideoDetailPage({
    super.key,
    required this.initialVideos,
    required this.initialIndex,
  });

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    context.read<VideoDetailBloc>().add(
      LoadInitialVideos(
        initialVideos: widget.initialVideos,
        initialIndex: widget.initialIndex,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: BlocBuilder<VideoDetailBloc, VideoDetailState>(
            builder: (context, state) {
              return Text(
                '${_currentIndex + 1} / ${state.videos.length}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              );
            },
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<VideoDetailBloc, VideoDetailState>(
          builder: (context, state) {
            if (state.videos.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: state.videos.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });

                // Trigger load more when near end
                if (index >= state.videos.length - 3) {
                  context.read<VideoDetailBloc>().add(const LoadMoreVideos());
                }
              },
              itemBuilder: (context, index) {
                final video = state.videos[index];
                final isActive = index == _currentIndex;

                return _VideoPageItem(
                  key: ValueKey('video_${video.id}'),
                  video: video,
                  isActive: isActive,
                  isLast: index == state.videos.length - 1,
                  isLoadingMore: state.isLoadingMore,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// ─── SINGLE VIDEO PAGE ITEM ─────────────────────────────────
// Each page owns its own controller lifecycle (init/dispose)
class _VideoPageItem extends StatefulWidget {
  final VideoEntity video;
  final bool isActive;
  final bool isLast;
  final bool isLoadingMore;

  const _VideoPageItem({
    super.key,
    required this.video,
    required this.isActive,
    required this.isLast,
    required this.isLoadingMore,
  });

  @override
  State<_VideoPageItem> createState() => _VideoPageItemState();
}

class _VideoPageItemState extends State<_VideoPageItem> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    final videoId = _extractVideoId(widget.video.youtubeId);
    debugPrint(
      '▶ Init YT controller for: $videoId (active: ${widget.isActive})',
    );

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: widget.isActive,
        mute: false,
        enableCaption: false,
        hideControls: false,
        controlsVisibleAtStart: true,
      ),
    );

    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (_controller.value.isReady && !_isPlayerReady) {
      setState(() => _isPlayerReady = true);
      debugPrint('✅ YT player ready for: ${widget.video.youtubeId}');
    }
  }

  /// Extract YouTube video ID dari berbagai format
  String _extractVideoId(String input) {
    final extracted = YoutubePlayer.convertUrlToId(input);
    if (extracted != null) return extracted;
    return input;
  }

  @override
  void didUpdateWidget(covariant _VideoPageItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only call play/pause when controller is ready
    if (!_isPlayerReady) return;

    if (widget.isActive && !oldWidget.isActive) {
      _controller.play();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.pause();
    }
  }

  @override
  void deactivate() {
    // Pause when widget is removed from tree (e.g. scrolled far away)
    if (_isPlayerReady) {
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final videoHeight = screenWidth * 9 / 16;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ─── YouTube Player ───
          Container(
            width: screenWidth,
            height: videoHeight,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.red,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.redAccent,
                ),
                bottomActions: [
                  CurrentPosition(),
                  const SizedBox(width: 8),
                  ProgressBar(
                    isExpanded: true,
                    colors: const ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  RemainingDuration(),
                ],
              ),
              builder: (context, player) {
                return player;
              },
            ),
          ),

          const SizedBox(height: 20),

          // ─── Video Info ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white54,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.video.date,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ─── Swipe indicator / Loading more ───
          if (widget.isLast && widget.isLoadingMore)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white24,
                  strokeWidth: 2,
                ),
              ),
            )
          else ...[
            const Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white24,
              size: 28,
            ),
            const Text(
              'Swipe untuk video lainnya',
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
