import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/core/theme/app_theme.dart';
import 'package:big_call_app/core/theme/text_sizes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('le palier multiplie les tailles de base', () {
    final m = buildTheme(AppPalette.light, TextSize.m);
    final xl = buildTheme(AppPalette.light, TextSize.xl);

    expect(m.textTheme.displayLarge!.fontSize, kNameBaseSize);
    expect(xl.textTheme.displayLarge!.fontSize, kNameBaseSize * 1.5);
    expect(xl.textTheme.titleLarge!.fontSize, kLabelBaseSize * 1.5);
  });

  test('la palette pilote les couleurs du theme', () {
    final light = buildTheme(AppPalette.light, TextSize.m);
    final dark = buildTheme(AppPalette.dark, TextSize.m);

    expect(
      light.scaffoldBackgroundColor,
      paletteColors[AppPalette.light]!.background,
    );
    expect(
      dark.scaffoldBackgroundColor,
      paletteColors[AppPalette.dark]!.background,
    );
  });

  test('la police Atkinson Hyperlegible est appliquee', () {
    final theme = buildTheme(AppPalette.light, TextSize.m);
    expect(theme.textTheme.displayLarge!.fontFamily, 'Atkinson Hyperlegible');
  });

  test('l en-tete prend la couleur de son propre fond, pas celle du corps', () {
    final theme = buildTheme(AppPalette.yellow, TextSize.m);
    final colors = paletteColors[AppPalette.yellow]!;

    expect(theme.textTheme.labelLarge!.color, colors.onHeader);
    expect(theme.textTheme.displayLarge!.color, colors.onBackground);
  });
}
