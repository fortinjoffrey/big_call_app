import 'package:big_call_app/core/theme/app_theme.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/presentation/contacts/widgets/call_button.dart';
import 'package:big_call_app/presentation/contacts/widgets/emergency_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host({
    required VoidCallback onCall,
    required VoidCallback onSpeak,
    ContactLayout layout = ContactLayout.compact,
  }) {
    return MaterialApp(
      theme: buildTheme(AppPalette.light, TextSize.m),
      home: Scaffold(
        body: EmergencyCard(
          palette: AppPalette.light,
          layout: layout,
          onCall: onCall,
          onSpeak: onSpeak,
        ),
      ),
    );
  }

  // Le bouton rouge est désormais la seule cible qui appelle : le nom
  // « SAMU » se comporte comme un nom de contact ordinaire (parle sur simple
  // appui, n'appelle jamais). C'est donc le bouton, pas la carte entière,
  // qu'il faut viser dans ces tests.
  for (final layout in ContactLayout.values) {
    group('disposition ${layout.name}', () {
      final buttonFinder = layout == ContactLayout.compact
          ? find.byType(CallButton)
          : find.byType(FullWidthCallButton);

      testWidgets(
          'un simple appui sur le bouton rouge prononce SAMU et n appelle '
          'jamais — la propriete de securite', (tester) async {
        var spoken = 0;
        var called = 0;
        await tester.pumpWidget(host(
          onCall: () => called++,
          onSpeak: () => spoken++,
          layout: layout,
        ));

        // Le bouton visuel est enveloppé d'un `IgnorePointer` — le geste réel
        // est capté par le `GestureDetector` englobant — donc on tape sur ses
        // coordonnées plutôt que de demander à `tap()` de hit-tester le
        // `CallButton`/`FullWidthCallButton` lui-même.
        await tester.tapAt(tester.getCenter(buttonFinder));
        // Flutter retarde l'appel de `onTap` le temps de vérifier qu'aucun
        // second appui ne survient (délai de désambiguïsation double-tap).
        // On avance le temps de ce délai sans provoquer de second appui.
        await tester.pump(kDoubleTapTimeout);

        expect(spoken, 1, reason: 'un appui simple doit prononcer SAMU');
        expect(called, 0,
            reason: 'un appui simple ne doit jamais declencher un appel');
      });

      testWidgets('un double appui sur le bouton rouge appelle',
          (tester) async {
        var spoken = 0;
        var called = 0;
        await tester.pumpWidget(host(
          onCall: () => called++,
          onSpeak: () => spoken++,
          layout: layout,
        ));

        // Voir plus haut : `IgnorePointer` oblige à taper sur les coordonnées
        // du bouton plutôt que sur le widget lui-même.
        await tester.tapAt(tester.getCenter(buttonFinder));
        await tester.pump(kDoubleTapMinTime);
        await tester.tapAt(tester.getCenter(buttonFinder));
        await tester.pumpAndSettle();

        expect(called, 1, reason: 'un double appui doit declencher un appel');
      });

      testWidgets('un appui sur le nom prononce SAMU et n appelle jamais',
          (tester) async {
        var spoken = 0;
        var called = 0;
        await tester.pumpWidget(host(
          onCall: () => called++,
          onSpeak: () => spoken++,
          layout: layout,
        ));

        await tester.tap(find.text('SAMU'));
        await tester.pumpAndSettle();

        expect(spoken, 1, reason: 'un appui sur le nom doit prononcer SAMU');
        expect(called, 0,
            reason: 'un appui sur le nom ne doit jamais declencher un appel');
      });
    });
  }
}
