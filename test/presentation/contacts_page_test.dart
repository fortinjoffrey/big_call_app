import 'package:big_call_app/core/theme/app_theme.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/presentation/contacts/contacts_bloc.dart';
import 'package:big_call_app/presentation/contacts/contacts_event.dart';
import 'package:big_call_app/presentation/contacts/contacts_page.dart';
import 'package:big_call_app/presentation/contacts/contacts_state.dart';
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

  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Widget host({EmergencyStyle emergencyStyle = EmergencyStyle.section}) =>
      MultiBlocProvider(
        providers: [
          BlocProvider<ContactsBloc>.value(value: bloc),
          BlocProvider<SettingsBloc>.value(value: settingsBloc),
        ],
        child: MaterialApp(
          theme: buildTheme(AppPalette.light, TextSize.m),
          home: ContactsPage(
            palette: AppPalette.light,
            layout: ContactLayout.compact,
            emergencyStyle: emergencyStyle,
          ),
        ),
      );

  testWidgets('affiche les deux sections quand les favoris sont disponibles', (
    tester,
  ) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(
      const ContactsReady(
        favorites: [joffrey, marie],
        others: [anneMarie, docteur],
        showFavoritesSection: true,
      ),
    );

    await tester.pumpWidget(host());

    expect(find.text('FAVORIS'), findsOneWidget);
    expect(find.text('AUTRES CONTACTS'), findsOneWidget);
  });

  testWidgets(
    'avec section favoris, l appui long sur son en-tete ouvre les reglages',
    (tester) async {
      useTallSurface(tester);
      when(() => bloc.state).thenReturn(
        const ContactsReady(
          favorites: [joffrey, marie],
          others: [anneMarie, docteur],
          showFavoritesSection: true,
        ),
      );

      await tester.pumpWidget(host());
      await tester.longPress(find.text('FAVORIS'));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsPage), findsOneWidget);
    },
  );

  testWidgets(
    'style section : la section URGENCE se place entre FAVORIS et AUTRES CONTACTS',
    (tester) async {
      useTallSurface(tester);
      when(() => bloc.state).thenReturn(
        const ContactsReady(
          favorites: [joffrey, samu, marie],
          others: [anneMarie, docteur],
          showFavoritesSection: true,
        ),
      );

      await tester.pumpWidget(host());

      final favorisHeaderY = tester.getTopLeft(find.text('FAVORIS')).dy;
      final urgenceHeaderY = tester.getTopLeft(find.text('URGENCE')).dy;
      final allContactsHeaderY = tester
          .getTopLeft(find.text('AUTRES CONTACTS'))
          .dy;

      expect(find.text('URGENCE'), findsOneWidget);
      expect(urgenceHeaderY, greaterThan(favorisHeaderY));
      expect(urgenceHeaderY, lessThan(allContactsHeaderY));
    },
  );

  testWidgets(
    'style section : le contact SAMU quitte les favoris pour la section URGENCE',
    (tester) async {
      useTallSurface(tester);
      when(() => bloc.state).thenReturn(
        const ContactsReady(
          favorites: [joffrey, samu, marie],
          others: [anneMarie, docteur],
          showFavoritesSection: true,
        ),
      );

      await tester.pumpWidget(host());

      final urgenceHeaderY = tester.getTopLeft(find.text('URGENCE')).dy;
      final samuY = tester.getTopLeft(find.text('SAMU')).dy;
      final allContactsHeaderY = tester
          .getTopLeft(find.text('AUTRES CONTACTS'))
          .dy;

      expect(samuY, greaterThan(urgenceHeaderY));
      expect(samuY, lessThan(allContactsHeaderY));
    },
  );

  testWidgets(
    'style bouton rouge : pas de section URGENCE, le contact reste dans ses favoris',
    (tester) async {
      useTallSurface(tester);
      when(() => bloc.state).thenReturn(
        const ContactsReady(
          favorites: [joffrey, samu, marie],
          others: [anneMarie, docteur],
          showFavoritesSection: true,
        ),
      );

      await tester.pumpWidget(host(emergencyStyle: EmergencyStyle.highlight));

      expect(find.text('URGENCE'), findsNothing);
      expect(find.text('SAMU'), findsOneWidget);
    },
  );

  testWidgets(
    'style comme les autres : pas de section URGENCE, le contact reste dans ses favoris',
    (tester) async {
      useTallSurface(tester);
      when(() => bloc.state).thenReturn(
        const ContactsReady(
          favorites: [joffrey, samu, marie],
          others: [anneMarie, docteur],
          showFavoritesSection: true,
        ),
      );

      await tester.pumpWidget(host(emergencyStyle: EmergencyStyle.none));

      expect(find.text('URGENCE'), findsNothing);
      expect(find.text('SAMU'), findsOneWidget);
    },
  );

  testWidgets(
    'masque la section favoris quand la plateforme ne la fournit pas',
    (tester) async {
      useTallSurface(tester);
      when(() => bloc.state).thenReturn(
        const ContactsReady(
          favorites: [],
          others: [joffrey, marie, docteur, anneMarie],
          showFavoritesSection: false,
        ),
      );

      await tester.pumpWidget(host());

      expect(find.text('FAVORIS'), findsNothing);
      expect(find.text('AUTRES CONTACTS'), findsOneWidget);
    },
  );

  testWidgets(
    'sans section favoris, l appui long sur l autre en-tete ouvre les reglages',
    (tester) async {
      useTallSurface(tester);
      when(() => bloc.state).thenReturn(
        const ContactsReady(
          favorites: [],
          others: [joffrey, marie],
          showFavoritesSection: false,
        ),
      );

      await tester.pumpWidget(host());

      await tester.longPress(find.text('AUTRES CONTACTS'));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsPage), findsOneWidget);
    },
  );

  testWidgets('permission refusee : ecran plein avec bouton AUTORISER', (
    tester,
  ) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(const ContactsPermissionDenied());

    await tester.pumpWidget(host());

    expect(find.textContaining('accès à vos contacts'), findsOneWidget);
    expect(find.text('AUTORISER'), findsOneWidget);
  });

  testWidgets('aucun contact : message explicite, pas de page blanche', (
    tester,
  ) async {
    useTallSurface(tester);
    when(() => bloc.state).thenReturn(
      const ContactsReady(
        favorites: [],
        others: [],
        showFavoritesSection: true,
      ),
    );

    await tester.pumpWidget(host());

    expect(find.textContaining('Aucun contact'), findsOneWidget);
  });

  testWidgets('retour au premier plan : la liste revient en haut', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    when(() => bloc.state).thenReturn(
      const ContactsReady(
        favorites: [joffrey, marie],
        others: [anneMarie, docteur],
        showFavoritesSection: true,
      ),
    );

    await tester.pumpWidget(host());
    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pump();

    final controller = tester
        .widget<ListView>(find.byType(ListView))
        .controller!;
    expect(controller.offset, greaterThan(0));

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();

    expect(controller.offset, 0);
  });
}
