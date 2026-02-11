import 'dart:developer' as developer;
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  final FlutterTts flutterTts;

  /// Posisi karakter terakhir yang dibacakan (relatif terhadap teks yang di-speak)
  int _rawProgressOffset = 0;

  TextToSpeech(this.flutterTts);

  /// Konfigurasi TTS dengan bahasa Indonesia
  Future<void> configureTts() async {
    final languages = await flutterTts.getLanguages;
    developer.log('TTS Available languages: $languages', name: 'TTS');

    final isIdAvailable = (languages as List).any(
      (lang) => lang.toString().toLowerCase().contains('id'),
    );

    final isVoiceAvailable = await flutterTts.getVoices;
    developer.log('TTS Available voices: $isVoiceAvailable', name: 'TTS');

    if (isIdAvailable) {
      await flutterTts.setLanguage("id-ID");
      developer.log('TTS Language set to id-ID', name: 'TTS');
    } else {
      developer.log('TTS id-ID not available, using default', name: 'TTS');
    }

    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    //--------------------
    // List Voice
    //--------------------
    //{features: networkTimeoutMs	networkRetriesCount, latency: low, name: id-id-x-ide-network, locale: id-ID, network_required: 1, quality: high} => cowok
    // {features: networkTimeoutMs	networkRetriesCount, latency: low, name: id-id-x-ide-local, locale: id-ID, network_required: 0, quality: high} => cowok suara berat
    //{features: networkTimeoutMs	networkRetriesCount, latency: low, name: id-id-x-dfz-network, locale: id-ID, network_required: 1, quality: high} => cewek
    // {features: networkTimeoutMs	networkRetriesCount, latency: low, name: id-id-x-idc-local, locale: id-ID, network_required: 0, quality: high} => cewek lebih smooth
    //  {features: networkTimeoutMs	networkRetriesCount, latency: low, name: id-id-x-idd-network, locale: id-ID, network_required: 1, quality: high}
    // {features: networkTimeoutMs	networkRetriesCount, latency: low, name: id-id-x-dfz-local, locale: id-ID, network_required: 0, quality: high}
    //  {features: networkTimeoutMs	networkRetriesCount, latency: low, name: id-id-x-idd-local, locale: id-ID, network_required: 0, quality: high}
    //  {features: networkTimeoutMs	legacySetLanguageVoice	networkRetriesCount, latency: low, name: id-ID-language, locale: id-ID, network_required: 0, quality: high}
    //  {features: networkTimeoutMs	networkRetriesCount, latency: low, name: id-id-x-idc-network, locale: id-ID, network_required: 1, quality: high}

    await flutterTts.setVoice({
      "features": "networkTimeoutMs\tnetworkRetriesCount",
      "latency": "low",
      "name": "id-id-x-idc-local",
      "locale": "id-ID",
      "network_required": "0",
      "quality": "high",
    });

    // Track progress — offset relatif terhadap teks yg sedang di-speak
    flutterTts.setProgressHandler((
      String text,
      int startOffset,
      int endOffset,
      String word,
    ) {
      _rawProgressOffset = endOffset;
    });

    final engine = await flutterTts.getDefaultEngine;
    developer.log('TTS Default engine: $engine', name: 'TTS');
  }

  /// Set handler saat TTS selesai bicara (natural completion)
  void setCompletionHandler(Function callback) {
    flutterTts.setCompletionHandler(() {
      developer.log('TTS onComplete', name: 'TTS');
      callback();
    });
  }

  /// Set handler saat TTS di-cancel (stop/pause)
  void setCancelHandler(Function callback) {
    flutterTts.setCancelHandler(() {
      developer.log('TTS onCancel', name: 'TTS');
      callback();
    });
  }

  /// Set handler saat TTS error
  void setErrorHandler(Function(String) callback) {
    flutterTts.setErrorHandler((msg) {
      developer.log('TTS onError: $msg', name: 'TTS');
      callback(msg);
    });
  }

  /// Set handler saat TTS mulai bicara
  void setStartHandler(Function callback) {
    flutterTts.setStartHandler(() {
      developer.log('TTS onStart', name: 'TTS');
      callback();
    });
  }

  /// Membacakan teks
  Future<int?> speak(String text) async {
    _rawProgressOffset = 0;
    developer.log('TTS speak, length: ${text.length}', name: 'TTS');
    final result = await flutterTts.speak(text);
    return result;
  }

  /// Stop TTS engine
  Future<void> stop() async {
    await flutterTts.stop();
  }

  /// Offset terakhir yang dibacakan (relatif terhadap teks yg dikirim ke speak)
  int get lastProgressOffset => _rawProgressOffset;

  /// Utility: strip HTML tags dan entities dari string
  static String stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'&nbsp;'), ' ')
        .replaceAll(RegExp(r'&amp;'), '&')
        .replaceAll(RegExp(r'&lt;'), '<')
        .replaceAll(RegExp(r'&gt;'), '>')
        .replaceAll(RegExp(r'&quot;'), '"')
        .replaceAll(RegExp(r"&#39;"), "'")
        .replaceAll(RegExp(r'&\w+;'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
