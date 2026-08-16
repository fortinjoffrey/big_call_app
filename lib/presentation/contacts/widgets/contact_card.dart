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
          child: GestureDetector(
            onTap: () => onSpeak(contact.displayName),
            child: Text(contact.displayName, style: theme.textTheme.displayLarge),
          ),
        ),
        const SizedBox(width: 10),
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
        GestureDetector(
          onTap: () => onSpeak(contact.displayName),
          child: Text(contact.displayName, style: theme.textTheme.displayLarge),
        ),
        for (final number in contact.numbers)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        onSpeak('${contact.displayName} ${number.label}'),
                    child: Text(number.label, style: theme.textTheme.titleLarge),
                  ),
                ),
                const SizedBox(width: 10),
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
