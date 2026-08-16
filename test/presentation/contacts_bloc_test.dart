import 'package:big_call_app/core/failure.dart';
import 'package:big_call_app/core/result.dart';
import 'package:big_call_app/domain/ports/call_service.dart';
import 'package:big_call_app/domain/ports/contact_repository.dart';
import 'package:big_call_app/domain/ports/speech_service.dart';
import 'package:big_call_app/presentation/contacts/contacts_bloc.dart';
import 'package:big_call_app/presentation/contacts/contacts_event.dart';
import 'package:big_call_app/presentation/contacts/contacts_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../support/fixtures.dart';

class _MockRepository extends Mock implements ContactRepository {}

class _MockCallService extends Mock implements CallService {}

class _MockSpeechService extends Mock implements SpeechService {}

void main() {
  late _MockRepository repository;
  late _MockCallService callService;
  late _MockSpeechService speech;

  ContactsBloc build() => ContactsBloc(repository, callService, speech);

  setUp(() {
    repository = _MockRepository();
    callService = _MockCallService();
    speech = _MockSpeechService();

    when(() => repository.supportsFavorites).thenReturn(true);
    when(() => repository.loadContacts())
        .thenAnswer((_) async => const Ok(allContacts));
    when(() => callService.call(any())).thenAnswer((_) async => const Ok(null));
    when(() => speech.speak(any())).thenAnswer((_) async {});
    when(() => speech.stop()).thenAnswer((_) async {});
  });

  blocTest<ContactsBloc, ContactsState>(
    'separe les favoris des autres et trie chaque groupe par nom',
    build: build,
    act: (bloc) => bloc.add(const ContactsRequested()),
    expect: () => [
      const ContactsLoading(),
      isA<ContactsReady>()
          .having((s) => s.favorites.map((c) => c.displayName).toList(),
              'favoris tries', ['Joffrey', 'Marie'])
          .having((s) => s.others.map((c) => c.displayName).toList(),
              'autres tries', ['Anne-Marie Delacroix', 'Docteur Martin'])
          .having((s) => s.showFavoritesSection, 'section favoris', true),
    ],
  );

  blocTest<ContactsBloc, ContactsState>(
    'masque la section favoris quand la plateforme ne les fournit pas',
    build: () {
      when(() => repository.supportsFavorites).thenReturn(false);
      return build();
    },
    act: (bloc) => bloc.add(const ContactsRequested()),
    skip: 1,
    expect: () => [
      isA<ContactsReady>()
          .having((s) => s.showFavoritesSection, 'section favoris', false)
          .having((s) => s.others.length, 'tous les contacts', 4)
          .having((s) => s.favorites, 'aucun favori', isEmpty),
    ],
  );

  blocTest<ContactsBloc, ContactsState>(
    'expose un etat dedie quand la permission est refusee',
    build: () {
      when(() => repository.loadContacts())
          .thenAnswer((_) async => const Err(Failure.permissionDenied()));
      return build();
    },
    act: (bloc) => bloc.add(const ContactsRequested()),
    expect: () => [const ContactsLoading(), const ContactsPermissionDenied()],
  );

  // Ce test prouve l'ORDRE stop→speak, qui est le mécanisme réel de
  // l'interruption. Il ne teste pas `restartable()` : avec un `speak` simulé
  // qui rend la main immédiatement, les deux gestionnaires ne se chevauchent
  // jamais, et retirer le transformer laisse ce test au vert.
  blocTest<ContactsBloc, ContactsState>(
    'chaque parole commence par couper la precedente (stop avant speak)',
    build: build,
    act: (bloc) async {
      bloc.add(const LabelSpoken('Marie'));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const LabelSpoken('Marie Mobile'));
      await Future<void>.delayed(const Duration(milliseconds: 10));
    },
    verify: (_) {
      verifyInOrder([
        () => speech.stop(),
        () => speech.speak('Marie'),
        () => speech.stop(),
        () => speech.speak('Marie Mobile'),
      ]);
    },
  );

  blocTest<ContactsBloc, ContactsState>(
    'la parole n emet aucun etat',
    build: build,
    act: (bloc) => bloc.add(const LabelSpoken('Marie')),
    expect: () => <ContactsState>[],
  );

  blocTest<ContactsBloc, ContactsState>(
    'un echec d appel remonte dans callError puis se dissipe',
    build: () {
      when(() => callService.call(any()))
          .thenAnswer((_) async => const Err(Failure.unavailable()));
      return build();
    },
    act: (bloc) async {
      bloc.add(const ContactsRequested());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const CallRequested('0611223344'));
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const CallErrorDismissed());
    },
    skip: 2,
    expect: () => [
      isA<ContactsReady>()
          .having((s) => s.callError, 'erreur', const Failure.unavailable()),
      isA<ContactsReady>().having((s) => s.callError, 'erreur effacee', isNull),
    ],
  );
}
