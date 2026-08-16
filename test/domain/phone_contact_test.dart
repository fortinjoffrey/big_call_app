import 'package:big_call_app/domain/entities/contact_number.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('un contact avec un seul numero d urgence est repere', () {
    const contact = PhoneContact(
      id: '1',
      displayName: 'SAMU',
      isFavorite: true,
      numbers: [ContactNumber(number: '15', label: 'Fixe')],
    );

    expect(contact.hasEmergencyNumber, isTrue);
  });

  test('un contact sans numero d urgence n est pas repere', () {
    const contact = PhoneContact(
      id: '2',
      displayName: 'Marie',
      isFavorite: true,
      numbers: [ContactNumber(number: '0611223344', label: 'Mobile')],
    );

    expect(contact.hasEmergencyNumber, isFalse);
  });

  test(
      'un contact avec un numero d urgence parmi d autres numeros est repere',
      () {
    const contact = PhoneContact(
      id: '3',
      displayName: 'Marie',
      isFavorite: true,
      numbers: [
        ContactNumber(number: '0611223344', label: 'Mobile'),
        ContactNumber(number: '15', label: 'Fixe'),
      ],
    );

    expect(contact.hasEmergencyNumber, isTrue);
  });
}
