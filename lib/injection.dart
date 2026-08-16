import 'package:big_call_app/data/call/intent_call_service.dart';
import 'package:big_call_app/data/contacts/contact_mapper.dart';
import 'package:big_call_app/data/contacts/flutter_contacts_repository.dart';
import 'package:big_call_app/data/settings/prefs_settings_repository.dart';
import 'package:big_call_app/data/speech/tts_speech_service.dart';
import 'package:big_call_app/data/system/permission_handler_settings_service.dart';
import 'package:big_call_app/domain/ports/call_service.dart';
import 'package:big_call_app/domain/ports/contact_repository.dart';
import 'package:big_call_app/domain/ports/settings_repository.dart';
import 'package:big_call_app/domain/ports/speech_service.dart';
import 'package:big_call_app/domain/ports/system_settings_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  getIt
    ..registerSingleton<SettingsRepository>(PrefsSettingsRepository(prefs))
    ..registerSingleton<ContactRepository>(
      const FlutterContactsRepository(ContactMapper()),
    )
    ..registerSingleton<CallService>(const IntentCallService())
    ..registerSingleton<SpeechService>(TtsSpeechService(FlutterTts()))
    ..registerSingleton<SystemSettingsService>(
      const PermissionHandlerSettingsService(),
    );
}
