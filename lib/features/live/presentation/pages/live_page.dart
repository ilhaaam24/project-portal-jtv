import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:portal_jtv/core/navigation/navigation_cubit.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../bloc/live_bloc.dart';
import '../bloc/live_event.dart';
import '../bloc/live_state.dart';
import '../../domain/entities/livestream_entity.dart';
import '../../domain/entities/schedule_entity.dart';
import 'package:portal_jtv/config/injection/injection.dart' as di;

class LivePage extends StatelessWidget {
  const LivePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hitung hari ini: DateTime.monday = 1 → dayIndex 0, dst.
    final todayIndex = DateTime.now().weekday - 1; // 0=Senin, 6=Minggu

    return BlocProvider(
      create: (_) => di.sl<LiveBloc>()
        ..add(const LoadLivestream())
        ..add(LoadSchedule(todayIndex)),
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

  // Nama hari
  static const List<String> _dayNames = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

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

  /// Cek apakah waktu sekarang sedang dalam jadwal program
  bool _isCurrentlyAiring(ScheduleEntity schedule) {
    final now = TimeOfDay.now();
    final parts = schedule.jamMulai.split(':');
    final endParts = schedule.jamBerakhir.split(':');

    if (parts.length < 2 || endParts.length < 2) return false;

    final start = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
    final end = TimeOfDay(
      hour: int.tryParse(endParts[0]) ?? 0,
      minute: int.tryParse(endParts[1]) ?? 0,
    );

    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    return nowMinutes >= startMinutes && nowMinutes < endMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final todayIndex = DateTime.now().weekday - 1;

    return BlocListener<NavigationCubit, int>(
      listener: (context, currentTab) {
        if (currentTab != _liveTabIndex) {
          _player.pause(); // Pindah dari Live → PAUSE
        } else {
          _player.play(); // Balik ke Live → PLAY
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.liveStreaming),
          centerTitle: true,
        ),
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
                      Text(
                        state.errorMessage ??
                            AppLocalizations.of(context)!.loadFailed,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<LiveBloc>().add(
                          const LoadLivestream(),
                        ),
                        child: Text(AppLocalizations.of(context)!.retry),
                      ),
                    ],
                  ),
                );

              case LiveStatus.success:
                return _buildLiveContent(state, todayIndex);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLiveContent(LiveState state, int todayIndex) {
    final live = state.livestream!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.tv_off, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noLiveBroadcast,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.stayTuned,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),

          const Divider(height: 1),

          // ─── JADWAL PROGRAM ───
          _buildScheduleSection(state, todayIndex),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  SCHEDULE SECTION
  // ─────────────────────────────────────────────

  Widget _buildScheduleSection(LiveState state, int todayIndex) {
    final selectedDay = state.selectedDay == -1
        ? todayIndex
        : state.selectedDay;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Container(
                height: 24,
                width: 4,
                decoration: BoxDecoration(color: PortalColors.jtvJingga),
              ),
              SizedBox(width: 8),
              Text(
                'Jadwal Program',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // Day selector (horizontal scroll chips)
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _dayNames.length,
            itemBuilder: (context, index) {
              final isSelected = selectedDay == index;
              final isToday = index == todayIndex;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(
                    isToday
                        ? '${_dayNames[index]} (Hari ini)'
                        : _dayNames[index],
                  ),
                  selected: isSelected,
                  onSelected: (_) {
                    context.read<LiveBloc>().add(LoadSchedule(index));
                  },
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Schedule list
        _buildScheduleList(state, selectedDay == todayIndex),
      ],
    );
  }

  Widget _buildScheduleList(LiveState state, bool isToday) {
    switch (state.scheduleStatus) {
      case ScheduleStatus.initial:
      case ScheduleStatus.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(child: CircularProgressIndicator()),
        );

      case ScheduleStatus.failure:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: Column(
              children: [
                const Icon(Icons.error_outline, size: 40, color: Colors.grey),
                const SizedBox(height: 8),
                Text(state.scheduleError ?? 'Gagal memuat jadwal'),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    final day = state.selectedDay;
                    context.read<LiveBloc>().add(LoadSchedule(day));
                  },
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        );

      case ScheduleStatus.success:
        if (state.schedules.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                'Belum ada jadwal untuk hari ini',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: state.schedules.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final schedule = state.schedules[index];
            final isAiring = isToday && _isCurrentlyAiring(schedule);

            return _buildScheduleItem(schedule, isAiring);
          },
        );
    }
  }

  Widget _buildScheduleItem(ScheduleEntity schedule, bool isAiring) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: isAiring
          ? BoxDecoration(
              border: Border.all(color: colorScheme.secondary, width: 1),
              color: colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Row(
        children: [
          // Waktu
          SizedBox(
            child: Row(
              children: [
                Text(
                  schedule.jamMulai,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isAiring ? FontWeight.bold : FontWeight.w500,
                    color: isAiring
                        ? colorScheme.primary
                        : theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Container(
            height: 24,
            width: 2,
            decoration: BoxDecoration(color: colorScheme.primary),
          ),
          const SizedBox(width: 12),

          // Nama program
          Expanded(
            child: Text(
              schedule.nama,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isAiring ? FontWeight.bold : FontWeight.normal,
                color: isAiring ? colorScheme.primary : null,
              ),
            ),
          ),

          // Sedang tayang badge
          if (isAiring)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: PortalColors.jtvJingga,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
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
