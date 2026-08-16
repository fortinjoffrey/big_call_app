import 'dart:io';

import 'package:big_call_app/core/failure.dart';
import 'package:big_call_app/core/result.dart';
import 'package:big_call_app/data/contacts/contact_mapper.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';
import 'package:big_call_app/domain/ports/contact_repository.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;

class FlutterContactsRepository implements ContactRepository {
  const FlutterContactsRepository(this._mapper);

  final ContactMapper _mapper;

  /// `isFavorite` n'est renseigné que sur Android.
  @override
  bool get supportsFavorites => Platform.isAndroid;

  @override
  Future<Result<List<PhoneContact>>> loadContacts() async {
    try {
      final status =
          await fc.FlutterContacts.permissions.request(fc.PermissionType.read);
      final granted = status == fc.PermissionStatus.granted ||
          status == fc.PermissionStatus.limited;
      if (!granted) return const Err(Failure.permissionDenied());

      // `favorite` est ignoré sur iOS par le plugin lui-même, ce qui est
      // exactement le comportement voulu : supportsFavorites y est déjà faux.
      final raw = await fc.FlutterContacts.getAll(
        properties: {fc.ContactProperty.phone, fc.ContactProperty.favorite},
      );

      final contacts = <PhoneContact>[];
      for (final contact in raw) {
        final mapped = _mapper.toDomain(contact);
        if (mapped != null) contacts.add(mapped);
      }
      return Ok(contacts);
    } on Object catch (error) {
      // `Object` et non `Exception` : le plugin décode du JSON venu du natif,
      // une Error de conversion de type échapperait à `on Exception` et
      // planterait l'app au démarrage — écran noir, chez quelqu'un qui ne peut
      // ni le comprendre ni le rapporter. La lecture est pure, il n'y a aucun
      // état à corrompre, donc rattraper large ne coûte rien ici.
      return Err(Failure.unknown(error.toString()));
    }
  }
}
