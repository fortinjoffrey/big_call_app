import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/domain/ports/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsSettingsRepository implements SettingsRepository {
  const PrefsSettingsRepository(this._prefs);

  static const _paletteKey = 'palette';
  static const _textSizeKey = 'textSize';
  static const _layoutKey = 'layout';
  static const _emergencyStyleKey = 'emergencyStyle';
  static const _uppercaseNamesKey = 'uppercaseNames';
  static const _speakScrollLettersKey = 'speakScrollLetters';

  final SharedPreferences _prefs;

  @override
  Future<AppSettings> load() async {
    return AppSettings(
      palette: _readEnum(
        _paletteKey,
        AppPalette.values,
        kDefaultSettings.palette,
      ),
      textSize: _readEnum(
        _textSizeKey,
        TextSize.values,
        kDefaultSettings.textSize,
      ),
      layout: _readEnum(
        _layoutKey,
        ContactLayout.values,
        kDefaultSettings.layout,
      ),
      emergencyStyle: _readEnum(
        _emergencyStyleKey,
        EmergencyStyle.values,
        kDefaultSettings.emergencyStyle,
      ),
      uppercaseNames:
          _prefs.getBool(_uppercaseNamesKey) ?? kDefaultSettings.uppercaseNames,
      speakScrollLetters:
          _prefs.getBool(_speakScrollLettersKey) ??
          kDefaultSettings.speakScrollLetters,
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    await _prefs.setString(_paletteKey, settings.palette.name);
    await _prefs.setString(_textSizeKey, settings.textSize.name);
    await _prefs.setString(_layoutKey, settings.layout.name);
    await _prefs.setString(_emergencyStyleKey, settings.emergencyStyle.name);
    await _prefs.setBool(_uppercaseNamesKey, settings.uppercaseNames);
    await _prefs.setBool(
      _speakScrollLettersKey,
      settings.speakScrollLetters,
    );
  }

  T _readEnum<T extends Enum>(String key, List<T> values, T fallback) {
    final stored = _prefs.getString(key);
    if (stored == null) return fallback;
    for (final value in values) {
      if (value.name == stored) return value;
    }
    return fallback;
  }
}
