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

/// Double appui sur la carte SAMU. Numéro fixe (15), jamais choisi par
/// l'appelant : c'est le seul numéro d'urgence qu'elle utiliserait.
final class EmergencyCallRequested extends ContactsEvent {
  const EmergencyCallRequested();
}

final class CallErrorDismissed extends ContactsEvent {
  const CallErrorDismissed();
}

final class SystemSettingsRequested extends ContactsEvent {
  const SystemSettingsRequested();
}
