import 'package:big_call_app/domain/emergency_grouping.dart';
import 'package:big_call_app/domain/entities/contact_number.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:flutter_test/flutter_test.dart';

const _marie = PhoneContact(
  id: '1',
  displayName: 'Marie',
  isFavorite: true,
  numbers: [ContactNumber(number: '0611223344', label: 'Mobile')],
);

const _samu = PhoneContact(
  id: '2',
  displayName: 'SAMU',
  isFavorite: true,
  numbers: [ContactNumber(number: '15', label: 'Fixe')],
);

const _docteur = PhoneContact(
  id: '3',
  displayName: 'Docteur Martin',
  isFavorite: false,
  numbers: [
    ContactNumber(number: '0144556677', label: 'Bureau'),
    ContactNumber(number: '15', label: 'Urgences'),
  ],
);

void main() {
  test(
    'emergencyAmong ne garde que les contacts porteurs d un numero d urgence',
    () {
      expect(emergencyAmong([_marie, _samu, _docteur]), [_samu, _docteur]);
    },
  );

  test('withoutEmergency ne garde que les contacts sans numero d urgence', () {
    expect(withoutEmergency([_marie, _samu, _docteur]), [_marie]);
  });

  test(
    'un contact sans numero d urgence n apparait jamais dans emergencyAmong',
    () {
      expect(emergencyAmong([_marie]), isEmpty);
    },
  );

  test(
    'un contact avec un numero d urgence n apparait jamais dans withoutEmergency',
    () {
      expect(withoutEmergency([_samu]), isEmpty);
    },
  );

  test('l ordre d origine est preserve dans les deux listes', () {
    expect(emergencyAmong([_docteur, _samu, _marie]), [_docteur, _samu]);
    expect(withoutEmergency([_docteur, _samu, _marie]), [_marie]);
  });
}
