import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/domain/ports/settings_repository.dart';
import 'package:big_call_app/presentation/settings/settings_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, AppSettings> {
  SettingsBloc(this._repository, AppSettings initial) : super(initial) {
    on<ThemeSelected>((event, emit) async {
      final next = state.copyWith(palette: event.palette);
      emit(next);
      await _repository.save(next);
    });

    on<TextSizeSelected>((event, emit) async {
      final next = state.copyWith(textSize: event.textSize);
      emit(next);
      await _repository.save(next);
    });

    on<LayoutSelected>((event, emit) async {
      final next = state.copyWith(layout: event.layout);
      emit(next);
      await _repository.save(next);
    });

    on<EmergencyStyleSelected>((event, emit) async {
      final next = state.copyWith(emergencyStyle: event.emergencyStyle);
      emit(next);
      await _repository.save(next);
    });

    on<UppercaseNamesSelected>((event, emit) async {
      final next = state.copyWith(uppercaseNames: event.uppercaseNames);
      emit(next);
      await _repository.save(next);
    });

    on<ScrollLettersSelected>((event, emit) async {
      final next = state.copyWith(
        speakScrollLetters: event.speakScrollLetters,
      );
      emit(next);
      await _repository.save(next);
    });
  }

  final SettingsRepository _repository;
}
