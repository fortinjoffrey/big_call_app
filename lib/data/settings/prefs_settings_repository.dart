import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/domain/ports/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsSettingsRepository implements SettingsRepository {
  const PrefsSettingsRepository(this._prefs);

  static const _paletteKey = 'palette';
  static const _textSizeKey = 'textSize';
  static const _layoutKey = 'layout';

  final SharedPreferences _prefs;

  @override
  Future<AppSettings> load() async {
    return AppSettings(
      palette: _readEnum(_paletteKey, AppPalette.values, kDefaultSettings.palette),
      textSize: _readEnum(_textSizeKey, TextSize.values, kDefaultSettings.textSize),
      layout: _readEnum(_layoutKey, ContactLayout.values, kDefaultSettings.layout),
    );
  }

  /// Ne rend pas compte d'un échec, délibérément. `setString` renvoie un
  /// booléen que l'on ignore : une écriture qui échoue (mémoire pleine, ROM
  /// constructeur capricieuse) laisse simplement le réglage non enregistré, et
  /// `load()` retombe alors sur les valeurs par défaut au lieu de planter.
  /// Remonter l'erreur obligerait l'écran de réglages à afficher quelque chose
  /// dont l'utilisatrice ne pourrait rien faire.
  @override
  Future<void> save(AppSettings settings) async {
    await _prefs.setString(_paletteKey, settings.palette.name);
    await _prefs.setString(_textSizeKey, settings.textSize.name);
    await _prefs.setString(_layoutKey, settings.layout.name);
  }

  /// Une valeur inconnue (renommage d'énumération, fichier corrompu) retombe
  /// sur le défaut plutôt que de faire planter le démarrage.
  T _readEnum<T extends Enum>(String key, List<T> values, T fallback) {
    final stored = _prefs.getString(key);
    if (stored == null) return fallback;
    for (final value in values) {
      if (value.name == stored) return value;
    }
    return fallback;
  }
}
