import 'package:big_call_app/core/theme/app_theme.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/presentation/contacts/contacts_bloc.dart';
import 'package:big_call_app/presentation/contacts/contacts_event.dart';
import 'package:big_call_app/presentation/contacts/contacts_page.dart';
import 'package:big_call_app/presentation/contacts/contacts_state.dart';
import 'package:big_call_app/presentation/contacts/widgets/emergency_card.dart';
import 'package:big_call_app/presentation/settings/settings_bloc.dart';
import 'package:big_call_app/presentation/settings/settings_event.dart';
import 'package:big_call_app/presentation/settings/settings_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../support/fixtures.dart';

class _MockContactsBloc extends MockBloc<ContactsEvent, ContactsState>
    implements ContactsBloc {}

class _MockSettingsBloc extends MockBloc<SettingsEvent, AppSettings>
    implements SettingsBloc {}

void main() {
  late _MockContactsBloc bloc;
  late _MockSettingsBloc settingsBloc;

  setUp(() {
    bloc = _MockContactsBloc();
    settingsBloc = _MockSettingsBloc();
    when(() => settingsBloc.state).thenReturn(kDefaultSettings);
  });

  // Le gabarit de test par défaut fait 800×600 — plus court qu'un téléphone.
  // On adapte la fenêtre à la page, jamais l'inverse.
  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  // `_openSettings` pousse `SettingsPage` via `Navigator`, ce qui l'insère
  // comme une nouvelle route sous le `Navigator` implicite de `MaterialApp`
  // — donc *à côté* de `home`, pas en dessous. Un provider posé dans `home`
  // ne serait visible que par la première route ; il doit englober
  // `MaterialApp` pour rester un ancêtre de toutes les routes poussées.
  Widget host() => MultiBlocProvider(
        providers: [
          BlocProvider<ContactsBloc>.value(value: bloc),
          BlocProvider<SettingsBloc>.value(value: settingsBloc),
        ],
        child: MaterialApp(
          theme: buildTheme(AppPalette.light, TextSize.m),
          home: const ContactsPage(
            palette: AppPalette.light,
            layout: ContactLayout.compact,
          ),
        ),
      );

  testWidgets('affiche les deux sections quand les favoris sont disponibles',
      (tester) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(const ContactsReady(
      favorites: [joffrey, marie],
      others: [anneMarie, docteur],
      showFavoritesSection: true,
    ));

    await tester.pumpWidget(host());

    expect(find.text('FAVORIS'), findsOneWidget);
    expect(find.text('TOUS LES CONTACTS'), findsOneWidget);
  });

  testWidgets('avec section favoris, l appui long sur son en-tete ouvre les reglages',
      (tester) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(const ContactsReady(
      favorites: [joffrey, marie],
      others: [anneMarie, docteur],
      showFavoritesSection: true,
    ));

    await tester.pumpWidget(host());
    await tester.longPress(find.text('FAVORIS'));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets(
      'la carte SAMU se place sous les favoris et au dessus de TOUS LES CONTACTS',
      (tester) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(const ContactsReady(
      favorites: [joffrey, marie],
      others: [anneMarie, docteur],
      showFavoritesSection: true,
    ));

    await tester.pumpWidget(host());

    final lastFavoriteY = tester.getTopLeft(find.text('Marie')).dy;
    final emergencyY = tester.getTopLeft(find.byType(EmergencyCard)).dy;
    final allContactsHeaderY =
        tester.getTopLeft(find.text('TOUS LES CONTACTS')).dy;

    expect(find.byType(EmergencyCard), findsOneWidget);
    expect(emergencyY, greaterThan(lastFavoriteY));
    expect(emergencyY, lessThan(allContactsHeaderY));
  });

  testWidgets(
      'sans section favoris, la carte SAMU reste au dessus de TOUS LES CONTACTS',
      (tester) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(const ContactsReady(
      favorites: [],
      others: [joffrey, marie],
      showFavoritesSection: false,
    ));

    await tester.pumpWidget(host());

    final emergencyY = tester.getTopLeft(find.byType(EmergencyCard)).dy;
    final allContactsHeaderY =
        tester.getTopLeft(find.text('TOUS LES CONTACTS')).dy;

    expect(find.byType(EmergencyCard), findsOneWidget);
    expect(emergencyY, lessThan(allContactsHeaderY));
  });

  testWidgets('masque la section favoris quand la plateforme ne la fournit pas',
      (tester) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(const ContactsReady(
      favorites: [],
      others: [joffrey, marie, docteur, anneMarie],
      showFavoritesSection: false,
    ));

    await tester.pumpWidget(host());

    expect(find.text('FAVORIS'), findsNothing);
    expect(find.text('TOUS LES CONTACTS'), findsOneWidget);
  });

  testWidgets('sans section favoris, l appui long sur l autre en-tete ouvre les reglages',
      (tester) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(const ContactsReady(
      favorites: [],
      others: [joffrey, marie],
      showFavoritesSection: false,
    ));

    await tester.pumpWidget(host());
    // Sur iOS la section « Favoris » n'existe pas : si l'appui long restait
    // attaché à son en-tête, les réglages deviendraient inatteignables.
    await tester.longPress(find.text('TOUS LES CONTACTS'));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('permission refusee : ecran plein avec bouton AUTORISER',
      (tester) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(const ContactsPermissionDenied());

    await tester.pumpWidget(host());

    expect(find.textContaining('accès à vos contacts'), findsOneWidget);
    expect(find.text('AUTORISER'), findsOneWidget);
  });

  testWidgets('aucun contact : message explicite, pas de page blanche',
      (tester) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(const ContactsReady(
      favorites: [],
      others: [],
      showFavoritesSection: true,
    ));

    await tester.pumpWidget(host());

    expect(find.textContaining('Aucun contact'), findsOneWidget);
  });
}
