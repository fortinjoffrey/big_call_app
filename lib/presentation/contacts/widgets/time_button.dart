import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/core/theme/text_sizes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';

const double kTimeButtonMinHeight = 96;

class TimeButton extends StatelessWidget {
  const TimeButton({required this.palette, required this.onPressed, super.key});

  final AppPalette palette;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[palette]!;
    final shape = RoundedRectangleBorder(
      side: BorderSide(color: colors.border, width: 3),
      borderRadius: BorderRadius.circular(14),
    );

    // Couleurs inversées par rapport au fond : le bouton se distingue des
    // cartes sans pouvoir être confondu avec un bouton d'appel vert.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Semantics(
        button: true,
        label: "Écouter l'heure",
        excludeSemantics: true,
        child: Material(
          color: colors.onBackground,
          shape: shape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: kTimeButtonMinHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      size: kNameBaseSize * 1.6,
                      color: colors.background,
                    ),
                    const SizedBox(width: 14),
                    Flexible(
                      child: Text(
                        "L'HEURE",
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(color: colors.background),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
