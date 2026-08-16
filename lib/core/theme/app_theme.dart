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
        //
        // Mesuré : à taille 34, la boîte d'une ligne passe de 37 px (1,1) à
        // 44 px (1,3) — Flutter applique le multiplicateur à CHAQUE ligne,
        // seule ou non, ce qui grossirait chaque carte d'environ 18 %.
        // Compensé au niveau de l'arbre par un TextHeightBehavior
        // (applyHeightToFirstAscent: false, applyHeightToLastDescent: false)
        // posé dans MaterialApp.builder — voir app.dart. Sans lui, ce 1,3
        // coûte un contact visible par écran.
        height: 1.3,
      );

  return ThemeData(
    useMaterial3: true,
    fontFamily: kFontFamily,
    scaffoldBackgroundColor: colors.background,
    // Attention : fromSeed dérive une trentaine de rôles depuis la graine et
    // seuls les quatre surchargés ci-dessous sont passés par les assertions de
    // contraste. Ne pas consommer les autres (`error`, `outline`,
    // `surfaceContainerHighest`…) dans un widget : ce serait afficher une
    // couleur que rien ne vérifie, à quelqu'un qui a besoin de 7:1 partout.
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors.button,
      brightness:
          palette == AppPalette.light ? Brightness.light : Brightness.dark,
      surface: colors.background,
      onSurface: colors.onBackground,
      primary: colors.button,
      onPrimary: colors.onButton,
    ),
    // Seuls ces trois emplacements sont remplis. Tout widget Material qui
    // utiliserait `bodyMedium`, `titleMedium` ou un autre slot retomberait sur
    // les tailles Material par défaut — du petit texte, dans une app qui ne
    // doit jamais en afficher. Les widgets ne doivent lire que ces trois-là.
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
