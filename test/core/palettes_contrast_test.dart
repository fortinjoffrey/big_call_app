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

      test('icone du bouton SAMU (blanche) sur rouge >= 4.5:1', () {
        // Même seuil que l'icône du bouton vert : la carte SAMU est
        // désormais une carte de contact ordinaire, seul son bouton d'appel
        // change de couleur, donc il est jugé au même critère qu'un bouton
        // d'appel — plus le seuil AAA « grand texte » qui n'a plus de sens
        // ici puisque « SAMU » n'est plus écrit en blanc sur rouge.
        expect(contrastRatio(colors.onEmergency, colors.emergency),
            greaterThanOrEqualTo(4.5));
      });

      test('bouton rouge SAMU sur le fond de sa carte >= 3:1', () {
        // Le rouge n'est plus un aplat plein cadre : c'est un bouton rond
        // posé sur `colors.background`, la même couleur que le fond de la
        // carte de contact (et de l'écran). Cible tactile non textuelle,
        // même seuil que la pastille verte.
        expect(contrastRatio(colors.emergency, colors.background),
            greaterThanOrEqualTo(3.0));
      });
    });
  }
}
