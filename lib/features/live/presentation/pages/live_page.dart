import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:portal_jtv/core/navigation/navigation_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../bloc/live_bloc.dart';
import '../bloc/live_event.dart';
import '../bloc/live_state.dart';
import '../../domain/entities/livestream_entity.dart';
import 'package:portal_jtv/config/injection/injection.dart' as di;

class LivePage extends StatelessWidget {
  const LivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<LiveBloc>()..add(const LoadLivestream()),
      child: const _LiveView(),
    );
  }
}

class _LiveView extends StatefulWidget {
  const _LiveView();

  @override
  State<_LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<_LiveView> with WidgetsBindingObserver {
  // media_kit player & controller
  late final Player _player;
  late final VideoController _videoController;

  // Track sumber aktif
  String _activeSource = 'jtv';
  static const int _liveTabIndex = 2;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _videoController = VideoController(_player);
    WidgetsBinding.instance.addObserver(this); // App lifecycle
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    try {
      _player.dispose();
    } catch (e) {
      debugPrint('Player dispose error: $e');
    }
    super.dispose();
  }

  // ✅ Pause saat app ke background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _player.pause();
    }
  }

  /// Play HLS stream via media_kit
  void _playStream(String url) {
    _player.open(Media(url));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, int>(
      listener: (context, currentTab) {
        if (currentTab != _liveTabIndex) {
          _player.pause(); // Pindah dari Live → PAUSE
        } else {
          _player.play(); // Balik ke Live → PLAY
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Live Streaming'), centerTitle: true),
        body: BlocConsumer<LiveBloc, LiveState>(
          listener: (context, state) {
            // Auto-play saat data loaded
            if (state.status == LiveStatus.success &&
                state.livestream != null) {
              final live = state.livestream!;
              if (live.isLive && live.hasJtv) {
                _playStream(live.jtv);
              }
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case LiveStatus.initial:
              case LiveStatus.loading:
                return const Center(child: CircularProgressIndicator());

              case LiveStatus.failure:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(state.errorMessage ?? 'Gagal memuat'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<LiveBloc>().add(
                          const LoadLivestream(),
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );

              case LiveStatus.success:
                return _buildLiveContent(state.livestream!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLiveContent(LivestreamEntity live) {
    return Column(
      children: [
        // ─── VIDEO PLAYER AREA ───
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              // Player / WebView berdasarkan sumber aktif
              _buildPlayerView(live),

              // Badge LIVE
              if (live.isLive)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: Colors.white, size: 8),
                        SizedBox(width: 4),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Fullscreen button
            ],
          ),
        ),

        // ─── INFO LIVE ───
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                live.isLive ? Icons.live_tv : Icons.tv_off,
                color: live.isLive ? Colors.red : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                live.liveTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // ─── TAB SUMBER ───
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (live.hasJtv) _buildSourceTab('JTV', 'jtv', Icons.tv),
              if (live.hasVidio)
                _buildSourceTab('Vidio', 'vidio', Icons.play_circle),
              if (live.hasYoutube)
                _buildSourceTab('YouTube', 'youtube', Icons.smart_display),
              if (live.hasFacebook)
                _buildSourceTab('Facebook', 'facebook', Icons.facebook),
            ],
          ),
        ),

        // ─── OFFLINE STATE ───
        if (!live.isLive)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tv_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada siaran langsung saat ini',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nantikan siaran berikutnya',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlayerView(LivestreamEntity live) {
    if (_activeSource == 'jtv' || _activeSource == 'youtube') {
      // Native player untuk HLS stream
      return Video(
        controller: _videoController,
        filterQuality: FilterQuality.medium,
        aspectRatio: 16 / 9,
        onEnterFullscreen: () => _enterFullscreen(live),
        onExitFullscreen: () async {
          await _exitFullscreen();
          if (mounted) Navigator.pop(context);
        },
      );
    } else {
      // WebView untuk embed (Vidio, Facebook)
      final url = _activeSource == 'vidio' ? live.vidio : live.facebook;
      return WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url)),
      );
    }
  }

  Widget _buildSourceTab(String label, String source, IconData icon) {
    final isActive = _activeSource == source;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
        selected: isActive,
        onSelected: (_) {
          setState(() => _activeSource = source);
          final live = context.read<LiveBloc>().state.livestream!;

          // Switch sumber
          if (source == 'jtv' && live.hasJtv) {
            _playStream(live.jtv);
          } else if (source == 'youtube' && live.hasYoutube) {
            _playStream(live.youtube);
          }
          // vidio & facebook ditangani WebView di buildPlayerView
        },
      ),
    );
  }

  Future<void> _enterFullscreen(LivestreamEntity live) async {
    // Landscape fullscreen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: PopScope(
            onPopInvokedWithResult: (didPop, _) {
              // Kembalikan ke portrait
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            },
            child: SafeArea(
              child: Center(child: Video(controller: _videoController)),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _exitFullscreen() async {
    // Kembalikan ke portrait
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }
}
