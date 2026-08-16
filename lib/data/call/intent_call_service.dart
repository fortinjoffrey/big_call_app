import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:big_call_app/core/failure.dart';
import 'package:big_call_app/core/result.dart';
import 'package:big_call_app/domain/ports/call_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

/// Deux chemins, un seul port.
/// Android : ACTION_CALL compose directement — c'est ce qui permet l'appel
/// en un seul appui. iOS : aucune API n'autorise cela, `tel:` ouvre le
/// composeur et le système affiche sa propre confirmation.
class IntentCallService implements CallService {
  const IntentCallService();

  @override
  Future<Result<void>> call(String number) async {
    final sanitized = number.replaceAll(RegExp(r'[\s\-\.\(\)]'), '');
    if (sanitized.isEmpty) return const Err(Failure.unknown('Numéro vide'));

    try {
      if (Platform.isAndroid) {
        final status = await Permission.phone.request();
        if (!status.isGranted) return const Err(Failure.permissionDenied());

        final intent = AndroidIntent(
          action: 'android.intent.action.CALL',
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
