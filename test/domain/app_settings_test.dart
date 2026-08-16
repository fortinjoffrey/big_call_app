import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('les multiplicateurs des paliers sont M=1,0 L=1,25 XL=1,5', () {
    expect(TextSize.m.multiplier, 1.0);
    expect(TextSize.l.multiplier, 1.25);
    expect(TextSize.xl.multiplier, 1.5);
  });

  test('les libelles affiches sont Petit, Moyen, Grand', () {
    expect(TextSize.m.label, 'Petit');
    expect(TextSize.l.label, 'Moyen');
    expect(TextSize.xl.label, 'Grand');
  });

  test('les reglages par defaut sont theme clair et palier M', () {
    expect(kDefaultSettings.palette, AppPalette.light);
    expect(kDefaultSettings.textSize, TextSize.m);
    expect(kDefaultSettings.layout, ContactLayout.compact);
    expect(kDefaultSettings.emergencyStyle, EmergencyStyle.section);
    expect(kDefaultSettings.uppercaseNames, isFalse);
  });

  test('les libelles de disposition decrivent la position du bouton', () {
    expect(ContactLayout.compact.label, 'Bouton à droite');
    expect(ContactLayout.wide.label, 'Bouton en dessous');
  });

  test('les libelles de style d urgence decrivent chaque presentation', () {
    expect(EmergencyStyle.section.label, 'Dans une section à part');
    expect(EmergencyStyle.highlight.label, 'Bouton rouge, à leur place');
    expect(EmergencyStyle.none.label, 'Comme les autres contacts');
  });
}
