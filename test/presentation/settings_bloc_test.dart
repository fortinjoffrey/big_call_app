import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/domain/ports/settings_repository.dart';
import 'package:big_call_app/presentation/settings/settings_bloc.dart';
import 'package:big_call_app/presentation/settings/settings_event.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late SettingsRepository repository;

  setUpAll(() => registerFallbackValue(kDefaultSettings));

  setUp(() {
    repository = _MockSettingsRepository();
    when(() => repository.save(any())).thenAnswer((_) async {});
  });

  blocTest<SettingsBloc, AppSettings>(
    'change la palette et la persiste',
    build: () => SettingsBloc(repository, kDefaultSettings),
    act: (bloc) => bloc.add(const ThemeSelected(AppPalette.yellow)),
    expect: () => [
      kDefaultSettings.copyWith(palette: AppPalette.yellow),
    ],
    verify: (_) {
      verify(() => repository.save(
            kDefaultSettings.copyWith(palette: AppPalette.yellow),
          )).called(1);
    },
  );

  blocTest<SettingsBloc, AppSettings>(
    'change le palier et le persiste',
    build: () => SettingsBloc(repository, kDefaultSettings),
    act: (bloc) => bloc.add(const TextSizeSelected(TextSize.xl)),
    expect: () => [
      kDefaultSettings.copyWith(textSize: TextSize.xl),
    ],
    verify: (_) {
      verify(() => repository.save(
            kDefaultSettings.copyWith(textSize: TextSize.xl),
          )).called(1);
    },
  );

  blocTest<SettingsBloc, AppSettings>(
    'change la disposition et la persiste',
    build: () => SettingsBloc(repository, kDefaultSettings),
    act: (bloc) => bloc.add(const LayoutSelected(ContactLayout.wide)),
    expect: () => [
      kDefaultSettings.copyWith(layout: ContactLayout.wide),
    ],
    verify: (_) {
      verify(() => repository.save(
            kDefaultSettings.copyWith(layout: ContactLayout.wide),
          )).called(1);
    },
  );

  blocTest<SettingsBloc, AppSettings>(
    'change le style d urgence et le persiste',
    build: () => SettingsBloc(repository, kDefaultSettings),
    act: (bloc) =>
        bloc.add(const EmergencyStyleSelected(EmergencyStyle.highlight)),
    expect: () => [
      kDefaultSettings.copyWith(emergencyStyle: EmergencyStyle.highlight),
    ],
    verify: (_) {
      verify(() => repository.save(
            kDefaultSettings.copyWith(emergencyStyle: EmergencyStyle.highlight),
          )).called(1);
    },
  );

  blocTest<SettingsBloc, AppSettings>(
    'change la casse des noms et la persiste',
    build: () => SettingsBloc(repository, kDefaultSettings),
    act: (bloc) => bloc.add(const UppercaseNamesSelected(true)),
    expect: () => [
      kDefaultSettings.copyWith(uppercaseNames: true),
    ],
    verify: (_) {
      verify(() => repository.save(
            kDefaultSettings.copyWith(uppercaseNames: true),
          )).called(1);
    },
  );

  blocTest<SettingsBloc, AppSettings>(
    'deux changements successifs s accumulent',
    build: () => SettingsBloc(repository, kDefaultSettings),
    act: (bloc) => bloc
      ..add(const ThemeSelected(AppPalette.yellow))
      ..add(const TextSizeSelected(TextSize.xl)),
    expect: () => [
      kDefaultSettings.copyWith(palette: AppPalette.yellow),
      // Le second changement part de l'état courant, pas des défauts : sans
      // cela, choisir un palier après un thème effacerait le thème.
      kDefaultSettings.copyWith(palette: AppPalette.yellow, textSize: TextSize.xl),
    ],
  );

  blocTest<SettingsBloc, AppSettings>(
    'demarre sur les reglages fournis par main()',
    build: () => SettingsBloc(
      repository,
      kDefaultSettings.copyWith(palette: AppPalette.dark, textSize: TextSize.l),
    ),
    verify: (bloc) {
      expect(bloc.state.palette, AppPalette.dark);
      expect(bloc.state.textSize, TextSize.l);
    },
  );
}
