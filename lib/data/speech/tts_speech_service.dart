import 'package:big_call_app/domain/ports/speech_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsSpeechService implements SpeechService {
  TtsSpeechService(this._tts);

  final FlutterTts _tts;

  static const double _speechRate = 0.5;

  bool? _configured;

  Future<bool> _configure() async {
    final known = _configured;
    if (known != null) return known;

    try {
      await _tts.setLanguage('fr-FR');
      await _tts.setSpeechRate(_speechRate);
      await _tts.awaitSpeakCompletion(true);
      _configured = true;
    } on Object catch (error) {
      debugPrint('TTS configure: $error');
      _configured = false;
    }
    return _configured!;
  }

  @override
  Future<void> speak(String text) async {
    if (!await _configure()) return;
    try {
      await _tts.stop();
      await _tts.speak(text);
    } on Object catch (error) {
      debugPrint('TTS speak: $error');
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _tts.stop();
    } on Object catch (error) {
      debugPrint('TTS stop: $error');
    }
  }
}
