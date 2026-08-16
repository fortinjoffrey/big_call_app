import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_number.freezed.dart';

/// Numéros d'urgence français reconnus. Le 112 (urgence européenne) n'y est
/// volontairement pas : il suffit de l'ajouter ici pour qu'il le devienne.
const kEmergencyNumbers = {'15', '17', '18'};

@freezed
abstract class ContactNumber with _$ContactNumber {
  const factory ContactNumber({
    required String number,

    /// Libellé déjà traduit en français : « Mobile », « Fixe », « Bureau »…
    required String label,
  }) = _ContactNumber;

  const ContactNumber._();

  /// Vrai si ce numéro est un numéro d'urgence. La comparaison se fait sur le
  /// numéro débarrassé de ses séparateurs, comme le fait le service d'appel :
  /// « 1 5 » et « 15 » désignent le même service.
  bool get isEmergency =>
      kEmergencyNumbers.contains(number.replaceAll(RegExp(r'[\s\-\.\(\)]'), ''));
}
