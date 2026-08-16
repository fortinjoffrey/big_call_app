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

  @override
  bool get supportsFavorites => Platform.isAndroid;

  @override
  Future<Result<List<PhoneContact>>> loadContacts() async {
    try {
      final status = await fc.FlutterContacts.permissions.request(
        fc.PermissionType.read,
      );
      final granted =
          status == fc.PermissionStatus.granted ||
          status == fc.PermissionStatus.limited;
      if (!granted) return const Err(Failure.permissionDenied());

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
      return Err(Failure.unknown(error.toString()));
    }
  }
}
