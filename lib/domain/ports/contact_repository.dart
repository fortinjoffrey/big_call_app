import 'package:big_call_app/core/result.dart';
import 'package:big_call_app/domain/entities/phone_contact.dart';

abstract interface class ContactRepository {
  bool get supportsFavorites;

  Future<Result<List<PhoneContact>>> loadContacts();
}
