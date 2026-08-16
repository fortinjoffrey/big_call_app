import 'dart:ui';

/// Ratio de contraste WCAG 2.1 entre deux couleurs opaques.
/// `Color.computeLuminance()` implémente déjà la luminance relative WCAG.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}
