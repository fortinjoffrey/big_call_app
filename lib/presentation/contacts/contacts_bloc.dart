import 'package:big_call_app/core/failure.dart';
import 'package:big_call_app/core/result.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:big_call_app/domain/ports/call_service.dart';
import 'package:big_call_app/domain/ports/contact_repository.dart';
import 'package:big_call_app/domain/ports/speech_service.dart';
import 'package:big_call_app/domain/ports/system_settings_service.dart';
import 'package:big_call_app/presentation/contacts/contacts_event.dart';
import 'package:big_call_app/presentation/contacts/contacts_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc(
    this._repository,
    this._callService,
    this._speech,
    this._systemSettings,
  ) : super(const ContactsLoading()) {
    on<ContactsRequested>(_onRequested);

    on<LabelSpoken>(_onSpoken, transformer: restartable());
    on<CallRequested>(_onCall);
    on<CallErrorDismissed>(_onErrorDismissed);
    on<SystemSettingsRequested>(
      (event, emit) => _systemSettings.openAppSettings(),
    );
  }

  final ContactRepository _repository;
  final CallService _callService;
  final SpeechService _speech;
  final SystemSettingsService _systemSettings;

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

        emit(
          ContactsReady(
            favorites: _sorted(favorites),
            others: _sorted(others),
            showFavoritesSection: supportsFavorites,
          ),
        );
    }
  }

  Future<void> _onSpoken(LabelSpoken event, Emitter<ContactsState> emit) async {
    await _speech.stop();
    await _speech.speak(event.text);
  }

  Future<void> _onCall(CallRequested event, Emitter<ContactsState> emit) =>
      _call(event.number, emit);

  Future<void> _call(String number, Emitter<ContactsState> emit) async {
    final result = await _callService.call(number);

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
    String key(PhoneContact c) => removeDiacritics(c.displayName).toLowerCase();

    final copy = List<PhoneContact>.from(contacts)
      ..sort((a, b) => key(a).compareTo(key(b)));
    return copy;
  }
}
