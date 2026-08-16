import 'package:big_call_app/domain/entities/contact_number.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';

const marie = PhoneContact(
  id: '1',
  displayName: 'Marie',
  isFavorite: true,
  numbers: [
    ContactNumber(number: '0611223344', label: 'Mobile'),
    ContactNumber(number: '0155667788', label: 'Fixe'),
  ],
);

const joffrey = PhoneContact(
  id: '2',
  displayName: 'Joffrey',
  isFavorite: true,
  numbers: [ContactNumber(number: '0622334455', label: 'Mobile')],
);

const docteur = PhoneContact(
  id: '3',
  displayName: 'Docteur Martin',
  isFavorite: false,
  numbers: [ContactNumber(number: '0144556677', label: 'Bureau')],
);

const anneMarie = PhoneContact(
  id: '4',
  displayName: 'Anne-Marie Delacroix',
  isFavorite: false,
  numbers: [ContactNumber(number: '0633445566', label: 'Mobile')],
);

const samu = PhoneContact(
  id: '5',
  displayName: 'SAMU',
  isFavorite: true,
  numbers: [ContactNumber(number: '15', label: 'Fixe')],
);

const allContacts = [marie, joffrey, docteur, anneMarie];
