import 'package:big_call_app/domain/entities/contact_number.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_contact.freezed.dart';

@freezed
abstract class PhoneContact with _$PhoneContact {
  const factory PhoneContact({
    required String id,
    required String displayName,
    required List<ContactNumber> numbers,
    required bool isFavorite,
  }) = _PhoneContact;

  const PhoneContact._();

  bool get hasSingleNumber => numbers.length == 1;

  bool get hasEmergencyNumber => numbers.any((n) => n.isEmergency);
}
