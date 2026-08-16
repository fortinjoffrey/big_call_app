import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';

/// Carte d'appel d'urgence SAMU. Elle n'appelle jamais sur un simple
/// toucher : un doigt qui se pose par erreur ne doit rien déclencher.
/// Le double appui a été choisi par la propriétaire de l'application,
/// explicitement préféré à l'appui long — un simple toucher égaré ne fait
/// rien, et si l'appel part quand même par erreur, elle sait raccrocher.
class EmergencyCard extends StatelessWidget {
  const EmergencyCard({
    required this.palette,
    required this.onCall,
    required this.onSpeak,
    super.key,
  });

  final AppPalette palette;
  final VoidCallback onCall;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[palette]!;
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: 'SAMU, appuyez deux fois pour appeler',
      child: GestureDetector(
        // Toute la carte doit réagir, pas seulement les glyphes du texte.
        behavior: HitTestBehavior.opaque,
        // Toucher parle, comme partout ailleurs dans l'application : ça
        // confirme que le doigt est bien posé sur la carte. Seul le double
        // appui appelle.
        onTap: onSpeak,
        onDoubleTap: onCall,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.emergency,
            border: Border.all(color: colors.border, width: 3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SAMU',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge
                    ?.copyWith(color: colors.onEmergency),
              ),
              Text(
                '15',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge
                    ?.copyWith(color: colors.onEmergency),
              ),
              Text(
                'Appuyez deux fois',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge
                    ?.copyWith(color: colors.onEmergency),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
