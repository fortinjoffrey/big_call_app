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

  final bool highlightEmergencyNumbers;

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
        ContactLayout.compact =>
          contact.hasSingleNumber
              ? _singleNumberRow(theme, colors)
              : _nameWithNumberRows(theme, colors),
        ContactLayout.wide => _wideLayout(theme, colors),
      },
    );
  }

  bool _isRed(ContactNumber number) =>
      highlightEmergencyNumbers && number.isEmergency;

  Widget _singleNumberRow(ThemeData theme, PaletteColors colors) {
    final number = contact.numbers.single;
    return Row(
      children: [
        Expanded(
          child: Semantics(
            button: true,
            child: GestureDetector(
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

  Widget _nameZone(ThemeData theme) {
    return Semantics(
      button: true,
      child: GestureDetector(
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

  Widget _wideLayout(ThemeData theme, PaletteColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _nameZone(theme),
        for (final number in contact.numbers) ...[
          const SizedBox(height: 12),

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
