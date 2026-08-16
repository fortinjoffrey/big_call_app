import 'package:big_call_app/domain/entities/contact_number.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;

/// Seul endroit du projet qui connaît la forme des objets `flutter_contacts`.
/// Il en extrait quatre informations et jette tout le reste.
class ContactMapper {
  const ContactMapper();

  /// Rend `null` pour un contact sans numéro : il n'y aurait rien à appeler.
  PhoneContact? toDomain(fc.Contact contact) {
    if (contact.phones.isEmpty) return null;

    final name = (contact.displayName ?? '').trim();
    return PhoneContact(
      // Un contact sans identifiant retombe sur la chaîne vide : ils se
      // confondraient donc entre eux. Sans conséquence tant que l'id ne sert
      // pas de Key de widget — ce qui n'est pas le cas aujourd'hui.
      id: contact.id ?? '',
      displayName: name.isEmpty ? 'Sans nom' : name,
      isFavorite: contact.android?.isFavorite ?? false,
      numbers: [
        for (final phone in contact.phones)
          ContactNumber(number: phone.number, label: labelFor(phone)),
      ],
    );
  }

  String labelFor(fc.Phone phone) {
    final label = phone.label.label;
    if (label == fc.PhoneLabel.custom) {
      final custom = (phone.label.customLabel ?? '').trim();
      return custom.isEmpty ? 'Autre' : custom;
    }
    return switch (label) {
      fc.PhoneLabel.mobile => 'Mobile',
      fc.PhoneLabel.home => 'Fixe',
      fc.PhoneLabel.work => 'Bureau',
      fc.PhoneLabel.main => 'Principal',
      fc.PhoneLabel.workMobile => 'Mobile bureau',
      fc.PhoneLabel.iPhone => 'Mobile',
      fc.PhoneLabel.companyMain => 'Standard',
      fc.PhoneLabel.homeFax ||
      fc.PhoneLabel.workFax ||
      fc.PhoneLabel.otherFax => 'Fax',
      _ => 'Autre',
    };
  }
}
