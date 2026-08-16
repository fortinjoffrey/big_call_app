sealed class ContactsEvent {
  const ContactsEvent();
}

final class ContactsRequested extends ContactsEvent {
  const ContactsRequested();
}

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

final class SystemSettingsRequested extends ContactsEvent {
  const SystemSettingsRequested();
}
