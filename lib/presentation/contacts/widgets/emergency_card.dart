import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/presentation/contacts/widgets/call_button.dart';
import 'package:big_call_app/presentation/contacts/widgets/card_shell.dart';
import 'package:flutter/material.dart';

/// Carte d'appel d'urgence SAMU. Une carte de contact ordinaire — même
/// géométrie, même nom en couleur normale — à ceci près que son bouton
/// d'appel est rouge et n'appelle jamais sur un simple toucher : un doigt qui
/// se pose par erreur sur le bouton ne doit rien déclencher.
///
/// Le rouge du bouton est désormais le seul indice que ce bouton se comporte
/// différemment des boutons verts. Le double appui a été choisi par la
/// propriétaire de l'application, explicitement préféré à l'appui long — un
/// simple toucher égaré ne fait rien, et si l'appel part quand même par
/// erreur, elle sait raccrocher.
class EmergencyCard extends StatelessWidget {
  const EmergencyCard({
    required this.palette,
    required this.layout,
    required this.onCall,
    required this.onSpeak,
    super.key,
  });

  final AppPalette palette;
  final ContactLayout layout;
  final VoidCallback onCall;
  final VoidCallback onSpeak;

  static const _name = 'SAMU';

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[palette]!;
    final theme = Theme.of(context);

    return CardShell(
      colors: colors,
      child: switch (layout) {
        ContactLayout.compact => _compactRow(theme, colors),
        ContactLayout.wide => _wideLayout(theme, colors),
      },
    );
  }

  /// Zone tactile du nom : identique dans l'esprit à celle d'une carte de
  /// contact, un simple toucher prononce le nom. En disposition compacte,
  /// l'espacement avant le bouton est du padding *à l'intérieur* du
  /// détecteur (et non un SizedBox voisin), pour qu'aucun pixel entre le mot
  /// et le rond rouge ne reste sourd au toucher.
  Widget _nameZone(ThemeData theme, {double trailingPadding = 0}) {
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onSpeak,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(right: trailingPadding),
            child: Text(_name, style: theme.textTheme.displayLarge),
          ),
        ),
      ),
    );
  }

  /// Le rond rouge, seule cible qui appelle — et seulement sur double appui.
  /// Le [CallButton]/[FullWidthCallButton] n'est réutilisé que pour sa forme
  /// et sa couleur : leur propre détecteur interne (`onPressed`, appui
  /// simple immédiat) ne convient pas ici, donc il est neutralisé par
  /// [IgnorePointer] (et ses propres sémantiques exclues par
  /// [ExcludeSemantics], la carte les fournissant déjà) et remplacé par un
  /// [GestureDetector] englobant qui combine `onTap` (parle) et
  /// `onDoubleTap` (appelle) — exactement le mécanisme de désambiguïsation
  /// déjà éprouvé quand toute la carte portait ces deux gestes.
  Widget _buttonZone(Widget button) {
    return Semantics(
      button: true,
      label: '$_name, appuyez deux fois pour appeler',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onSpeak,
        onDoubleTap: onCall,
        child: ExcludeSemantics(
          child: IgnorePointer(child: button),
        ),
      ),
    );
  }

  Widget _compactRow(ThemeData theme, PaletteColors colors) {
    return Row(
      children: [
        Expanded(child: _nameZone(theme, trailingPadding: 10)),
        _buttonZone(
          CallButton(
            palette: palette,
            color: colors.emergency,
            semanticLabel: _name,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _wideLayout(ThemeData theme, PaletteColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _nameZone(theme),
        const SizedBox(height: 12),
        _buttonZone(
          FullWidthCallButton(
            palette: palette,
            color: colors.emergency,
            semanticLabel: _name,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
