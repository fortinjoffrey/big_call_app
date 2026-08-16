import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_number.freezed.dart';

@freezed
abstract class ContactNumber with _$ContactNumber {
  const factory ContactNumber({
    required String number,

    /// Libellé déjà traduit en français : « Mobile », « Fixe », « Bureau »…
    required String label,
  }) = _ContactNumber;
}
