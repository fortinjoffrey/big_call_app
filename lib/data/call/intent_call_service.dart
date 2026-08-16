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

String androidActionFor(String sanitizedNumber) =>
    kEmergencyNumbers.contains(sanitizedNumber) ? _actionDial : _actionCall;

class IntentCallService implements CallService {
  const IntentCallService();

  @override
  Future<Result<void>> call(String number) async {
    final sanitized = number.replaceAll(RegExp(r'[\s\-\.\(\)]'), '');
    if (sanitized.isEmpty) return const Err(Failure.unknown('Numéro vide'));

    try {
      if (Platform.isAndroid) {
        final action = androidActionFor(sanitized);

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
