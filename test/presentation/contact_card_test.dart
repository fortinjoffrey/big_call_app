import 'package:big_call_app/core/theme/app_theme.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/domain/entities/contact_number.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:big_call_app/presentation/contacts/widgets/call_button.dart';
import 'package:big_call_app/presentation/contacts/widgets/contact_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fixtures.dart';

void main() {
  Widget host({
    required void Function(String) onSpeak,
    required void Function(ContactNumber) onCall,
    ContactLayout layout = ContactLayout.compact,
  }) {
    return MaterialApp(
      theme: buildTheme(AppPalette.light, TextSize.m),
      home: Scaffold(
        body: ContactCard(
          contact: marie,
          palette: AppPalette.light,
          layout: layout,
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

  testWidgets('toucher a droite du nom, dans le vide, prononce quand meme',
      (tester) async {
    final spoken = <String>[];
    await tester.pumpWidget(host(onSpeak: spoken.add, onCall: (_) {}));

    final nameRect = tester.getRect(find.text('Marie'));
    // Repère la largeur réelle disponible pour la ligne du nom via la ligne
    // libellé + bouton juste en dessous (même largeur de contenu, bornée par
    // le padding de la carte) plutôt que le rectangle externe de la carte :
    // ce dernier inclut la marge/le padding de la carte, une marge de
    // respiration voulue entre cartes, pas la ligne elle-même.
    final rowRect = tester
        .getRect(find.ancestor(of: find.text('Mobile'), matching: find.byType(Row)).first);
    // 10 px avant le bord : nettement au-delà de la largeur du mot « Marie »
    // (le nom ne remplit jamais toute la ligne), donc bien dans le vide situé
    // à droite du prénom, tout en restant dans la zone tactile élargie.
    final x = rowRect.right - 10;
    await tester.tapAt(Offset(x, nameRect.center.dy));

    expect(spoken, ['Marie']);
  });

  testWidgets('toucher a droite d un libelle prononce quand meme',
      (tester) async {
    final spoken = <String>[];
    await tester.pumpWidget(host(onSpeak: spoken.add, onCall: (_) {}));

    final labelRect = tester.getRect(find.text('Mobile'));
    final buttonRect = tester.getRect(find.byType(CallButton).first);
    // Entre la fin du libellé et le bouton vert, sans toucher le bouton.
    final x = (labelRect.right + buttonRect.left) / 2;
    await tester.tapAt(Offset(x, labelRect.center.dy));

    expect(spoken, ['Marie Mobile']);
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
          layout: ContactLayout.compact,
          onSpeak: (_) {},
          onCall: (_) {},
        ),
      ),
    ));

    expect(find.text('Joffrey'), findsOneWidget);
    expect(find.text('Mobile'), findsNothing);
    expect(find.byType(CallButton), findsOneWidget);
  });

  group('disposition large', () {
    testWidgets('le bouton se place sous le nom, sans contraindre sa largeur',
        (tester) async {
      await tester.pumpWidget(host(
        onSpeak: (_) {},
        onCall: (_) {},
        layout: ContactLayout.wide,
      ));

      final nameRect = tester.getRect(find.text('Marie'));
      final buttonRect = tester.getRect(find.byType(FullWidthCallButton).first);
      final cardRect = tester.getRect(find.byType(ContactCard));

      // Le bouton est en dessous du nom, jamais à côté.
      expect(buttonRect.top, greaterThanOrEqualTo(nameRect.bottom));
      // Le bouton s'étire sur toute la largeur utile de la carte : sa
      // largeur n'est pas rétrécie par une colonne partagée avec le nom.
      expect(buttonRect.width, greaterThan(cardRect.width * 0.8));
      // La largeur disponible pour le nom n'est pas amputée par le bouton :
      // le mot le plus large que porte le nom tiendrait largement plus que
      // la largeur d'un rond de 72 px sur cette même ligne.
      final nameZone = tester.getRect(
        find.ancestor(of: find.text('Marie'), matching: find.byType(SizedBox)).first,
      );
      expect(nameZone.width, greaterThan(cardRect.width * 0.8));
    });

    testWidgets('un contact a un seul numero n affiche pas de libelle non plus',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: buildTheme(AppPalette.light, TextSize.m),
        home: Scaffold(
          body: ContactCard(
            contact: joffrey,
            palette: AppPalette.light,
            layout: ContactLayout.wide,
            onSpeak: (_) {},
            onCall: (_) {},
          ),
        ),
      ));

      expect(find.text('Joffrey'), findsOneWidget);
      expect(find.text('Mobile'), findsNothing);
      expect(find.byType(FullWidthCallButton), findsOneWidget);
    });

    testWidgets('les trois zones tactiles fonctionnent, y compris a cote du libelle',
        (tester) async {
      final spoken = <String>[];
      final called = <ContactNumber>[];
      await tester.pumpWidget(host(
        onSpeak: spoken.add,
        onCall: called.add,
        layout: ContactLayout.wide,
      ));

      await tester.tap(find.text('Marie'));
      expect(spoken, ['Marie']);
      spoken.clear();

      await tester.tap(find.text('Mobile'));
      expect(spoken, ['Marie Mobile']);
      spoken.clear();

      // A cote du libelle, dans la zone elargie mais sans toucher le texte.
      final labelRect = tester.getRect(find.text('Mobile'));
      final labelZoneRect = tester.getRect(
        find.ancestor(of: find.text('Mobile'), matching: find.byType(SizedBox)).first,
      );
      final x = labelZoneRect.right - 4;
      await tester.tapAt(Offset(x, labelRect.center.dy));
      expect(spoken, ['Marie Mobile']);

      await tester.tap(find.byType(FullWidthCallButton).first);
      expect(called.single.number, '0611223344');
    });
  });

  group('mise en avant des numeros d urgence', () {
    const contact = PhoneContact(
      id: 'urgence',
      displayName: 'Docteur Martin',
      isFavorite: false,
      numbers: [
        ContactNumber(number: '0144556677', label: 'Bureau'),
        ContactNumber(number: '15', label: 'Urgences'),
      ],
    );

    Widget urgenceHost({
      required void Function(String) onSpeak,
      required void Function(ContactNumber) onCall,
    }) {
      return MaterialApp(
        theme: buildTheme(AppPalette.light, TextSize.m),
        home: Scaffold(
          body: ContactCard(
            contact: contact,
            palette: AppPalette.light,
            layout: ContactLayout.compact,
            highlightEmergencyNumbers: true,
            onSpeak: onSpeak,
            onCall: onCall,
          ),
        ),
      );
    }

    testWidgets('un simple appui sur le bouton rouge appelle le numero d urgence',
        (tester) async {
      final called = <ContactNumber>[];
      await tester.pumpWidget(
        urgenceHost(onSpeak: (_) {}, onCall: called.add),
      );

      final redButton = find.byType(CallButton).last;
      await tester.tap(redButton);

      expect(called.single.number, '15');
    });

    testWidgets('le bouton vert du numero ordinaire appelle toujours sur un simple appui',
        (tester) async {
      final called = <ContactNumber>[];
      await tester.pumpWidget(
        urgenceHost(onSpeak: (_) {}, onCall: called.add),
      );

      final greenButton = find.byType(CallButton).first;
      await tester.tap(greenButton);

      expect(called.single.number, '0144556677');
    });
  });
}
