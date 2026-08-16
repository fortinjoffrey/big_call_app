import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_number.freezed.dart';

const kEmergencyNumbers = {'15', '17', '18', '112'};

@freezed
abstract class ContactNumber with _$ContactNumber {
  const factory ContactNumber({required String number, required String label}) =
      _ContactNumber;

  const ContactNumber._();

  bool get isEmergency => kEmergencyNumbers.contains(
    number.replaceAll(RegExp(r'[\s\-\.\(\)]'), ''),
  );
}
