import 'package:big_call_app/core/theme/app_theme.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/presentation/contacts/contacts_bloc.dart';
import 'package:big_call_app/presentation/contacts/contacts_event.dart';
import 'package:big_call_app/presentation/contacts/contacts_page.dart';
import 'package:big_call_app/presentation/contacts/contacts_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../support/fixtures.dart';
import '../support/fonts.dart';

class _MockContactsBloc extends MockBloc<ContactsEvent, ContactsState>
    implements ContactsBloc {}

void main() {
  setUpAll(loadAppFonts);

  late _MockContactsBloc bloc;

  setUp(() {
    bloc = _MockContactsBloc();
    when(() => bloc.state).thenReturn(const ContactsReady(
      favorites: [joffrey, marie],
      others: [anneMarie, docteur],
      showFavoritesSection: true,
    ));
  });

  // Largeur réaliste de téléphone (390dp) plutôt que 1080 : à 1080dp, les
  // noms longs (« Anne-Marie Delacroix ») avaient toute la place du monde et
  // ne révélaient jamais les problèmes d'enroulement/débordement qu'ils
  // provoquent sur un vrai téléphone.
  //
  // Hauteur mesurée empiriquement : à 390dp, le dernier ContactCard (disposition
  // « wide », palier XL, le cas le plus haut) se termine vers y=1208. On ajoute
  // une marge de sécurité pour ne rien perdre, sans viser un canevas
  // inutilement grand.
  void useGoldenSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 1260);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Widget host(
    AppPalette palette,
    TextSize size, {
    ContactLayout layout = ContactLayout.compact,
    EmergencyStyle emergencyStyle = EmergencyStyle.section,
    bool uppercaseNames = false,
  }) =>
      BlocProvider<ContactsBloc>.value(
        value: bloc,
        child: MaterialApp(
          theme: buildTheme(palette, size),
          home: ContactsPage(
            palette: palette,
            layout: layout,
            emergencyStyle: emergencyStyle,
            uppercaseNames: uppercaseNames,
          ),
        ),
      );

  for (final palette in AppPalette.values) {
    for (final size in TextSize.values) {
      testWidgets('contacts ${palette.name} ${size.name}', (tester) async {
        useGoldenSurface(tester);

        await tester.pumpWidget(host(palette, size));

        await expectLater(
          find.byType(ContactsPage),
          matchesGoldenFile('contacts_${palette.name}_${size.name}.png'),
        );
      });
    }
  }

  // « Anne-Marie Delacroix » au palier XL est le cas qui a motivé cette
  // disposition : c'est le nom le plus long, au plus grand palier, celui qui
  // enroulait le plus mal contre le bouton rond.
  for (final palette in AppPalette.values) {
    testWidgets('contacts wide ${palette.name} xl', (tester) async {
      useGoldenSurface(tester);

      await tester.pumpWidget(host(palette, TextSize.xl, layout: ContactLayout.wide));

      await expectLater(
        find.byType(ContactsPage),
        matchesGoldenFile('contacts_wide_${palette.name}_xl.png'),
      );
    });
  }

  // Un contact d'urgence (SAMU, numéro 15) parmi les favoris fait apparaître
  // la section « URGENCE », propre au style `section` : ce golden est le
  // seul à en montrer une.
  testWidgets('contacts urgence light m', (tester) async {
    useGoldenSurface(tester);
    when(() => bloc.state).thenReturn(const ContactsReady(
      favorites: [joffrey, samu, marie],
      others: [anneMarie, docteur],
      showFavoritesSection: true,
    ));

    await tester.pumpWidget(host(AppPalette.light, TextSize.m));

    await expectLater(
      find.byType(ContactsPage),
      matchesGoldenFile('contacts_urgence_light_m.png'),
    );
  });

  // Réglage « Majuscules » actif : les noms *et* les libellés de numéro
  // (« Mobile », « Fixe ») passent en capitales. Seul golden à montrer cet
  // effet — les autres le laissent désactivé.
  testWidgets('contacts majuscules light m', (tester) async {
    useGoldenSurface(tester);

    await tester.pumpWidget(host(AppPalette.light, TextSize.m, uppercaseNames: true));

    await expectLater(
      find.byType(ContactsPage),
      matchesGoldenFile('contacts_majuscules_light_m.png'),
    );
  });
}
