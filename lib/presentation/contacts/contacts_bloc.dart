import 'package:big_call_app/core/failure.dart';
import 'package:big_call_app/core/result.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:big_call_app/domain/ports/call_service.dart';
import 'package:big_call_app/domain/ports/contact_repository.dart';
import 'package:big_call_app/domain/ports/speech_service.dart';
import 'package:big_call_app/presentation/contacts/contacts_event.dart';
import 'package:big_call_app/presentation/contacts/contacts_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc(this._repository, this._callService, this._speech)
      : super(const ContactsLoading()) {
    on<ContactsRequested>(_onRequested);
    // C'est le `stop()` en tête de `_onSpoken` qui coupe la parole en cours —
    // pas ce transformer. `restartable()` annule la suite d'un gestionnaire
    // interrompu, or `speak()` est sa dernière instruction : il n'y a rien à
    // annuler après. On le garde parce qu'il évite l'empilement de
    // gestionnaires si `speak` devient lent, mais ne pas supprimer le `stop()`
    // en croyant qu'il fait doublon.
    on<LabelSpoken>(_onSpoken, transformer: restartable());
    on<CallRequested>(_onCall);
    on<CallErrorDismissed>(_onErrorDismissed);
  }

  final ContactRepository _repository;
  final CallService _callService;
  final SpeechService _speech;

  Future<void> _onRequested(
    ContactsRequested event,
    Emitter<ContactsState> emit,
  ) async {
    emit(const ContactsLoading());

    final result = await _repository.loadContacts();
    switch (result) {
      case Err(:final failure):
        emit(switch (failure) {
          PermissionDeniedFailure() => const ContactsPermissionDenied(),
          _ => ContactsError(failure),
        });
      case Ok(:final value):
        final supportsFavorites = _repository.supportsFavorites;
        final favorites = supportsFavorites
            ? value.where((c) => c.isFavorite).toList()
            : <PhoneContact>[];
        final others = supportsFavorites
            ? value.where((c) => !c.isFavorite).toList()
            : List<PhoneContact>.from(value);

        emit(ContactsReady(
          favorites: _sorted(favorites),
          others: _sorted(others),
          showFavoritesSection: supportsFavorites,
        ));
    }
  }

  Future<void> _onSpoken(LabelSpoken event, Emitter<ContactsState> emit) async {
    await _speech.stop();
    await _speech.speak(event.text);
  }

  Future<void> _onCall(CallRequested event, Emitter<ContactsState> emit) async {
    final result = await _callService.call(event.number);
    final current = state;
    if (result is Err<void> && current is ContactsReady) {
      emit(current.copyWith(callError: result.failure));
    }
  }

  void _onErrorDismissed(
    CallErrorDismissed event,
    Emitter<ContactsState> emit,
  ) {
    final current = state;
    if (current is ContactsReady) emit(current.copyWith(callError: null));
  }

  List<PhoneContact> _sorted(List<PhoneContact> contacts) {
    final copy = List<PhoneContact>.from(contacts)
      ..sort((a, b) =>
          a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
    return copy;
  }
}
