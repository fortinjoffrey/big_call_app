import 'package:big_call_app/domain/entities/app_settings.dart';

sealed class SettingsEvent {
  const SettingsEvent();
}

final class ThemeSelected extends SettingsEvent {
  const ThemeSelected(this.palette);
  final AppPalette palette;

  @override
  bool operator ==(Object other) =>
      other is ThemeSelected && other.palette == palette;

  @override
  int get hashCode => palette.hashCode;
}

final class TextSizeSelected extends SettingsEvent {
  const TextSizeSelected(this.textSize);
  final TextSize textSize;

  @override
  bool operator ==(Object other) =>
      other is TextSizeSelected && other.textSize == textSize;

  @override
  int get hashCode => textSize.hashCode;
}
