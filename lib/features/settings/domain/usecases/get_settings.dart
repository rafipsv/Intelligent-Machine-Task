import '../../domain/entities/alert_settings.dart';
import '../../domain/repositories/settings_repository.dart';

/// Use case for getting user's alert settings
class GetSettings {
  final SettingsRepository repository;

  GetSettings({required this.repository});

  /// Executes the use case and returns settings
  Future<AlertSettingsEntity> call() async {
    return await repository.getSettings();
  }
}
