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

  // Le gabarit de test par défaut fait 800×600 — plus court qu'un téléphone,
  // et bien plus court que cinq sections avec chacune son aperçu.
  // On adapte la fenêtre à la page, jamais l'inverse.
  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 4000);
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
    expect(find.text('Petit'), findsOneWidget);
    expect(find.text('Moyen'), findsOneWidget);
    expect(find.text('Grand'), findsOneWidget);
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

    await tester.tap(find.text('Grand'));
    verify(() => bloc.add(const TextSizeSelected(TextSize.xl))).called(1);
  });

  testWidgets('propose les deux dispositions', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(host());

    expect(find.text('Bouton à droite'), findsOneWidget);
    expect(find.text('Bouton en dessous'), findsOneWidget);
  });

  testWidgets('choisir une disposition emet LayoutSelected', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(host());

    await tester.tap(find.text('Bouton en dessous'));
    verify(() => bloc.add(const LayoutSelected(ContactLayout.wide))).called(1);
  });

  testWidgets('propose les trois styles de numeros d urgence', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(host());

    expect(find.text('Dans une section à part'), findsOneWidget);
    expect(find.text('Bouton rouge, à leur place'), findsOneWidget);
    expect(find.text('Comme les autres contacts'), findsOneWidget);
  });

  testWidgets('choisir un style d urgence emet EmergencyStyleSelected',
      (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(host());

    await tester.tap(find.text('Bouton rouge, à leur place'));
    verify(() => bloc.add(const EmergencyStyleSelected(EmergencyStyle.highlight)))
        .called(1);
  });

  testWidgets('propose les deux casses de nom', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(host());

    expect(find.text('MAJUSCULES'), findsOneWidget);
    expect(find.text('Normal'), findsOneWidget);
  });

  testWidgets('choisir MAJUSCULES emet UppercaseNamesSelected(true)',
      (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(host());

    await tester.tap(find.text('MAJUSCULES'));
    verify(() => bloc.add(const UppercaseNamesSelected(true))).called(1);
  });

  testWidgets('choisir Normal emet UppercaseNamesSelected(false)',
      (tester) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(
      kDefaultSettings.copyWith(uppercaseNames: true),
    );
    await tester.pumpWidget(host());

    await tester.tap(find.text('Normal'));
    verify(() => bloc.add(const UppercaseNamesSelected(false))).called(1);
  });

  testWidgets('affiche un apercu par section, avec le vrai widget de carte',
      (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(host());

    // Cinq sections, cinq aperçus : un pour chaque groupe de réglages.
    expect(find.byType(ContactCard), findsNWidgets(5));
    expect(find.text('Marie'), findsNWidgets(4));
    // Seule la section « Numéros d'urgence » a besoin d'un numéro
    // d'urgence pour montrer le bouton rouge.
    expect(find.text('SAMU'), findsOneWidget);
  });

  testWidgets('l apercu reflete le theme et le palier choisis', (tester) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(
      const AppSettings(
        palette: AppPalette.dark,
        textSize: TextSize.xl,
        layout: ContactLayout.compact,
        emergencyStyle: EmergencyStyle.section,
        uppercaseNames: false,
      ),
    );

    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(AppPalette.dark, TextSize.xl),
      home: BlocProvider<SettingsBloc>.value(
        value: bloc,
        child: const SettingsPage(),
      ),
    ));

    // L'aperçu n'existe que pour montrer l'effet avant de s'engager : une
    // carte figée sur la palette claire passerait les autres tests.
    final card = tester.widget<ContactCard>(find.byType(ContactCard).first);
    expect(card.palette, AppPalette.dark);

    final name = tester.widget<Text>(find.text('Marie').first);
    expect(name.style?.color, paletteColors[AppPalette.dark]!.onBackground);
    expect(name.style?.fontSize, kNameBaseSize * 1.5);
  });

  testWidgets(
      "l apercu de la section urgence porte un numero d urgence et refletela casse",
      (tester) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(
      kDefaultSettings.copyWith(
        uppercaseNames: true,
        emergencyStyle: EmergencyStyle.highlight,
      ),
    );
    await tester.pumpWidget(host());

    final cards = tester.widgetList<ContactCard>(find.byType(ContactCard));
    final emergencyCard = cards.last;
    expect(emergencyCard.contact.numbers.single.number, '15');
    expect(emergencyCard.highlightEmergencyNumbers, isTrue);
    expect(emergencyCard.uppercaseNames, isTrue);
    expect(find.text('SAMU'), findsOneWidget);
  });
}
