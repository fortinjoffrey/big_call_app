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
}

const _green = Color(0xFF0E7A38);
const _white = Color(0xFFFFFFFF);
const _black = Color(0xFF000000);
const _yellow = Color(0xFFFFE24D);

const paletteColors = <AppPalette, PaletteColors>{
  AppPalette.light: PaletteColors(
    background: _white,
    onBackground: _black,
    border: _black,
    button: _green,
    onButton: _white,
    header: Color(0xFFE0E0E0),
    onHeader: _black,
  ),
  AppPalette.dark: PaletteColors(
    background: _black,
    onBackground: _white,
    border: Color(0xFF9E9E9E),
    button: _green,
    onButton: _white,
    header: Color(0xFF1C1C1C),
    onHeader: _white,
  ),
  AppPalette.yellow: PaletteColors(
    background: _black,
    onBackground: _yellow,
    border: _yellow,
    button: _green,
    onButton: _white,
    header: Color(0xFF1C1C1C),
    onHeader: _yellow,
  ),
};
