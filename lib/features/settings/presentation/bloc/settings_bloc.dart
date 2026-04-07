import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/alert_settings.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/save_settings.dart';
import 'settings_event.dart';
import 'settings_state.dart';

/// BLoC for managing settings state
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final SaveSettings saveSettings;

  SettingsBloc({required this.getSettings, required this.saveSettings})
    : super(const SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
    on<ResetSettingsEvent>(_onResetSettings);
  }

  /// Handles LoadSettingsEvent
  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    try {
      final settings = await getSettings();
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  /// Handles UpdateSettingsEvent
  Future<void> _onUpdateSettings(
    UpdateSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    try {
      await saveSettings(settings: event.settings);
      emit(SettingsLoaded(event.settings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  /// Handles ResetSettingsEvent
  Future<void> _onResetSettings(
    ResetSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    try {
      // Emit default settings
      const defaultSettings = AlertSettingsEntity();
      emit(SettingsLoaded(defaultSettings));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
