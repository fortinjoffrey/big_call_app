import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/domain/entities/contact_number.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:big_call_app/presentation/contacts/widgets/call_button.dart';
import 'package:big_call_app/presentation/contacts/widgets/card_shell.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    required this.contact,
    required this.palette,
    required this.layout,
    required this.onSpeak,
    required this.onCall,
    this.highlightEmergencyNumbers = false,
    this.uppercaseNames = false,
    super.key,
  });

  final PhoneContact contact;
  final AppPalette palette;
  final ContactLayout layout;
  final void Function(String text) onSpeak;
  final void Function(ContactNumber number) onCall;

  /// Vrai dans les styles « section » et « bouton rouge » : les numéros
  /// d'urgence portés par [contact] reçoivent un bouton rouge, appelé sur un
  /// appui simple exactement comme n'importe quel autre bouton — le rouge
  /// n'est plus qu'un repère visuel. Faux dans le style « comme les autres
  /// contacts » : même un numéro d'urgence garde alors un bouton vert.
  final bool highlightEmergencyNumbers;

  /// Affiche le nom du contact et les libellés de numéro (« Mobile »,
  /// « Fixe »...) en capitales quand le réglage est actif. Ne touche jamais
  /// à ce qui est prononcé ou lu par un lecteur d'écran (`onSpeak`,
  /// `semanticLabel`) : ces textes gardent leur casse d'origine, car un
  /// mot tout en capitales peut être épelé lettre par lettre par certains
  /// moteurs de synthèse vocale.
  final bool uppercaseNames;

  String get _displayName =>
      uppercaseNames ? contact.displayName.toUpperCase() : contact.displayName;

  String _displayLabel(ContactNumber number) =>
      uppercaseNames ? number.label.toUpperCase() : number.label;

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[palette]!;
    final theme = Theme.of(context);

    return CardShell(
      colors: colors,
      child: switch (layout) {
        ContactLayout.compact => contact.hasSingleNumber
            ? _singleNumberRow(theme, colors)
            : _nameWithNumberRows(theme, colors),
        ContactLayout.wide => _wideLayout(theme, colors),
      },
    );
  }

  bool _isRed(ContactNumber number) =>
      highlightEmergencyNumbers && number.isEmergency;

  /// Un seul numéro : nom et bouton sur la même ligne, sans libellé.
  Widget _singleNumberRow(ThemeData theme, PaletteColors colors) {
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
                child: Text(_displayName, style: theme.textTheme.displayLarge),
              ),
            ),
          ),
        ),
        CallButton(
          palette: palette,
          color: _isRed(number) ? colors.emergency : null,
          semanticLabel: 'Appeler ${contact.displayName}',
          onPressed: () => onCall(number),
        ),
      ],
    );
  }

  /// Zone tactile du nom, pleine largeur, partagée par les deux dispositions
  /// à numéros multiples : ni l'une ni l'autre ne contraint sa largeur via un
  /// `Expanded`, donc le `SizedBox` fait tout le travail d'élargissement.
  Widget _nameZone(ThemeData theme) {
    return Semantics(
      button: true,
      child: GestureDetector(
        // Pas d'Expanded ici : la Column ne contraint pas la largeur, donc
        // le détecteur épouse le mot. Le SizedBox l'élargit à toute la
        // ligne, `opaque` la rend sensible partout.
        behavior: HitTestBehavior.opaque,
        onTap: () => onSpeak(contact.displayName),
        child: SizedBox(
          width: double.infinity,
          child: Text(_displayName, style: theme.textTheme.displayLarge),
        ),
      ),
    );
  }

  Widget _nameWithNumberRows(ThemeData theme, PaletteColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _nameZone(theme),
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
                          _displayLabel(number),
                          textAlign: TextAlign.right,
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                ),
                CallButton(
                  palette: palette,
                  color: _isRed(number) ? colors.emergency : null,
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

  /// Disposition « large » : le nom occupe toute la largeur et n'est jamais
  /// comprimé par le bouton rond. Le bouton d'appel, plein largeur, se place
  /// en dessous — sous son libellé quand il y en a un.
  Widget _wideLayout(ThemeData theme, PaletteColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _nameZone(theme),
        for (final number in contact.numbers) ...[
          const SizedBox(height: 12),
          // Un seul numéro : pas de libellé, « Mobile » ne veut rien dire
          // sans numéro alternatif à distinguer.
          if (!contact.hasSingleNumber) ...[
            _labelZone(theme, number),
            const SizedBox(height: 8),
          ],
          FullWidthCallButton(
            palette: palette,
            color: _isRed(number) ? colors.emergency : null,
            semanticLabel: contact.hasSingleNumber
                ? 'Appeler ${contact.displayName}'
                : 'Appeler ${contact.displayName} ${number.label}',
            onPressed: () => onCall(number),
          ),
        ],
      ],
    );
  }

  /// Libellé centré, pleine largeur : il légende le bouton juste en dessous,
  /// qui occupe la même largeur, donc le centrage se lit comme une légende
  /// plutôt que comme un second nom.
  Widget _labelZone(ThemeData theme, ContactNumber number) {
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onSpeak('${contact.displayName} ${number.label}'),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            _displayLabel(number),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
