import 'package:big_call_app/domain/spoken_time.dart';
import 'package:flutter_test/flutter_test.dart';

String at(int hour, int minute) =>
    spokenTime(DateTime(2026, 1, 1, hour, minute));

void main() {
  test('lit les heures et les minutes en toutes lettres', () {
    expect(at(18, 30), 'Il est dix-huit heures trente');
    expect(at(9, 5), 'Il est neuf heures cinq');
    expect(at(23, 59), 'Il est vingt-trois heures cinquante-neuf');
    expect(at(14, 17), 'Il est quatorze heures dix-sept');
  });

  test('ne dit pas les minutes a l heure pile', () {
    expect(at(18, 0), 'Il est dix-huit heures');
  });

  test('accorde au feminin', () {
    expect(at(1, 1), 'Il est une heure une');
    expect(at(21, 21), 'Il est vingt et une heures vingt et une');
    expect(at(8, 41), 'Il est huit heures quarante et une');
  });

  test('dit midi et minuit', () {
    expect(at(12, 0), 'Il est midi');
    expect(at(12, 30), 'Il est midi trente');
    expect(at(0, 0), 'Il est minuit');
    expect(at(0, 5), 'Il est minuit cinq');
  });
}
