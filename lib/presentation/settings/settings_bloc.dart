import 'package:big_call_app/domain/entities/app_settings.dart';
import 'package:big_call_app/domain/ports/settings_repository.dart';
import 'package:big_call_app/presentation/settings/settings_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// L'état EST les réglages : il n'y a ni chargement ni erreur à représenter,
/// puisque main() a déjà lu les préférences avant runApp.
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
  }

  final SettingsRepository _repository;
}
