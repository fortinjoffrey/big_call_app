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

  // Surface volontairement surdimensionnée : une ListView ne construit que
  // ce qui est visible, il faut donc assez de hauteur pour capturer toute
  // la liste en une seule image.
  void useGoldenSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Widget host(AppPalette palette, TextSize size, {ContactLayout layout = ContactLayout.compact}) =>
      BlocProvider<ContactsBloc>.value(
        value: bloc,
        child: MaterialApp(
          theme: buildTheme(palette, size),
          home: ContactsPage(palette: palette, layout: layout),
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
}
