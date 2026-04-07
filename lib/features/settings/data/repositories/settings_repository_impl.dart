import '../../domain/entities/alert_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

/// Implementation of SettingsRepository
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<AlertSettingsEntity> getSettings() async {
    return await localDataSource.getSettings();
  }

  @override
  Future<void> saveSettings(AlertSettingsEntity settings) async {
    await localDataSource.saveSettings(settings);
  }

  @override
  Future<void> resetSettings() async {
    await localDataSource.clearSettings();
  }
}
