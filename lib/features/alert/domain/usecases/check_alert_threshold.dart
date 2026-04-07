import '../../../settings/domain/entities/alert_settings.dart';
import '../../../weather/domain/entities/current_weather.dart';
import '../entities/alert_result.dart';

/// Use case for checking if weather conditions exceed alert thresholds
class CheckAlertThreshold {
  /// Executes the alert threshold check
  /// Returns AlertResult with triggered alert info or no alert
  AlertResult call({
    required CurrentWeatherEntity weather,
    required AlertSettingsEntity settings,
  }) {
    // Check temperature threshold
    if (weather.temperature > settings.tempThreshold) {
      return AlertResult.temperatureAlert(
        weather.temperature,
        settings.tempThreshold,
      );
    }

    // Check rain threshold (only if rain alert is enabled)
    if (settings.alertOnRain && weather.rain1h != null) {
      if (weather.rain1h! > settings.rainThreshold) {
        return AlertResult.rainAlert(weather.rain1h!, settings.rainThreshold);
      }
    }

    // No alerts triggered
    return AlertResult.noAlert();
  }
}
