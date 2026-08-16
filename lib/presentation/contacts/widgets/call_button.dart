import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';

/// 72 px : le double du minimum tactile recommandé par Android. Délibéré.
///
/// Volontairement fixe, y compris au palier XL : la cible dépasse déjà
/// largement tous les seuils d'accessibilité, et l'agrandir coûterait de la
/// densité de liste — donc du défilement, le geste le plus coûteux pour elle.
/// Ne pas la brancher sur le multiplicateur de taille de texte.
const double kCallButtonSize = 72;

/// Variante pleine largeur du bouton d'appel, pour la disposition « large » :
/// le nom du contact occupe toute la largeur de la carte et le bouton se
/// place en dessous plutôt qu'à côté. Rectangle arrondi au lieu d'un cercle,
/// donc un widget distinct plutôt qu'un habillage de [CallButton] (dont la
/// forme circulaire et la taille fixe sont le point même du bouton compact).
class FullWidthCallButton extends StatelessWidget {
  const FullWidthCallButton({
    required this.palette,
    required this.onPressed,
    required this.semanticLabel,
    super.key,
  });

  final AppPalette palette;
  final VoidCallback onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[palette]!;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: SizedBox(
        width: double.infinity,
        height: kCallButtonSize,
        child: Material(
          color: colors.button,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colors.border, width: 3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onTap: onPressed,
            child: Icon(
              Icons.phone,
              size: kCallButtonSize * 0.5,
              color: colors.onButton,
            ),
          ),
        ),
      ),
    );
  }
}

class CallButton extends StatelessWidget {
  const CallButton({
    required this.palette,
    required this.onPressed,
    required this.semanticLabel,
    super.key,
  });

  final AppPalette palette;
  final VoidCallback onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[palette]!;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: SizedBox(
        width: kCallButtonSize,
        height: kCallButtonSize,
        child: Material(
          color: colors.button,
          shape: CircleBorder(
            side: BorderSide(color: colors.border, width: 3),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Icon(
              Icons.phone,
              size: kCallButtonSize * 0.5,
              color: colors.onButton,
            ),
          ),
        ),
      ),
    );
  }
}
