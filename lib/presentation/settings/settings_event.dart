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

final class LayoutSelected extends SettingsEvent {
  const LayoutSelected(this.layout);
  final ContactLayout layout;

  @override
  bool operator ==(Object other) =>
      other is LayoutSelected && other.layout == layout;

  @override
  int get hashCode => layout.hashCode;
}

final class EmergencyStyleSelected extends SettingsEvent {
  const EmergencyStyleSelected(this.emergencyStyle);
  final EmergencyStyle emergencyStyle;

  @override
  bool operator ==(Object other) =>
      other is EmergencyStyleSelected && other.emergencyStyle == emergencyStyle;

  @override
  int get hashCode => emergencyStyle.hashCode;
}
