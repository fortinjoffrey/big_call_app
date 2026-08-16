import 'package:big_call_app/data/contacts/contact_mapper.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:flutter_test/flutter_test.dart';

fc.Contact _contact({
  String id = '1',
  String name = 'Marie Dupont',
  List<fc.Phone> phones = const [],
  bool starred = false,
}) {
  return fc.Contact(
    id: id,
    displayName: name,
    phones: phones,
    android: fc.AndroidData(isFavorite: starred),
  );
}

void main() {
  const mapper = ContactMapper();

  test('traduit les libelles standard en francais', () {
    expect(
      mapper.labelFor(
        fc.Phone(number: '1', label: const fc.Label(fc.PhoneLabel.mobile)),
      ),
      'Mobile',
    );
    expect(
      mapper.labelFor(
        fc.Phone(number: '1', label: const fc.Label(fc.PhoneLabel.home)),
      ),
      'Fixe',
    );
    expect(
      mapper.labelFor(
        fc.Phone(number: '1', label: const fc.Label(fc.PhoneLabel.work)),
      ),
      'Bureau',
    );
    expect(
      mapper.labelFor(
        fc.Phone(number: '1', label: const fc.Label(fc.PhoneLabel.main)),
      ),
      'Principal',
    );
  });

  test('traduit iPhone et companyMain', () {
    expect(
      mapper.labelFor(
        fc.Phone(number: '1', label: const fc.Label(fc.PhoneLabel.iPhone)),
      ),
      'Mobile',
    );
    expect(
      mapper.labelFor(
        fc.Phone(
          number: '1',
          label: const fc.Label(fc.PhoneLabel.companyMain),
        ),
      ),
      'Standard',
    );
  });

  test('conserve un libelle personnalise saisi par l utilisateur', () {
    final phone = fc.Phone(
      number: '1',
      label: const fc.Label(fc.PhoneLabel.custom, 'Maison de campagne'),
    );
    expect(mapper.labelFor(phone), 'Maison de campagne');
  });

  test('retombe sur Autre quand le libelle personnalise est vide', () {
    final phone = fc.Phone(
      number: '1',
      label: const fc.Label(fc.PhoneLabel.custom, ''),
    );
    expect(mapper.labelFor(phone), 'Autre');
  });

  test('retombe sur Autre quand le libelle personnalise est nul', () {
    final phone = fc.Phone(
      number: '1',
      label: const fc.Label(fc.PhoneLabel.custom),
    );
    expect(mapper.labelFor(phone), 'Autre');
  });

  test('retombe sur Autre quand le libelle personnalise n est que des espaces', () {
    final phone = fc.Phone(
      number: '1',
      label: const fc.Label(fc.PhoneLabel.custom, '   '),
    );
    expect(mapper.labelFor(phone), 'Autre');
  });

  test('extrait nom, numeros et statut favori', () {
    final contact = _contact(
      phones: [
        fc.Phone(
          number: '06 11 22 33 44',
          label: const fc.Label(fc.PhoneLabel.mobile),
        ),
        fc.Phone(
          number: '01 55 66 77 88',
          label: const fc.Label(fc.PhoneLabel.home),
        ),
      ],
      starred: true,
    );

    final result = mapper.toDomain(contact)!;

    expect(result.displayName, 'Marie Dupont');
    expect(result.isFavorite, isTrue);
    expect(result.numbers.length, 2);
    expect(result.numbers.first.number, '06 11 22 33 44');
    expect(result.numbers.first.label, 'Mobile');
    expect(result.numbers.last.label, 'Fixe');
  });

  test('ignore un contact sans aucun numero', () {
    expect(mapper.toDomain(_contact()), isNull);
  });

  test('remplace un nom vide par un libelle explicite', () {
    final contact = _contact(
      name: '',
      phones: [
        fc.Phone(
          number: '0611223344',
          label: const fc.Label(fc.PhoneLabel.mobile),
        ),
      ],
    );
    expect(mapper.toDomain(contact)!.displayName, 'Sans nom');
  });
}
