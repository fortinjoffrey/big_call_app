import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:diacritic/diacritic.dart';

final _letter = RegExp(r'^[A-Z]$');

String? initialLetter(PhoneContact contact) {
  final normalized = removeDiacritics(contact.displayName.trim());
  if (normalized.isEmpty) return null;

  final first = normalized[0].toUpperCase();
  return _letter.hasMatch(first) ? first : null;
}
