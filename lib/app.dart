import 'package:big_call_app/core/theme/app_theme.dart';
import 'package:big_call_app/core/theme/text_sizes.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/domain/ports/call_service.dart';
import 'package:big_call_app/domain/ports/contact_repository.dart';
import 'package:big_call_app/domain/ports/settings_repository.dart';
import 'package:big_call_app/domain/ports/speech_service.dart';
import 'package:big_call_app/domain/ports/system_settings_service.dart';
import 'package:big_call_app/injection.dart';
import 'package:big_call_app/presentation/contacts/contacts_bloc.dart';
import 'package:big_call_app/presentation/contacts/contacts_event.dart';
import 'package:big_call_app/presentation/contacts/contacts_page.dart';
import 'package:big_call_app/presentation/settings/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BigCallApp extends StatelessWidget {
  const BigCallApp({required this.initialSettings, super.key});

  final AppSettings initialSettings;

  @override
  Widget build(BuildContext context) {
    // SettingsBloc est AU-DESSUS de MaterialApp : un fournisseur placé dans
    // `home:` serait invisible aux routes poussées ensuite (Navigator les
    // insère comme sœurs de `home`, pas comme descendantes), et l'écran de
    // réglages planterait à l'ouverture. Ce placement fait aussi qu'un
    // changement de palette repeint tout l'arbre, ce qui rend l'aperçu gratuit.
    return BlocProvider(
      create: (_) => SettingsBloc(getIt<SettingsRepository>(), initialSettings),
      child: BlocBuilder<SettingsBloc, AppSettings>(
        builder: (context, settings) {
          return MaterialApp(
            title: 'Téléphone',
            debugShowCheckedModeBanner: false,
            theme: buildTheme(settings.palette, settings.textSize),
            builder: (context, child) => MediaQuery.withClampedTextScaling(
              maxScaleFactor: kMaxTextScaleFactor,
              // Compense le `height: 1.3` du thème : Flutter l'applique à
              // chaque ligne, seule ou non, ce qui grossirait chaque carte
              // d'environ 18 % (37 px contre 44 px, mesuré à taille 34).
              // En retirant l'espace au-dessus de la première ligne et sous
              // la dernière, un texte d'une seule ligne retrouve sa hauteur
              // compacte tandis qu'un nom qui se replie garde son interligne.
              child: DefaultTextStyle.merge(
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
                child: child!,
              ),
            ),
            home: BlocProvider(
              create: (_) => ContactsBloc(
                getIt<ContactRepository>(),
                getIt<CallService>(),
                getIt<SpeechService>(),
                getIt<SystemSettingsService>(),
              )..add(const ContactsRequested()),
              child: ContactsPage(
                palette: settings.palette,
                layout: settings.layout,
              ),
            ),
          );
        },
      ),
    );
  }
}
