import '../../domain/entities/alert_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// Use case for saving user's alert settings
class SaveSettings {
  final SettingsRepository repository;

  SaveSettings({required this.repository});

  /// Executes the use case with given settings
  Future<void> call({required AlertSettingsEntity settings}) async {
    await repository.saveSettings(settings);
  }
}
