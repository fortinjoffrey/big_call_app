import 'package:big_call_app/core/theme/app_theme.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/presentation/settings/settings_bloc.dart';
import 'package:big_call_app/presentation/settings/settings_event.dart';
import 'package:big_call_app/presentation/settings/settings_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../support/fonts.dart';

class _MockSettingsBloc extends MockBloc<SettingsEvent, AppSettings>
    implements SettingsBloc {}

void main() {
  setUpAll(loadAppFonts);

  late _MockSettingsBloc bloc;

  // Largeur réaliste de téléphone (390dp) plutôt que 1080dp, cf.
  // contacts_golden_test.dart.
  //
  // Hauteur mesurée empiriquement : à 390dp, le contenu de la page (au
  // palier XL, le plus haut) se termine vers y=1382. On ajoute une marge de
  // sécurité pour ne rien perdre, sans viser un canevas inutilement grand.
  void useGoldenSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 1440);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Widget host(AppPalette palette, TextSize size) {
    final settings = AppSettings(
      palette: palette,
      textSize: size,
      layout: ContactLayout.compact,
    );
    bloc = _MockSettingsBloc();
    when(() => bloc.state).thenReturn(settings);

    return BlocProvider<SettingsBloc>.value(
      value: bloc,
      child: MaterialApp(
        theme: buildTheme(palette, size),
        home: const SettingsPage(),
      ),
    );
  }

  for (final palette in AppPalette.values) {
    for (final size in TextSize.values) {
      testWidgets('settings ${palette.name} ${size.name}', (tester) async {
        useGoldenSurface(tester);

        await tester.pumpWidget(host(palette, size));

        await expectLater(
          find.byType(SettingsPage),
          matchesGoldenFile('settings_${palette.name}_${size.name}.png'),
        );
      });
    }
  }
}
