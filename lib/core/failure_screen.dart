import 'package:flutter/material.dart';

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
