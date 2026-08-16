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

  /// Un seul numéro : la carte affiche le nom et le bouton sur la même ligne,
  /// sans libellé — « Mobile » n'a pas de sens s'il n'y a pas d'alternative.
  bool get hasSingleNumber => numbers.length == 1;
}
