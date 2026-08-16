import 'package:big_call_app/domain/ports/speech_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsSpeechService implements SpeechService {
  TtsSpeechService(this._tts);

  final FlutterTts _tts;
  bool _configured = false;

  Future<void> _configure() async {
    if (_configured) return;
    await _tts.setLanguage('fr-FR');
    await _tts.setSpeechRate(0.45); // plus lent que le défaut, plus intelligible
    await _tts.awaitSpeakCompletion(true);
    _configured = true;
  }

  /// N'échoue jamais : sans voix française installée, l'app reste utilisable.
  /// L'erreur est journalisée pour rester diagnosticable — une panne muette
  /// et invisible serait introuvable.
  @override
  Future<void> speak(String text) async {
    try {
      await _configure();
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
