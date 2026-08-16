import 'package:big_call_app/domain/ports/speech_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsSpeechService implements SpeechService {
  TtsSpeechService(this._tts);

  final FlutterTts _tts;

  /// Android : le plugin multiplie la valeur par deux avant de la passer au
  /// moteur (`setSpeechRate(rate * 2.0f)` dans FlutterTtsPlugin.kt), dont la
  /// vitesse normale est 1,0. Passer 0,5 donne donc exactement la vitesse
  /// standard. Une valeur de 0,85 — qui paraissait « 15 % sous la normale » —
  /// arrivait en réalité à 1,7, soit 70 % trop rapide, ce qui s'entendait
  /// nettement sur un vrai téléphone.
  ///
  /// iOS : `AVSpeechUtterance` va de 0 à 1 avec ~0,5 pour « normal » ; le
  /// plugin transmet la valeur telle quelle (`utterance.rate = rate`, sans
  /// facteur), donc 0,5 y donne aussi exactement la vitesse standard — d'où
  /// une constante unique pour les deux plateformes.
  static const double _speechRate = 0.5;

  /// `null` tant que la configuration n'a pas été tentée, puis `true` ou
  /// `false` définitivement. Un échec est mémorisé : sans voix française
  /// installée, réessayer à chaque phrase ajouterait de la latence à chaque
  /// appui pour un résultat qui restera muet, et noierait le journal.
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

  /// N'échoue jamais : sans voix française installée, l'app reste utilisable.
  /// L'erreur est journalisée pour rester diagnosticable — une panne muette
  /// et invisible serait introuvable.
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
