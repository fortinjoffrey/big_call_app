import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/domain/entities/contact_number.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:big_call_app/presentation/contacts/widgets/contact_card.dart';
import 'package:big_call_app/presentation/contacts/widgets/section_header.dart';
import 'package:big_call_app/presentation/settings/settings_bloc.dart';
import 'package:big_call_app/presentation/settings/settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _previewContact = PhoneContact(
  id: 'preview',
  displayName: 'Marie',
  isFavorite: true,
  numbers: [ContactNumber(number: '0611223344', label: 'Mobile')],
);

const _previewEmergencyContact = PhoneContact(
  id: 'preview-emergency',
  displayName: 'SAMU',
  isFavorite: true,
  numbers: [ContactNumber(number: '15', label: 'Fixe')],
);

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsBloc>().state;
    final colors = paletteColors[settings.palette]!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.header,
        foregroundColor: colors.onHeader,
        iconTheme: IconThemeData(color: colors.onHeader, size: 34),
        title: Text('Réglages', style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Section(
                title: 'Aperçu',
                palette: settings.palette,
                tiles: [_Preview(settings: settings)],
              ),
              _Section(
                title: 'Thème',
                palette: settings.palette,
                tiles: [
                  for (final palette in AppPalette.values)
                    _ChoiceTile(
                      label: palette.label,
                      selected: palette == settings.palette,
                      palette: settings.palette,
                      onTap: () => context.read<SettingsBloc>().add(
                        ThemeSelected(palette),
                      ),
                    ),
                ],
              ),
              _Section(
                title: 'Taille du texte',
                palette: settings.palette,
                tiles: [
                  for (final size in TextSize.values)
                    _ChoiceTile(
                      label: size.label,
                      selected: size == settings.textSize,
                      palette: settings.palette,
                      onTap: () => context.read<SettingsBloc>().add(
                        TextSizeSelected(size),
                      ),
                    ),
                ],
              ),
              _Section(
                title: 'Nom des contacts',
                palette: settings.palette,
                tiles: [
                  _ChoiceTile(
                    label: 'MAJUSCULES',
                    selected: settings.uppercaseNames,
                    palette: settings.palette,
                    onTap: () => context.read<SettingsBloc>().add(
                      const UppercaseNamesSelected(true),
                    ),
                  ),
                  _ChoiceTile(
                    label: 'Normal',
                    selected: !settings.uppercaseNames,
                    palette: settings.palette,
                    onTap: () => context.read<SettingsBloc>().add(
                      const UppercaseNamesSelected(false),
                    ),
                  ),
                ],
              ),
              _Section(
                title: 'Annonce des lettres',
                palette: settings.palette,
                tiles: [
                  _ChoiceTile(
                    label: 'ACTIV\u00c9E',
                    selected: settings.speakScrollLetters,
                    palette: settings.palette,
                    onTap: () => context.read<SettingsBloc>().add(
                      const ScrollLettersSelected(true),
                    ),
                  ),
                  _ChoiceTile(
                    label: 'D\u00c9SACTIV\u00c9E',
                    selected: !settings.speakScrollLetters,
                    palette: settings.palette,
                    onTap: () => context.read<SettingsBloc>().add(
                      const ScrollLettersSelected(false),
                    ),
                  ),
                ],
              ),
              _Section(
                title: 'Disposition',
                palette: settings.palette,
                tiles: [
                  for (final layout in ContactLayout.values)
                    _ChoiceTile(
                      label: layout.label,
                      selected: layout == settings.layout,
                      palette: settings.palette,
                      onTap: () => context.read<SettingsBloc>().add(
                        LayoutSelected(layout),
                      ),
                    ),
                ],
              ),
              _Section(
                title: "Numéros d'urgence",
                palette: settings.palette,
                isLast: true,
                tiles: [
                  for (final style in EmergencyStyle.values)
                    _ChoiceTile(
                      label: style.label,
                      selected: style == settings.emergencyStyle,
                      palette: settings.palette,
                      onTap: () => context.read<SettingsBloc>().add(
                        EmergencyStyleSelected(style),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _previewCard(settings, emergency: false),
        const SizedBox(height: 12),
        _previewCard(settings, emergency: true),
      ],
    );
  }

  Widget _previewCard(AppSettings settings, {required bool emergency}) {
    return IgnorePointer(
      child: ContactCard(
        contact: emergency ? _previewEmergencyContact : _previewContact,
        palette: settings.palette,
        layout: settings.layout,
        uppercaseNames: settings.uppercaseNames,

        highlightEmergencyNumbers:
            emergency && settings.emergencyStyle != EmergencyStyle.none,
        onSpeak: (_) {},
        onCall: (_) {},
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.palette,
    required this.tiles,
    this.isLast = false,
  });

  final String title;
  final AppPalette palette;
  final List<Widget> tiles;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[palette]!;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: colors.border, width: 3),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(title: title, palette: palette),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: tiles,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.label,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[palette]!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            border: Border.all(color: colors.border, width: selected ? 6 : 3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              if (selected) ...[
                Icon(Icons.check, size: 32, color: colors.onBackground),
                const SizedBox(width: 10),
              ],
              Flexible(child: Text(label, style: theme.textTheme.titleLarge)),
            ],
          ),
        ),
      ),
    );
  }
}
