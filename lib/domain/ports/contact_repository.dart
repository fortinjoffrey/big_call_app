import 'package:big_call_app/core/result.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';

abstract interface class ContactRepository {
  /// Faux sur iOS : aucune API publique n'expose les favoris du système.
  /// La page masque alors la section « Favoris » au lieu de l'afficher vide.
  bool get supportsFavorites;

  Future<Result<List<PhoneContact>>> loadContacts();
}
