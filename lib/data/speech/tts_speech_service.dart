import 'dart:io';

import 'package:big_call_app/domain/ports/speech_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsSpeechService implements SpeechService {
  TtsSpeechService(this._tts);

  final FlutterTts _tts;
  bool _configured = false;

  /// Les deux plateformes n'utilisent pas la même échelle : Android va de 0 à
  /// ~2 avec 1,0 pour « normal », iOS de 0 à 1 avec ~0,5 pour « normal ». Une
  /// constante unique donnerait donc deux vitesses très différentes.
  ///
  /// Environ 15 % sous la normale de chaque plateforme. Ralentir davantage est
  /// contre-productif : très étirée, une phrase se comprend moins bien, pas
  /// mieux — les mots s'espacent au point qu'elle ne tient plus en mémoire.
  /// Valeur à affiner à l'oreille lors de l'essai avec l'utilisatrice.
  static final double _speechRate = Platform.isIOS ? 0.42 : 0.85;

  Future<void> _configure() async {
    if (_configured) return;
    await _tts.setLanguage('fr-FR');
    await _tts.setSpeechRate(_speechRate);
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
