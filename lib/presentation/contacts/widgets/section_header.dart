import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/core/theme/text_sizes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    required this.palette,
    this.icon,
    this.iconColor,
    this.onLongPress,
    super.key,
  });

  final String title;
  final AppPalette palette;

  /// Décoration à côté du libellé — ne suit pas le palier M/L/XL, ce n'est
  /// pas une cible de lecture.
  final IconData? icon;

  /// Couleur de l'icône. Par défaut `colors.onHeader` ; la section URGENCE
  /// la remplace par `colors.emergency` pour que son pictogramme se
  /// détache du bandeau au même titre qu'un bouton d'appel rouge.
  final Color? iconColor;

  /// Appui long : seul accès aux réglages. Un geste qu'on ne fait jamais
  /// par accident, donc pas d'atterrissage involontaire dans les réglages.
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[palette]!;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        width: double.infinity,
        color: colors.header,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: kHeaderBaseSize * 1.4, color: iconColor ?? colors.onHeader),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
