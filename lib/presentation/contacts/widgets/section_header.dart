import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    required this.palette,
    this.onLongPress,
    super.key,
  });

  final String title;
  final AppPalette palette;

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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
