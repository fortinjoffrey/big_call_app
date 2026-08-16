import 'package:big_call_app/core/failure.dart';
import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:big_call_app/presentation/contacts/contacts_bloc.dart';
import 'package:big_call_app/presentation/contacts/contacts_event.dart';
import 'package:big_call_app/presentation/contacts/contacts_state.dart';
import 'package:big_call_app/presentation/contacts/widgets/contact_card.dart';
import 'package:big_call_app/presentation/contacts/widgets/emergency_card.dart';
import 'package:big_call_app/presentation/contacts/widgets/message_screen.dart';
import 'package:big_call_app/presentation/contacts/widgets/section_header.dart';
import 'package:big_call_app/presentation/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({required this.palette, required this.layout, super.key});

  final AppPalette palette;
  final ContactLayout layout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ContactsBloc, ContactsState>(
          listenWhen: (previous, current) =>
              current is ContactsReady && current.callError != null,
          listener: (context, state) => _showCallError(context),
          builder: (context, state) => switch (state) {
            ContactsLoading() => const Center(child: CircularProgressIndicator()),
            ContactsPermissionDenied() => MessageScreen(
                palette: palette,
                message:
                    "L'application a besoin de l'accès à vos contacts pour "
                    'les afficher.',
                actionLabel: 'AUTORISER',
                onAction: () => context
                    .read<ContactsBloc>()
                    .add(const SystemSettingsRequested()),
              ),
            ContactsError() => MessageScreen(
                palette: palette,
                message: "Les contacts n'ont pas pu être chargés.",
                actionLabel: 'RÉESSAYER',
                onAction: () => context
                    .read<ContactsBloc>()
                    .add(const ContactsRequested()),
              ),
            ContactsReady(:final favorites, :final others) =>
              favorites.isEmpty && others.isEmpty
                  ? MessageScreen(
                      palette: palette,
                      message: 'Aucun contact dans ce téléphone.',
                    )
                  : _buildList(context, state),
          },
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, ContactsReady state) {
    final bloc = context.read<ContactsBloc>();

    Widget card(PhoneContact contact) => ContactCard(
          contact: contact,
          palette: palette,
          layout: layout,
          onSpeak: (text) => bloc.add(LabelSpoken(text)),
          onCall: (number) => bloc.add(CallRequested(number.number)),
        );

    final children = <Widget>[
      if (state.showFavoritesSection) ...[
        SectionHeader(
          title: 'Favoris',
          icon: Icons.star,
          palette: palette,
          onLongPress: () => _openSettings(context),
        ),
        ...state.favorites.map(card),
      ],
      EmergencyCard(
        palette: palette,
        layout: layout,
        onSpeak: () => bloc.add(const LabelSpoken('SAMU')),
        onCall: () => bloc.add(const EmergencyCallRequested()),
      ),
      SectionHeader(
        title: 'Tous les contacts',
        palette: palette,
        // Sur iOS la section « Favoris » est masquée : l'appui long doit
        // rester atteignable, il passe donc sur cet en-tête.
        onLongPress:
            state.showFavoritesSection ? null : () => _openSettings(context),
      ),
      ...state.others.map(card),
    ];

    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
    );
  }

  /// Pas de SnackBar : petit, peu contrasté, disparu en trois secondes.
  Future<void> _showCallError(BuildContext context) async {
    final bloc = context.read<ContactsBloc>();
    final state = bloc.state;
    final failure = state is ContactsReady ? state.callError : null;

    final message = switch (failure) {
      PermissionDeniedFailure() =>
        "L'application n'a pas le droit de passer des appels.",
      _ => "L'appel n'a pas pu être lancé.",
    };

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog.fullscreen(
        backgroundColor: paletteColors[palette]!.background,
        child: MessageScreen(
          palette: palette,
          message: message,
          actionLabel: 'FERMER',
          onAction: () => Navigator.of(dialogContext).pop(),
        ),
      ),
    );

    bloc.add(const CallErrorDismissed());
  }
}
