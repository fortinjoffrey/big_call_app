import 'dart:async';

import 'package:big_call_app/app.dart';
import 'package:big_call_app/core/failure_screen.dart';
import 'package:big_call_app/domain/ports/settings_repository.dart';
import 'package:big_call_app/injection.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Zone protégée : une erreur asynchrone échappant à tout try/catch (un
  // Future oublié, un callback de plugin) est journalisée plutôt que perdue
  // dans le vide — sans jamais faire planter l'app à sa place.
  runZonedGuarded(_start, (error, stack) {
    debugPrint('Erreur non rattrapée : $error\n$stack');
  });
}

Future<void> _start() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Remplace l'écran d'erreur par défaut de Flutter — gris et illisible en
  // production — par un message qu'elle peut lire et suivre.
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

    // Démarrage séquentiel : on ATTEND la lecture des préférences avant de
    // peindre. Sans cela, l'app affiche le thème par défaut une fraction de
    // seconde avant de basculer — un flash pénible avec une DMLA.
    final settings = await getIt<SettingsRepository>().load();

    runApp(BigCallApp(initialSettings: settings));
  } on Object catch (error, stack) {
    // Sans ce filet, un échec ici n'appellerait jamais runApp : elle
    // obtiendrait un écran noir, sans application et sans explication.
    debugPrint('Échec du démarrage : $error\n$stack');
    runApp(const FailureApp());
  }
}
