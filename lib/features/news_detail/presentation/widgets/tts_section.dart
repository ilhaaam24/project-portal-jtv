import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/core/theme/color/portal_colors.dart';
import 'package:portal_jtv/features/news_detail/presentation/cubit/text_to_speech_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Widget tombol TTS untuk membacakan konten berita
/// Mendukung 3 aksi: Play, Pause, Resume
class TtsSection extends StatelessWidget {
  final String content;

  const TtsSection({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextToSpeechCubit, NewsTtsStatus>(
      builder: (context, status) {
        return Skeleton.leaf(
          enabled: true,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: status == NewsTtsStatus.playing
                  ? PortalColors.jtvBiru.withValues(alpha: 0.05)
                  : PortalColors.grey100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: status == NewsTtsStatus.playing
                    ? PortalColors.jtvBiru.withValues(alpha: 0.1)
                    : PortalColors.grey200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Icon Indikator
                _buildIndicator(context, status),
                const SizedBox(width: 12),

                // Info Teks
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Dengarkan Berita',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: PortalColors.jtvBiru,
                        ),
                      ),
                      _buildStatusLabel(context, status),
                    ],
                  ),
                ),

                // Kontrol (Play/Pause & Stop)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPlayPauseButton(context, status),
                    if (status == NewsTtsStatus.playing ||
                        status == NewsTtsStatus.paused)
                      _buildStopButton(context),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIndicator(BuildContext context, NewsTtsStatus status) {
    return Skeleton.replace(
      width: 40,
      height: 40,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: status == NewsTtsStatus.playing
              ? PortalColors.jtvJingga
              : PortalColors.jtvBiru,
          shape: BoxShape.circle,
        ),
        child: Icon(
          status == NewsTtsStatus.playing ? Icons.graphic_eq : Icons.headset,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildPlayPauseButton(BuildContext context, NewsTtsStatus status) {
    final cubit = context.read<TextToSpeechCubit>();

    IconData icon;
    String tooltip;
    VoidCallback onPressed;
    Color color = PortalColors.jtvBiru;

    switch (status) {
      case NewsTtsStatus.playing:
        icon = Icons.pause_circle_filled_rounded;
        tooltip = 'Pause';
        onPressed = () => cubit.pause();
        color = PortalColors.jtvJingga;
      case NewsTtsStatus.paused:
        icon = Icons.play_circle_filled_rounded;
        tooltip = 'Lanjutkan';
        onPressed = () => cubit.resume();
      case NewsTtsStatus.idle:
      case NewsTtsStatus.error:
        icon = Icons.play_circle_filled_rounded;
        tooltip = 'Dengarkan Berita';
        onPressed = () => cubit.play(content);
        if (status == NewsTtsStatus.error) color = PortalColors.error;
    }

    return IconButton(
      icon: Icon(icon, size: 40),
      color: color,
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: onPressed,
    );
  }

  Widget _buildStopButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: IconButton(
        icon: const Icon(Icons.stop_circle_rounded, size: 40),
        color: PortalColors.error,
        tooltip: 'Berhenti',
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () => context.read<TextToSpeechCubit>().stop(),
      ),
    );
  }

  Widget _buildStatusLabel(BuildContext context, NewsTtsStatus status) {
    String label;
    Color color;

    switch (status) {
      case NewsTtsStatus.playing:
        label = 'Sedang membacakan konten...';
        color = PortalColors.jtvBiru;
      case NewsTtsStatus.paused:
        label = 'Pembacaan dijeda';
        color = PortalColors.jtvJingga;
      case NewsTtsStatus.error:
        label = 'Gagal memutar audio';
        color = PortalColors.error;
      case NewsTtsStatus.idle:
        label = 'Klik play untuk mendengarkan';
        color = PortalColors.grey600;
    }

    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        color: color,
        fontWeight:
            status == NewsTtsStatus.playing || status == NewsTtsStatus.paused
            ? FontWeight.w500
            : FontWeight.normal,
      ),
    );
  }
}
