import 'package:big_call_app/data/settings/prefs_settings_repository.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('rend les reglages par defaut quand rien n est enregistre', () async {
    SharedPreferences.setMockInitialValues({});
    final repo = PrefsSettingsRepository(await SharedPreferences.getInstance());

    expect(await repo.load(), kDefaultSettings);
  });

  test('relit ce qui a ete enregistre', () async {
    SharedPreferences.setMockInitialValues({});
    final repo = PrefsSettingsRepository(await SharedPreferences.getInstance());

    const settings = AppSettings(
      palette: AppPalette.yellow,
      textSize: TextSize.xl,
      layout: ContactLayout.wide,
    );
    await repo.save(settings);

    expect(await repo.load(), settings);
  });

  test('retombe sur les defauts si la valeur stockee est inconnue', () async {
    SharedPreferences.setMockInitialValues({
      'palette': 'fuchsia',
      'textSize': 'gigantesque',
      'layout': 'diagonale',
    });
    final repo = PrefsSettingsRepository(await SharedPreferences.getInstance());

    expect(await repo.load(), kDefaultSettings);
  });

  test('un champ valide survit a un champ voisin invalide', () async {
    SharedPreferences.setMockInitialValues({'palette': 'yellow'});
    final repo = PrefsSettingsRepository(await SharedPreferences.getInstance());

    final settings = await repo.load();

    // Le repli est par champ, pas global : la palette enregistrée est
    // conservée, seule la taille manquante retombe sur le défaut.
    expect(settings.palette, AppPalette.yellow);
    expect(settings.textSize, kDefaultSettings.textSize);
    expect(settings.layout, kDefaultSettings.layout);
  });

  test('la disposition survit a un theme et un palier voisins invalides', () async {
    SharedPreferences.setMockInitialValues({'layout': 'wide'});
    final repo = PrefsSettingsRepository(await SharedPreferences.getInstance());

    final settings = await repo.load();

    expect(settings.layout, ContactLayout.wide);
    expect(settings.palette, kDefaultSettings.palette);
    expect(settings.textSize, kDefaultSettings.textSize);
  });
}
