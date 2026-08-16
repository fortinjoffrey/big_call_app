import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:big_call_app/core/failure.dart';
import 'package:big_call_app/core/result.dart';
import 'package:big_call_app/domain/entities/contact_number.dart';
import 'package:big_call_app/domain/ports/call_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

const _actionCall = 'android.intent.action.CALL';
const _actionDial = 'android.intent.action.DIAL';

/// L'action Android à envoyer pour composer [sanitizedNumber] (déjà
/// débarrassé de ses séparateurs).
///
/// Extraite en fonction pure : c'est le seul fragment de ce service qu'on
/// peut exercer sans canal de plateforme — `AndroidIntent`, `Permission` et
/// `url_launcher` parlent tous à une plateforme réelle et ne se prêtent pas
/// à un test unitaire ici.
String androidActionFor(String sanitizedNumber) =>
    kEmergencyNumbers.contains(sanitizedNumber) ? _actionDial : _actionCall;

/// Deux chemins, un seul port.
/// Android : pour un numéro ordinaire, ACTION_CALL compose directement —
/// c'est ce qui permet l'appel en un seul appui. Pour un numéro d'urgence,
/// ACTION_DIAL ouvre le composeur système pré-rempli (voir [androidActionFor]
/// pour la raison). iOS : aucune API n'autorise l'appel direct dans les deux
/// cas, `tel:` ouvre le composeur et le système affiche sa propre
/// confirmation.
class IntentCallService implements CallService {
  const IntentCallService();

  @override
  Future<Result<void>> call(String number) async {
    final sanitized = number.replaceAll(RegExp(r'[\s\-\.\(\)]'), '');
    if (sanitized.isEmpty) return const Err(Failure.unknown('Numéro vide'));

    try {
      if (Platform.isAndroid) {
        // Android interdit à une application de composer un numéro d'urgence :
        // `ACTION_CALL` est explicitement inutilisable pour ces numéros et la
        // documentation renvoie vers `ACTION_DIAL`, qui ouvre le composeur
        // pré-rempli. La règle existe pour qu'un bug ou une page malveillante
        // ne puisse pas saturer les secours. Il restera donc toujours un appui
        // de plus sur le bouton vert du composeur pour ces numéros-là — ce
        // n'est pas contournable, ni par nous ni par personne.
        final action = androidActionFor(sanitized);

        // ACTION_DIAL n'a besoin d'aucune permission : il ne fait qu'ouvrir le
        // composeur système, qui compose lui-même sous sa propre permission.
        if (action == _actionCall) {
          final status = await Permission.phone.request();
          if (!status.isGranted) return const Err(Failure.permissionDenied());
        }

        final intent = AndroidIntent(
          action: action,
          data: Uri(scheme: 'tel', path: sanitized).toString(),
        );
        await intent.launch();
        return const Ok(null);
      }

      final uri = Uri(scheme: 'tel', path: sanitized);
      final launched = await launchUrl(uri);
      return launched ? const Ok(null) : const Err(Failure.unavailable());
    } on Object catch (error) {
      return Err(Failure.unknown(error.toString()));
    }
  }
}
