import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/domain/entities/contact_number.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:big_call_app/presentation/contacts/widgets/call_button.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    required this.contact,
    required this.palette,
    required this.onSpeak,
    required this.onCall,
    super.key,
  });

  final PhoneContact contact;
  final AppPalette palette;
  final void Function(String text) onSpeak;
  final void Function(ContactNumber number) onCall;

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[palette]!;
    final theme = Theme.of(context);

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
      child: contact.hasSingleNumber
          ? _singleNumberRow(theme)
          : _nameWithNumberRows(theme),
    );
  }

  /// Un seul numéro : nom et bouton sur la même ligne, sans libellé.
  Widget _singleNumberRow(ThemeData theme) {
    final number = contact.numbers.single;
    return Row(
      children: [
        Expanded(
          // `button: true` sans `label` : on conserve le texte lu par le lecteur
          // d'écran et on ajoute seulement l'information « ceci réagit au
          // toucher », que le bouton vert porte déjà de son côté.
          child: Semantics(
            button: true,
            child: GestureDetector(
              // La zone tactile doit couvrir toute la largeur, pas seulement
              // les lettres : viser en périphérie, c'est poser le doigt à côté
              // du mot. L'Expanded fournit déjà la largeur ; l'espacement visuel
              // avant le bouton est du padding *à l'intérieur* du détecteur (et
              // non un SizedBox voisin), pour qu'aucun pixel entre le mot et le
              // rond vert ne reste sourd au toucher. `opaque` la rend sensible
              // partout, y compris sur ce padding.
              behavior: HitTestBehavior.opaque,
              onTap: () => onSpeak(contact.displayName),
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(contact.displayName, style: theme.textTheme.displayLarge),
              ),
            ),
          ),
        ),
        CallButton(
          palette: palette,
          semanticLabel: 'Appeler ${contact.displayName}',
          onPressed: () => onCall(number),
        ),
      ],
    );
  }

  Widget _nameWithNumberRows(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          button: true,
          child: GestureDetector(
            // Pas d'Expanded ici : la Column ne contraint pas la largeur, donc
            // le détecteur épouse le mot. Le SizedBox l'élargit à toute la
            // ligne, `opaque` la rend sensible partout.
            behavior: HitTestBehavior.opaque,
            onTap: () => onSpeak(contact.displayName),
            child: SizedBox(
              width: double.infinity,
              child: Text(contact.displayName, style: theme.textTheme.displayLarge),
            ),
          ),
        ),
        for (final number in contact.numbers)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    button: true,
                    child: GestureDetector(
                      // Même raisonnement que pour le nom en ligne unique :
                      // l'espacement avant le bouton est un padding interne au
                      // détecteur, pas un SizedBox voisin, pour rester sensible
                      // jusqu'au bord du bouton.
                      behavior: HitTestBehavior.opaque,
                      onTap: () =>
                          onSpeak('${contact.displayName} ${number.label}'),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          number.label,
                          textAlign: TextAlign.right,
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                ),
                CallButton(
                  palette: palette,
                  semanticLabel:
                      'Appeler ${contact.displayName} ${number.label}',
                  onPressed: () => onCall(number),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
