import '../entities/alert_settings.dart';

/// Abstract repository for settings management
abstract class SettingsRepository {
  /// Gets user's alert settings
  Future<AlertSettingsEntity> getSettings();

  /// Saves user's alert settings
  Future<void> saveSettings(AlertSettingsEntity settings);

  /// Resets settings to defaults
  Future<void> resetSettings();
}
