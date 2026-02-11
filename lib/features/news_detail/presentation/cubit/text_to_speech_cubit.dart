import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_jtv/core/utils/text_to_speech.dart';

enum NewsTtsStatus { idle, playing, paused, error }

class TextToSpeechCubit extends Cubit<NewsTtsStatus> {
  final TextToSpeech _tts;
  bool _isInitialized = false;

  /// Teks asli yang dikirim dari luar (tidak pernah berubah selama sesi)
  String _fullText = '';

  /// Akumulasi offset dalam teks asli
  int _absoluteOffset = 0;

  TextToSpeechCubit(this._tts) : super(NewsTtsStatus.idle);

  Future<void> init() async {
    if (_isInitialized) return;

    developer.log('TTS Cubit init', name: 'TTS');
    await _tts.configureTts();

    _tts.setStartHandler(() {
      if (!isClosed) emit(NewsTtsStatus.playing);
    });

    // Natural completion → TTS selesai membaca semua teks
    _tts.setCompletionHandler(() {
      developer.log(
        'TTS complete. absoluteOffset=$_absoluteOffset, fullLen=${_fullText.length}',
        name: 'TTS',
      );
      _fullText = '';
      _absoluteOffset = 0;
      if (!isClosed) emit(NewsTtsStatus.idle);
    });

    // Cancel → dipanggil saat stop() atau pause()
    // Kita tangkap offset terakhir di sini
    _tts.setCancelHandler(() {
      // Hitung posisi absolut = base + progress relatif
      _absoluteOffset = _absoluteOffset + _tts.lastProgressOffset;
      developer.log(
        'TTS cancel. absoluteOffset=$_absoluteOffset, lastProgressOffset=${_tts.lastProgressOffset}',
        name: 'TTS',
      );
      developer.log(
        'TTS cancel. absoluteOffset=$_absoluteOffset + ${_tts.lastProgressOffset} = ${_absoluteOffset + _tts.lastProgressOffset}',
        name: 'TTS',
      );
      developer.log(
        'TTS cancelled. Saved absoluteOffset=${_absoluteOffset + _tts.lastProgressOffset}',
        name: 'TTS',
      );
      // Tidak emit apa-apa — pause() dan stop() yang handle emit
    });

    _tts.setErrorHandler((msg) {
      developer.log('TTS error: $msg', name: 'TTS');
      if (!isClosed) emit(NewsTtsStatus.error);
    });

    _isInitialized = true;
  }

  /// Mulai membacakan teks dari awal
  Future<void> play(String text) async {
    if (text.trim().isEmpty) return;
    if (!_isInitialized) await init();

    _fullText = text;
    _absoluteOffset = 0;

    developer.log('TTS play, length: ${text.length}', name: 'TTS');
    emit(NewsTtsStatus.playing);
    await _tts.speak(text);
  }

  /// Pause: hentikan TTS, simpan posisi
  Future<void> pause() async {
    developer.log('TTS pause requested', name: 'TTS');
    await _tts.stop(); // Ini akan trigger cancelHandler yang menyimpan offset
    if (!isClosed) emit(NewsTtsStatus.paused);
    developer.log('TTS paused at absoluteOffset=$_absoluteOffset', name: 'TTS');
  }

  /// Resume: lanjutkan dari posisi terakhir
  Future<void> resume() async {
    if (_fullText.isEmpty || _absoluteOffset >= _fullText.length) {
      developer.log('TTS resume: nothing to resume', name: 'TTS');
      if (!isClosed) emit(NewsTtsStatus.idle);
      return;
    }

    final remaining = _fullText.substring(_absoluteOffset).trimLeft();
    developer.log(
      'TTS resume from $_absoluteOffset/${_fullText.length}, '
      'remaining: ${remaining.length} chars',
      name: 'TTS',
    );

    if (remaining.isEmpty) {
      if (!isClosed) emit(NewsTtsStatus.idle);
      return;
    }

    emit(NewsTtsStatus.playing);
    await _tts.speak(remaining);
    // Setelah speak return, cancelHandler atau completionHandler yang handle
  }

  /// Stop: berhenti total, reset semua
  Future<void> stop() async {
    developer.log('TTS stop requested', name: 'TTS');
    _fullText = '';
    _absoluteOffset = 0;
    await _tts.stop();
    if (!isClosed) emit(NewsTtsStatus.idle);
  }

  @override
  Future<void> close() {
    _tts.stop();
    return super.close();
  }
}
