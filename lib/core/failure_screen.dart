import 'package:flutter/material.dart';

/// Dernier filet avant un écran vide qu'elle ne pourrait ni comprendre ni
/// rapporter : affichée quand le démarrage échoue avant `runApp`, ou quand
/// `ErrorWidget.builder` remplace l'écran d'erreur gris de Flutter.
///
/// Doit fonctionner SANS thème, SANS localisation et SANS dépendance : elle
/// peut apparaître avant que quoi que ce soit d'autre ne soit initialisé.
/// D'où `Directionality` + couleurs en dur plutôt que `MaterialApp`, qui
/// tirerait précisément le thème qui a pu échouer.
class FailureScreen extends StatelessWidget {
  const FailureScreen(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                height: 1.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Application minimale montée quand le démarrage échoue avant `runApp`
/// (échec de `configureDependencies()` ou de la lecture des préférences).
/// Volontairement un `WidgetsApp`, pas un `MaterialApp` : Material dépend du
/// thème, exactement ce qui a pu échouer plus haut.
class FailureApp extends StatelessWidget {
  const FailureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => const FailureScreen(
        "Un problème est survenu au démarrage.\n\n"
        "Fermez l'application, puis rouvrez-la.",
      ),
    );
  }
}
