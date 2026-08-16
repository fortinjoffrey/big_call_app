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
      const AppSettings(palette: AppPalette.yellow, textSize: TextSize.m, layout: ContactLayout.compact),
    ],
    verify: (_) {
      verify(() => repository.save(
            const AppSettings(palette: AppPalette.yellow, textSize: TextSize.m, layout: ContactLayout.compact),
          )).called(1);
    },
  );

  blocTest<SettingsBloc, AppSettings>(
    'change le palier et le persiste',
    build: () => SettingsBloc(repository, kDefaultSettings),
    act: (bloc) => bloc.add(const TextSizeSelected(TextSize.xl)),
    expect: () => [
      const AppSettings(palette: AppPalette.light, textSize: TextSize.xl, layout: ContactLayout.compact),
    ],
    verify: (_) {
      verify(() => repository.save(
            const AppSettings(palette: AppPalette.light, textSize: TextSize.xl, layout: ContactLayout.compact),
          )).called(1);
    },
  );

  blocTest<SettingsBloc, AppSettings>(
    'change la disposition et la persiste',
    build: () => SettingsBloc(repository, kDefaultSettings),
    act: (bloc) => bloc.add(const LayoutSelected(ContactLayout.wide)),
    expect: () => [
      const AppSettings(
        palette: AppPalette.light,
        textSize: TextSize.m,
        layout: ContactLayout.wide,
      ),
    ],
    verify: (_) {
      verify(() => repository.save(
            const AppSettings(
              palette: AppPalette.light,
              textSize: TextSize.m,
              layout: ContactLayout.wide,
            ),
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
      const AppSettings(palette: AppPalette.yellow, textSize: TextSize.m, layout: ContactLayout.compact),
      // Le second changement part de l'état courant, pas des défauts : sans
      // cela, choisir un palier après un thème effacerait le thème.
      const AppSettings(palette: AppPalette.yellow, textSize: TextSize.xl, layout: ContactLayout.compact),
    ],
  );

  blocTest<SettingsBloc, AppSettings>(
    'demarre sur les reglages fournis par main()',
    build: () => SettingsBloc(
      repository,
      const AppSettings(palette: AppPalette.dark, textSize: TextSize.l, layout: ContactLayout.compact),
    ),
    verify: (bloc) {
      expect(bloc.state.palette, AppPalette.dark);
      expect(bloc.state.textSize, TextSize.l);
    },
  );
}
