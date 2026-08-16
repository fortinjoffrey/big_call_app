import 'package:big_call_app/core/theme/app_theme.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/domain/entities/contact_number.dart';
import 'package:big_call_app/presentation/contacts/widgets/call_button.dart';
import 'package:big_call_app/presentation/contacts/widgets/contact_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';

void main() {
  Widget host({
    required void Function(String) onSpeak,
    required void Function(ContactNumber) onCall,
  }) {
    return MaterialApp(
      theme: buildTheme(AppPalette.light, TextSize.m),
      home: Scaffold(
        body: ContactCard(
          contact: marie,
          palette: AppPalette.light,
          onSpeak: onSpeak,
          onCall: onCall,
        ),
      ),
    );
  }

  testWidgets('toucher le nom prononce le nom seul', (tester) async {
    final spoken = <String>[];
    await tester.pumpWidget(host(onSpeak: spoken.add, onCall: (_) {}));

    await tester.tap(find.text('Marie'));
    expect(spoken, ['Marie']);
  });

  testWidgets('toucher un libelle prononce le nom suivi du libelle',
      (tester) async {
    final spoken = <String>[];
    await tester.pumpWidget(host(onSpeak: spoken.add, onCall: (_) {}));

    await tester.tap(find.text('Mobile'));
    expect(spoken, ['Marie Mobile']);
  });

  testWidgets('toucher le bouton vert appelle et ne prononce rien',
      (tester) async {
    final spoken = <String>[];
    final called = <ContactNumber>[];
    await tester.pumpWidget(host(onSpeak: spoken.add, onCall: called.add));

    await tester.tap(find.byType(CallButton).first);

    expect(called.single.number, '0611223344');
    expect(spoken, isEmpty,
        reason: 'un appui sur le bouton ne doit pas remonter a la zone parole');
  });

  testWidgets('le bouton mesure au moins 72 px', (tester) async {
    await tester.pumpWidget(host(onSpeak: (_) {}, onCall: (_) {}));

    final size = tester.getSize(find.byType(CallButton).first);
    expect(size.width, greaterThanOrEqualTo(72));
    expect(size.height, greaterThanOrEqualTo(72));
  });

  testWidgets('un contact a un seul numero n affiche pas de libelle',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(AppPalette.light, TextSize.m),
      home: Scaffold(
        body: ContactCard(
          contact: joffrey,
          palette: AppPalette.light,
          onSpeak: (_) {},
          onCall: (_) {},
        ),
      ),
    ));

    expect(find.text('Joffrey'), findsOneWidget);
    expect(find.text('Mobile'), findsNothing);
    expect(find.byType(CallButton), findsOneWidget);
  });
}
