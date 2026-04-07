import 'package:equatable/equatable.dart';
import '../../domain/entities/alert_settings.dart';

/// Base event for Settings feature
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load user's settings
class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

/// Event to update user's settings
class UpdateSettingsEvent extends SettingsEvent {
  final AlertSettingsEntity settings;

  const UpdateSettingsEvent({required this.settings});

  @override
  List<Object?> get props => [settings];
}

/// Event to reset settings to defaults
class ResetSettingsEvent extends SettingsEvent {
  const ResetSettingsEvent();
}
