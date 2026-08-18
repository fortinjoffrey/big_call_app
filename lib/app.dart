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
    return BlocProvider(
      create: (_) => SettingsBloc(getIt<SettingsRepository>(), initialSettings),
      child: BlocBuilder<SettingsBloc, AppSettings>(
        builder: (context, settings) {
          return MaterialApp(
            title: 'Allô',
            debugShowCheckedModeBanner: false,
            theme: buildTheme(settings.palette, settings.textSize),
            builder: (context, child) => MediaQuery.withClampedTextScaling(
              maxScaleFactor: kMaxTextScaleFactor,

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
                emergencyStyle: settings.emergencyStyle,
                uppercaseNames: settings.uppercaseNames,
                speakScrollLetters: settings.speakScrollLetters,
              ),
            ),
          );
        },
      ),
    );
  }
}
