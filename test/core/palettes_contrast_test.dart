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
    });
  }
}
