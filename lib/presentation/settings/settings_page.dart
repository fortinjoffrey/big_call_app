import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/domain/entities/contact_number.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:big_call_app/presentation/contacts/widgets/contact_card.dart';
import 'package:big_call_app/presentation/settings/settings_bloc.dart';
import 'package:big_call_app/presentation/settings/settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _previewContact = PhoneContact(
  id: 'preview',
  displayName: 'Marie',
  isFavorite: true,
  numbers: [
    ContactNumber(number: '0611223344', label: 'Mobile'),
    ContactNumber(number: '0122334455', label: 'Fixe'),
  ],
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
              Text('Aperçu', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              // L'aperçu utilise le vrai widget : ce qu'on voit ici est
              // exactement ce que la liste affichera.
              // `IgnorePointer` : sans lui, le bouton vert de l'aperçu réagit
              // au toucher (ondulation de l'InkWell) sans rien déclencher. Un
              // retour visuel suivi de rien se lit comme une panne, pas comme
              // un aperçu. Mieux vaut qu'il ne réagisse pas du tout.
              IgnorePointer(
                child: ContactCard(
                  contact: _previewContact,
                  palette: settings.palette,
                  layout: settings.layout,
                  onSpeak: (_) {},
                  onCall: (_) {},
                ),
              ),
              const SizedBox(height: 28),
              Text('Thème', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              for (final palette in AppPalette.values)
                _ChoiceTile(
                  label: palette.label,
                  selected: palette == settings.palette,
                  palette: settings.palette,
                  onTap: () =>
                      context.read<SettingsBloc>().add(ThemeSelected(palette)),
                ),
              const SizedBox(height: 28),
              Text('Taille du texte', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final size in TextSize.values)
                    Expanded(
                      child: _ChoiceTile(
                        label: size.label,
                        selected: size == settings.textSize,
                        palette: settings.palette,
                        centered: true,
                        onTap: () => context.read<SettingsBloc>().add(
                          TextSizeSelected(size),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 28),
              Text('Disposition', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              for (final layout in ContactLayout.values)
                _ChoiceTile(
                  label: layout.label,
                  selected: layout == settings.layout,
                  palette: settings.palette,
                  onTap: () =>
                      context.read<SettingsBloc>().add(LayoutSelected(layout)),
                ),
            ],
          ),
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
    this.centered = false,
  });

  final String label;
  final bool selected;
  final AppPalette palette;
  final VoidCallback onTap;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final colors = paletteColors[palette]!;
    final theme = Theme.of(context);

    // La sélection se signale par l'épaisseur de la bordure et une coche,
    // jamais par une nuance de couleur seule.
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
            mainAxisAlignment: centered
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
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
