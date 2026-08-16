import 'package:big_call_app/app.dart';
import 'package:big_call_app/domain/ports/settings_repository.dart';
import 'package:big_call_app/injection.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  // Démarrage séquentiel : on ATTEND la lecture des préférences avant de
  // peindre. Sans cela, l'app affiche le thème par défaut une fraction de
  // seconde avant de basculer — un flash pénible avec une DMLA.
  final settings = await getIt<SettingsRepository>().load();

  runApp(BigCallApp(initialSettings: settings));
}
