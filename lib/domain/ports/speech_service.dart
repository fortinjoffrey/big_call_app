abstract interface class SpeechService {
  /// Prononce [text] en français. N'échoue jamais : si la synthèse vocale est
  /// indisponible, l'app doit continuer à fonctionner sans voix.
  Future<void> speak(String text);

  Future<void> stop();
}
