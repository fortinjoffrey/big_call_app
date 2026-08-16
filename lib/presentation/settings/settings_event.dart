import 'package:big_call_app/domain/entities/app_settings.dart';

sealed class SettingsEvent {
  const SettingsEvent();
}

final class ThemeSelected extends SettingsEvent {
  const ThemeSelected(this.palette);
  final AppPalette palette;
}

final class TextSizeSelected extends SettingsEvent {
  const TextSizeSelected(this.textSize);
  final TextSize textSize;
}
