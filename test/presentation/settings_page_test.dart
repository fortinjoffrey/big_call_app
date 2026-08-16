import 'package:big_call_app/core/theme/app_theme.dart';
import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/presentation/settings/settings_bloc.dart';
import 'package:big_call_app/presentation/settings/settings_event.dart';
import 'package:big_call_app/presentation/settings/settings_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSettingsBloc extends MockBloc<SettingsEvent, AppSettings>
    implements SettingsBloc {}

void main() {
  late _MockSettingsBloc bloc;

  setUp(() {
    bloc = _MockSettingsBloc();
    when(() => bloc.state).thenReturn(kDefaultSettings);
  });

  Widget host() => MaterialApp(
        theme: buildTheme(AppPalette.light, TextSize.m),
        home: BlocProvider<SettingsBloc>.value(
          value: bloc,
          child: const SettingsPage(),
        ),
      );

  testWidgets('propose les trois themes et les trois paliers', (tester) async {
    await tester.pumpWidget(host());

    expect(find.text('Clair'), findsOneWidget);
    expect(find.text('Sombre'), findsOneWidget);
    expect(find.text('Jaune sur noir'), findsOneWidget);
    expect(find.text('M'), findsOneWidget);
    expect(find.text('L'), findsOneWidget);
    expect(find.text('XL'), findsOneWidget);
  });

  testWidgets('choisir un theme emet ThemeSelected', (tester) async {
    await tester.pumpWidget(host());

    await tester.tap(find.text('Sombre'));
    verify(() => bloc.add(const ThemeSelected(AppPalette.dark))).called(1);
  });

  testWidgets('choisir un palier emet TextSizeSelected', (tester) async {
    await tester.pumpWidget(host());

    await tester.tap(find.text('XL'));
    verify(() => bloc.add(const TextSizeSelected(TextSize.xl))).called(1);
  });

  testWidgets('affiche un apercu en direct', (tester) async {
    await tester.pumpWidget(host());

    expect(find.text('Marie'), findsOneWidget);
    expect(find.text('Mobile'), findsOneWidget);
  });
}
