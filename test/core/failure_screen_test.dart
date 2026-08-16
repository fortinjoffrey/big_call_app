import 'package:big_call_app/core/failure_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureScreen', () {
    testWidgets('affiche le message fourni, lisible sans thème', (
      tester,
    ) async {
      await tester.pumpWidget(const FailureScreen('Un problème est survenu.'));

      expect(find.text('Un problème est survenu.'), findsOneWidget);

      final text = tester.widget<Text>(find.text('Un problème est survenu.'));
      expect(text.style?.fontSize, 30);
      expect(text.style?.color, Colors.black);
    });

    testWidgets('fonctionne sans MaterialApp ni Directionality ambiante', (
      tester,
    ) async {
      await tester.pumpWidget(const FailureScreen('Message minimal'));

      expect(tester.takeException(), isNull);
      expect(find.text('Message minimal'), findsOneWidget);
    });
  });

  group('FailureApp', () {
    testWidgets('monte sans MaterialApp et affiche le message de secours', (
      tester,
    ) async {
      await tester.pumpWidget(const FailureApp());

      expect(tester.takeException(), isNull);
      expect(
        find.textContaining('Un problème est survenu au démarrage'),
        findsOneWidget,
      );
    });
  });
}
