import 'dart:ui';

import 'package:big_call_app/domain/entities/app_settings.dart';

class PaletteColors {
  const PaletteColors({
    required this.background,
    required this.onBackground,
    required this.border,
    required this.button,
    required this.onButton,
    required this.header,
    required this.onHeader,
    required this.emergency,
    required this.onEmergency,
  });

  final Color background;
  final Color onBackground;
  final Color border;

  /// Vert assombri : un combiné blanc sur le vert Material vif (#00C853)
  /// ne donne que 2:1 et se délave dans le rond.
  final Color button;
  final Color onButton;
  final Color header;
  final Color onHeader;

  /// Rouge du bouton d'appel de la carte SAMU — carte de contact ordinaire
  /// dont seul le bouton diffère par sa couleur. Deux contraintes, comme
  /// pour le bouton vert : l'icône blanche dessus >= 4,5:1, et le bouton
  /// contre le fond de sa carte (`background`) >= 3:1 (cible tactile).
  /// Mesuré : icône blanche sur rouge = 4,98:1 (les trois palettes) ; bouton
  /// sur fond = 4,98:1 (clair) / 4,22:1 (sombre et jaune, fond noir).
  final Color emergency;
  final Color onEmergency;
}

const _green = Color(0xFF0E7A38);
const _white = Color(0xFFFFFFFF);
const _black = Color(0xFF000000);
const _yellow = Color(0xFFFFE24D);
const _emergency = Color(0xFFD32F2F);

const paletteColors = <AppPalette, PaletteColors>{
  AppPalette.light: PaletteColors(
    background: _white,
    onBackground: _black,
    border: _black,
    button: _green,
    onButton: _white,
    header: Color(0xFFE0E0E0),
    onHeader: _black,
    emergency: _emergency,
    onEmergency: _white,
  ),
  AppPalette.dark: PaletteColors(
    background: _black,
    onBackground: _white,
    border: Color(0xFF9E9E9E),
    button: _green,
    onButton: _white,
    header: Color(0xFF1C1C1C),
    onHeader: _white,
    emergency: _emergency,
    onEmergency: _white,
  ),
  AppPalette.yellow: PaletteColors(
    background: _black,
    onBackground: _yellow,
    border: _yellow,
    button: _green,
    onButton: _white,
    header: Color(0xFF1C1C1C),
    onHeader: _yellow,
    emergency: _emergency,
    onEmergency: _white,
  ),
};
