import 'dart:ui';

/// Ratio de contraste WCAG 2.1 entre deux couleurs opaques.
/// `Color.computeLuminance()` implémente déjà la luminance relative WCAG.
///
/// Les deux couleurs DOIVENT être opaques : `computeLuminance()` ne lit que
/// les composantes rouge, verte et bleue et ignore l'alpha. Une couleur
/// translucide serait donc mesurée comme si elle était pleine, et le ratio
/// décrirait une couleur qui n'apparaît jamais à l'écran — le test passerait
/// au vert sur une fiction.
double contrastRatio(Color a, Color b) {
  assert(a.a == 1.0 && b.a == 1.0,
      'contrastRatio exige des couleurs opaques : alpha ${a.a} et ${b.a}');

  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}
