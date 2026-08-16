import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:flutter/material.dart';

/// Enveloppe géométrique commune à toutes les cartes de la liste (contact ou
/// SAMU) : mêmes marges, même remplissage, même bordure franche de 3 px, même
/// rayon, aucune ombre. Extrait pour que la carte SAMU ne réimplémente pas
/// cette géométrie à côté de [ContactCard] — seul son contenu diffère.
class CardShell extends StatelessWidget {
  const CardShell({
    required this.colors,
    required this.child,
    super.key,
  });

  final PaletteColors colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Bordure franche de 3 px, aucune ombre : une élévation est un indice de
    // profondeur subtil, invisible en vision périphérique.
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border.all(color: colors.border, width: 3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}
