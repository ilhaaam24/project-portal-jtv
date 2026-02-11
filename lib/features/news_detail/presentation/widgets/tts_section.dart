import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/features/news_detail/presentation/cubit/text_to_speech_cubit.dart';

/// Widget tombol TTS untuk membacakan konten berita
/// Mendukung 3 aksi: Play, Pause, Resume
class TtsSection extends StatelessWidget {
  final String content;

  const TtsSection({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextToSpeechCubit, NewsTtsStatus>(
      builder: (context, status) {
        return Row(
          children: [
            // Tombol Play/Pause
            _buildPlayPauseButton(context, status),
            // Tombol Stop (hanya muncul saat playing/paused)
            if (status == NewsTtsStatus.playing ||
                status == NewsTtsStatus.paused)
              _buildStopButton(context),
            const SizedBox(width: 8),
            // Label status
            _buildStatusLabel(context, status),
          ],
        );
      },
    );
  }

  Widget _buildPlayPauseButton(BuildContext context, NewsTtsStatus status) {
    final cubit = context.read<TextToSpeechCubit>();

    IconData icon;
    String tooltip;
    VoidCallback onPressed;

    switch (status) {
      case NewsTtsStatus.playing:
        icon = Icons.pause_circle_filled;
        tooltip = 'Pause';
        onPressed = () => cubit.pause();
      case NewsTtsStatus.paused:
        icon = Icons.play_circle_filled;
        tooltip = 'Lanjutkan';
        onPressed = () => cubit.resume();
      case NewsTtsStatus.idle:
      case NewsTtsStatus.error:
        icon = Icons.play_circle_filled;
        tooltip = 'Dengarkan Berita';
        onPressed = () => cubit.play(content);
    }

    return IconButton(
      icon: Icon(icon, size: 32),
      color: status == NewsTtsStatus.error
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.primary,
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }

  Widget _buildStopButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.stop_circle, size: 32),
      color: Theme.of(context).colorScheme.error,
      tooltip: 'Berhenti',
      onPressed: () => context.read<TextToSpeechCubit>().stop(),
    );
  }

  Widget _buildStatusLabel(BuildContext context, NewsTtsStatus status) {
    String label;
    Color color;

    switch (status) {
      case NewsTtsStatus.playing:
        label = 'Sedang membaca...';
        color = Theme.of(context).colorScheme.primary;
      case NewsTtsStatus.paused:
        label = 'Dijeda';
        color = Colors.orange;
      case NewsTtsStatus.error:
        label = 'Gagal memutar';
        color = Theme.of(context).colorScheme.error;
      case NewsTtsStatus.idle:
        label = 'Dengarkan';
        color = Colors.grey[600]!;
    }

    return Text(label, style: TextStyle(fontSize: 13, color: color));
  }
}
