import 'package:big_call_app/core/failure.dart';
import 'package:big_call_app/core/theme/app_palettes.dart';
import 'package:big_call_app/domain/contact_initial.dart';
import 'package:big_call_app/domain/emergency_grouping.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:big_call_app/presentation/contacts/contacts_bloc.dart';
import 'package:big_call_app/presentation/contacts/contacts_event.dart';
import 'package:big_call_app/presentation/contacts/contacts_state.dart';
import 'package:big_call_app/presentation/contacts/widgets/contact_card.dart';
import 'package:big_call_app/presentation/contacts/widgets/letter_scroll_announcer.dart';
import 'package:big_call_app/presentation/contacts/widgets/message_screen.dart';
import 'package:big_call_app/presentation/contacts/widgets/section_header.dart';
import 'package:big_call_app/presentation/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({
    required this.palette,
    required this.layout,
    required this.emergencyStyle,
    this.uppercaseNames = false,
    this.speakScrollLetters = true,
    super.key,
  });

  final AppPalette palette;
  final ContactLayout layout;
  final EmergencyStyle emergencyStyle;
  final bool uppercaseNames;
  final bool speakScrollLetters;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  final _letterAnchors = LetterAnchorRegistry();
  final _announcerKey = GlobalKey<LetterScrollAnnouncerState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _scrollToTop();
    }
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;

    _announcerKey.currentState?.forget();
    _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ContactsBloc, ContactsState>(
          listenWhen: (previous, current) =>
              current is ContactsReady && current.callError != null,
          listener: (context, state) => _showCallError(context),
          builder: (context, state) => switch (state) {
            ContactsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ContactsPermissionDenied() => MessageScreen(
              palette: widget.palette,
              message:
                  "L'application a besoin de l'accès à vos contacts pour "
                  'les afficher.',
              actionLabel: 'AUTORISER',
              onAction: () => context.read<ContactsBloc>().add(
                const SystemSettingsRequested(),
              ),
            ),
            ContactsError() => MessageScreen(
              palette: widget.palette,
              message: "Les contacts n'ont pas pu être chargés.",
              actionLabel: 'RÉESSAYER',
              onAction: () =>
                  context.read<ContactsBloc>().add(const ContactsRequested()),
            ),
            ContactsReady(:final favorites, :final others) =>
              favorites.isEmpty && others.isEmpty
                  ? MessageScreen(
                      palette: widget.palette,
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

    final highlight = widget.emergencyStyle != EmergencyStyle.none;

    Widget card(PhoneContact contact) => ContactCard(
      contact: contact,
      palette: widget.palette,
      layout: widget.layout,
      highlightEmergencyNumbers: highlight,
      uppercaseNames: widget.uppercaseNames,
      onSpeak: (text) => bloc.add(LabelSpoken(text)),
      onCall: (number) => bloc.add(CallRequested(number.number)),
    );

    Widget announcedCard(PhoneContact contact) => widget.speakScrollLetters
        ? LetterAnchor(
            registry: _letterAnchors,
            letter: initialLetter(contact),
            child: card(contact),
          )
        : card(contact);

    final useSection = widget.emergencyStyle == EmergencyStyle.section;
    final favorites = useSection
        ? withoutEmergency(state.favorites)
        : state.favorites;
    final others = useSection ? withoutEmergency(state.others) : state.others;
    final emergency = useSection
        ? [...emergencyAmong(state.favorites), ...emergencyAmong(state.others)]
        : const <PhoneContact>[];

    final sections = <List<Widget>>[
      if (state.showFavoritesSection)
        [
          SectionHeader(
            title: 'Favoris',
            icon: Icons.star,
            palette: widget.palette,
            onLongPress: () => _openSettings(context),
          ),
          ...favorites.map(card),
        ],
      if (emergency.isNotEmpty)
        [
          SectionHeader(
            title: 'Urgence',
            icon: Icons.phone,
            iconColor: paletteColors[widget.palette]!.emergency,
            palette: widget.palette,
          ),
          ...emergency.map(card),
        ],
      [
        SectionHeader(
          title: 'Autres contacts',
          palette: widget.palette,

          onLongPress: state.showFavoritesSection
              ? null
              : () => _openSettings(context),
        ),
        ...others.map(announcedCard),
      ],
    ];

    final children = <Widget>[
      for (var i = 0; i < sections.length; i++) ...[
        if (i > 0) const SizedBox(height: 20),
        ...sections[i],
      ],
    ];

    final list = ListView.builder(
      controller: _scrollController,
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );

    if (!widget.speakScrollLetters) return list;

    return LetterScrollAnnouncer(
      key: _announcerKey,
      registry: _letterAnchors,
      onLetterReached: (letter) => bloc.add(LabelSpoken(letter)),
      child: list,
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SettingsPage()));
  }

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
        backgroundColor: paletteColors[widget.palette]!.background,
        child: MessageScreen(
          palette: widget.palette,
          message: message,
          actionLabel: 'FERMER',
          onAction: () => Navigator.of(dialogContext).pop(),
        ),
      ),
    );

    bloc.add(const CallErrorDismissed());
  }
}
