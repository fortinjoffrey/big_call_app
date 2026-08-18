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

  void useGoldenSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 2900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Widget host(AppPalette palette, TextSize size) {
    final settings = AppSettings(
      palette: palette,
      textSize: size,
      layout: ContactLayout.compact,
      emergencyStyle: EmergencyStyle.section,
      uppercaseNames: false,
      speakScrollLetters: true,
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
