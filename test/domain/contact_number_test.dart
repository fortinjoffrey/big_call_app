import 'package:big_call_app/domain/entities/contact_number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('un numero d urgence brut est reconnu', () {
    expect(const ContactNumber(number: '15', label: 'Fixe').isEmergency, isTrue);
    expect(const ContactNumber(number: '17', label: 'Fixe').isEmergency, isTrue);
    expect(const ContactNumber(number: '18', label: 'Fixe').isEmergency, isTrue);
  });

  test('un numero d urgence ecrit avec des separateurs est reconnu', () {
    expect(const ContactNumber(number: '1 5', label: 'Fixe').isEmergency, isTrue);
    expect(const ContactNumber(number: '1-5', label: 'Fixe').isEmergency, isTrue);
  });

  test('un numero ordinaire n est pas reconnu comme numero d urgence', () {
    expect(
      const ContactNumber(number: '0611223344', label: 'Mobile').isEmergency,
      isFalse,
    );
  });

  test('le 112 n est volontairement pas reconnu', () {
    expect(const ContactNumber(number: '112', label: 'Fixe').isEmergency, isFalse);
  });
}
