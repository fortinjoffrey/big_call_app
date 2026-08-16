import 'package:big_call_app/core/theme/app_theme.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/presentation/contacts/contacts_bloc.dart';
import 'package:big_call_app/presentation/contacts/contacts_event.dart';
import 'package:big_call_app/presentation/contacts/contacts_page.dart';
import 'package:big_call_app/presentation/contacts/contacts_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../support/fixtures.dart';

class _MockContactsBloc extends MockBloc<ContactsEvent, ContactsState>
    implements ContactsBloc {}

void main() {
  late _MockContactsBloc bloc;

  setUp(() => bloc = _MockContactsBloc());

  // Le gabarit de test par défaut fait 800×600 — plus court qu'un téléphone.
  // On adapte la fenêtre à la page, jamais l'inverse.
  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Widget host() => MaterialApp(
        theme: buildTheme(AppPalette.light, TextSize.m),
        home: BlocProvider<ContactsBloc>.value(
          value: bloc,
          child: const ContactsPage(palette: AppPalette.light),
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

    expect(find.text('★ FAVORIS'), findsOneWidget);
    expect(find.text('TOUS LES CONTACTS'), findsOneWidget);
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

    expect(find.text('★ FAVORIS'), findsNothing);
    expect(find.text('TOUS LES CONTACTS'), findsOneWidget);
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
