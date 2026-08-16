import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/contrast.dart';

void main() {
  for (final palette in AppPalette.values) {
    final colors = paletteColors[palette]!;

    group('palette ${palette.name}', () {
      test('texte sur fond >= 7:1 (WCAG AAA)', () {
        expect(contrastRatio(colors.onBackground, colors.background),
            greaterThanOrEqualTo(7.0));
      });

      test('icone sur bouton vert >= 4.5:1', () {
        expect(contrastRatio(colors.onButton, colors.button),
            greaterThanOrEqualTo(4.5));
      });

      test('bordure sur fond >= 3:1 (composant non textuel)', () {
        expect(contrastRatio(colors.border, colors.background),
            greaterThanOrEqualTo(3.0));
      });

      test('en-tete de section : texte sur son fond >= 7:1', () {
        expect(contrastRatio(colors.onHeader, colors.header),
            greaterThanOrEqualTo(7.0));
      });

      test('pastille verte sur fond >= 3:1 (cible tactile)', () {
        // Le bouton est la seule cible qu'elle doit viser : le disque lui-même
        // doit se détacher du fond, pas seulement l'icône qu'il contient.
        // Contrainte opposée à celle de l'icône — assombrir le vert améliore
        // l'une et dégrade l'autre, d'où l'intérêt de tester les deux.
        expect(contrastRatio(colors.button, colors.background),
            greaterThanOrEqualTo(3.0));
      });

      test('texte SAMU sur rouge >= 4.5:1 (grand texte)', () {
        expect(contrastRatio(colors.onEmergency, colors.emergency),
            greaterThanOrEqualTo(4.5));
      });

      test('carte SAMU sur fond >= 3:1', () {
        expect(contrastRatio(colors.emergency, colors.background),
            greaterThanOrEqualTo(3.0));
      });
    });
  }
}
