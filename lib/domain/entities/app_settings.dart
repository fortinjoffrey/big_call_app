import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

enum AppPalette { light, dark, yellow }

extension AppPaletteLabel on AppPalette {
  String get label => switch (this) {
        AppPalette.light => 'Clair',
        AppPalette.dark => 'Sombre',
        AppPalette.yellow => 'Jaune sur noir',
      };
}

enum TextSize { m, l, xl }

extension TextSizeScale on TextSize {
  double get multiplier => switch (this) {
        TextSize.m => 1.0,
        TextSize.l => 1.25,
        TextSize.xl => 1.5,
      };

  String get label => switch (this) {
        TextSize.m => 'M',
        TextSize.l => 'L',
        TextSize.xl => 'XL',
      };
}

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    required AppPalette palette,
    required TextSize textSize,
  }) = _AppSettings;
}

const kDefaultSettings = AppSettings(
  palette: AppPalette.light,
  textSize: TextSize.m,
);
