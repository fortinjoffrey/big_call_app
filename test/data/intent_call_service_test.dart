import 'package:big_call_app/data/call/intent_call_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // `IntentCallService.call` parle à trois canaux de plateforme réels
  // (AndroidIntent, Permission, url_launcher) et ne peut pas être exercé en
  // test unitaire sans widget/intégration. Seule la décision « quelle action
  // Android pour ce numéro ? » est pure : c'est elle qu'on teste ici.
  group('androidActionFor', () {
    test('un numero d urgence part sur ACTION_DIAL, le composeur systeme', () {
      for (final number in ['15', '17', '18', '112']) {
        expect(androidActionFor(number), 'android.intent.action.DIAL',
            reason: 'numero $number');
      }
    });

    test('un numero ordinaire part sur ACTION_CALL, l appel direct', () {
      expect(androidActionFor('0611223344'), 'android.intent.action.CALL');
    });
  });
}
