import 'package:big_call_app/core/theme/app_theme.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/presentation/contacts/widgets/emergency_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host({
    required VoidCallback onCall,
    required VoidCallback onSpeak,
  }) {
    return MaterialApp(
      theme: buildTheme(AppPalette.light, TextSize.m),
      home: Scaffold(
        body: EmergencyCard(
          palette: AppPalette.light,
          onCall: onCall,
          onSpeak: onSpeak,
        ),
      ),
    );
  }

  testWidgets(
      'un simple appui prononce SAMU et n appelle jamais — la propriete de securite',
      (tester) async {
    var spoken = 0;
    var called = 0;
    await tester.pumpWidget(host(
      onCall: () => called++,
      onSpeak: () => spoken++,
    ));

    await tester.tap(find.byType(EmergencyCard));
    // Flutter retarde l'appel de `onTap` le temps de vérifier qu'aucun
    // second appui ne survient (délai de désambiguïsation double-tap).
    // On avance le temps de ce délai sans provoquer de second appui.
    await tester.pump(kDoubleTapTimeout);

    expect(spoken, 1, reason: 'un appui simple doit prononcer SAMU');
    expect(called, 0,
        reason: 'un appui simple ne doit jamais declencher un appel');
  });

  testWidgets('un double appui appelle', (tester) async {
    var spoken = 0;
    var called = 0;
    await tester.pumpWidget(host(
      onCall: () => called++,
      onSpeak: () => spoken++,
    ));

    await tester.tap(find.byType(EmergencyCard));
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(find.byType(EmergencyCard));
    await tester.pumpAndSettle();

    expect(called, 1, reason: 'un double appui doit declencher un appel');
  });
}
