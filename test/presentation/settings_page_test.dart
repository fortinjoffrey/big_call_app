import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/core/theme/app_theme.dart';
import 'package:big_call_app/core/theme/text_sizes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/presentation/contacts/widgets/contact_card.dart';
import 'package:big_call_app/presentation/settings/settings_bloc.dart';
import 'package:big_call_app/presentation/settings/settings_event.dart';
import 'package:big_call_app/presentation/settings/settings_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSettingsBloc extends MockBloc<SettingsEvent, AppSettings>
    implements SettingsBloc {}

void main() {
  late _MockSettingsBloc bloc;

  setUp(() {
    bloc = _MockSettingsBloc();
    when(() => bloc.state).thenReturn(kDefaultSettings);
  });

  // Le gabarit de test par défaut fait 800×600 — plus court qu'un téléphone.
  // On adapte la fenêtre à la page, jamais l'inverse.
  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Widget host() => MaterialApp(
        theme: buildTheme(AppPalette.light, TextSize.m),
        home: BlocProvider<SettingsBloc>.value(
          value: bloc,
          child: const SettingsPage(),
        ),
      );

  testWidgets('propose les trois themes et les trois paliers', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(host());

    expect(find.text('Clair'), findsOneWidget);
    expect(find.text('Sombre'), findsOneWidget);
    expect(find.text('Jaune sur noir'), findsOneWidget);
    expect(find.text('M'), findsOneWidget);
    expect(find.text('L'), findsOneWidget);
    expect(find.text('XL'), findsOneWidget);
  });

  testWidgets('choisir un theme emet ThemeSelected', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(host());

    await tester.tap(find.text('Sombre'));
    verify(() => bloc.add(const ThemeSelected(AppPalette.dark))).called(1);
  });

  testWidgets('choisir un palier emet TextSizeSelected', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(host());

    await tester.tap(find.text('XL'));
    verify(() => bloc.add(const TextSizeSelected(TextSize.xl))).called(1);
  });

  testWidgets('affiche un apercu en direct', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(host());

    expect(find.text('Marie'), findsOneWidget);
    expect(find.text('Mobile'), findsOneWidget);
  });

  testWidgets('l apercu reflete le theme et le palier choisis', (tester) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(
      const AppSettings(palette: AppPalette.dark, textSize: TextSize.xl),
    );

    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(AppPalette.dark, TextSize.xl),
      home: BlocProvider<SettingsBloc>.value(
        value: bloc,
        child: const SettingsPage(),
      ),
    ));

    // L'aperçu n'existe que pour montrer l'effet avant de s'engager : une
    // carte figée sur la palette claire passerait les quatre autres tests.
    final card = tester.widget<ContactCard>(find.byType(ContactCard));
    expect(card.palette, AppPalette.dark);

    final name = tester.widget<Text>(find.text('Marie'));
    expect(name.style?.color, paletteColors[AppPalette.dark]!.onBackground);
    expect(name.style?.fontSize, kNameBaseSize * 1.5);
  });
}
