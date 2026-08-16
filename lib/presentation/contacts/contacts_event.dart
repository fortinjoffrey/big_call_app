sealed class ContactsEvent {
  const ContactsEvent();
}

final class ContactsRequested extends ContactsEvent {
  const ContactsRequested();
}

/// Texte déjà composé par la carte : « Marie » ou « Marie Mobile ».
final class LabelSpoken extends ContactsEvent {
  const LabelSpoken(this.text);
  final String text;
}

final class CallRequested extends ContactsEvent {
  const CallRequested(this.number);
  final String number;
}

final class CallErrorDismissed extends ContactsEvent {
  const CallErrorDismissed();
}
