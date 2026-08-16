import 'dart:ui';

double contrastRatio(Color a, Color b) {
  assert(
    a.a == 1.0 && b.a == 1.0,
    'contrastRatio exige des couleurs opaques : alpha ${a.a} et ${b.a}',
  );

  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}
