abstract interface class SystemSettingsService {
  /// Ouvre la page des réglages système de l'application, seul endroit où une
  /// permission refusée peut être ré-accordée.
  Future<void> openAppSettings();
}
