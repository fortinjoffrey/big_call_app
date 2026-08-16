import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/core/theme/text_sizes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';

const kFontFamily = 'Atkinson Hyperlegible';

/// Seul endroit du projet qui transforme (palette, palier) en ThemeData.
/// Aucun widget ne code une couleur ni une taille en dur.
ThemeData buildTheme(AppPalette palette, TextSize size) {
  final colors = paletteColors[palette]!;
  final scale = size.multiplier;

  TextStyle style(double base, FontWeight weight, Color color) => TextStyle(
        fontFamily: kFontFamily,
        fontSize: base * scale,
        fontWeight: weight,
        color: color,
        // 1,3 et non 1,1 : l'interligne ne compte que sur du texte qui se
        // replie — un nom long au palier XL, un message plein écran. C'est
        // exactement là qu'un interligne serré nuit, parce que la vision
        // périphérique distingue mal des lignes qui se touchent.
        height: 1.3,
      );

  return ThemeData(
    useMaterial3: true,
    fontFamily: kFontFamily,
    scaffoldBackgroundColor: colors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors.button,
      brightness:
          palette == AppPalette.light ? Brightness.light : Brightness.dark,
      surface: colors.background,
      onSurface: colors.onBackground,
      primary: colors.button,
      onPrimary: colors.onButton,
    ),
    textTheme: TextTheme(
      // Nom du contact
      displayLarge: style(kNameBaseSize, FontWeight.w700, colors.onBackground),
      // Libellé de numéro (« Mobile », « Fixe »)
      titleLarge: style(kLabelBaseSize, FontWeight.w700, colors.onBackground),
      // En-tête de section
      labelLarge: style(kHeaderBaseSize, FontWeight.w700, colors.onHeader),
    ),
  );
}
