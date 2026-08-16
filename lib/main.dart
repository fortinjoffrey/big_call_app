import 'dart:async';

import 'package:big_call_app/app.dart';
import 'package:big_call_app/core/failure_screen.dart';
import 'package:big_call_app/domain/ports/settings_repository.dart';
import 'package:big_call_app/injection.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runZonedGuarded(_start, (error, stack) {
    debugPrint('Erreur non rattrapée : $error\n$stack');
  });
}

Future<void> _start() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (details) {
    debugPrint('Erreur de rendu : ${details.exception}');
    return const FailureScreen(
      "Un problème est survenu.\n\nFermez l'application, puis rouvrez-la.",
    );
  };

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('Erreur Flutter : ${details.exception}');
  };

  try {
    await configureDependencies();

    final settings = await getIt<SettingsRepository>().load();

    runApp(BigCallApp(initialSettings: settings));
  } on Object catch (error, stack) {
    debugPrint('Échec du démarrage : $error\n$stack');
    runApp(const FailureApp());
  }
}
