import 'package:big_call_app/domain/contact_initial.dart';
import 'package:big_call_app/domain/entities/contact_number.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:flutter_test/flutter_test.dart';

PhoneContact contact(String name) => PhoneContact(
  id: name,
  displayName: name,
  isFavorite: false,
  numbers: const [ContactNumber(number: '0600000000', label: 'Mobile')],
);

void main() {
  test('renvoie la premiere lettre en majuscule', () {
    expect(initialLetter(contact('anne-marie')), 'A');
    expect(initialLetter(contact('Docteur Martin')), 'D');
  });

  test('ignore les accents', () {
    expect(initialLetter(contact('Élodie')), 'E');
    expect(initialLetter(contact('Ǎnna')), 'A');
  });

  test('ignore les espaces de tete', () {
    expect(initialLetter(contact('  Marie')), 'M');
  });

  test('renvoie null quand le nom ne commence pas par une lettre', () {
    expect(initialLetter(contact('112')), isNull);
    expect(initialLetter(contact('+33 6 12 34 56 78')), isNull);
    expect(initialLetter(contact('')), isNull);
  });
}
