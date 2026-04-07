import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/alert_settings.dart';

/// Local data source for settings using SharedPreferences
class SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSource({required this.sharedPreferences});

  static const String tempThresholdKey = 'temp_threshold';
  static const String alertOnRainKey = 'alert_on_rain';
  static const String rainThresholdKey = 'rain_threshold';
  static const String alertOnHighUVKey = 'alert_on_high_uv';
  static const String uvThresholdKey = 'uv_threshold';

  /// Gets saved settings from local storage
  Future<AlertSettingsEntity> getSettings() async {
    try {
      return AlertSettingsEntity(
        tempThreshold: sharedPreferences.getDouble(tempThresholdKey) ?? 30.0,
        alertOnRain: sharedPreferences.getBool(alertOnRainKey) ?? true,
        rainThreshold: sharedPreferences.getDouble(rainThresholdKey) ?? 0.1,
        alertOnHighUV: sharedPreferences.getBool(alertOnHighUVKey) ?? true,
        uvThreshold: sharedPreferences.getDouble(uvThresholdKey) ?? 7.0,
      );
    } catch (e) {
      throw const CacheException(message: 'Failed to read settings from cache');
    }
  }

  /// Saves settings to local storage
  Future<void> saveSettings(AlertSettingsEntity settings) async {
    try {
      await sharedPreferences.setDouble(
        tempThresholdKey,
        settings.tempThreshold,
      );
      await sharedPreferences.setBool(alertOnRainKey, settings.alertOnRain);
      await sharedPreferences.setDouble(
        rainThresholdKey,
        settings.rainThreshold,
      );
      await sharedPreferences.setBool(alertOnHighUVKey, settings.alertOnHighUV);
      await sharedPreferences.setDouble(uvThresholdKey, settings.uvThreshold);
    } catch (e) {
      throw const CacheException(message: 'Failed to save settings to cache');
    }
  }

  /// Clears all saved settings
  Future<void> clearSettings() async {
    await sharedPreferences.remove(tempThresholdKey);
    await sharedPreferences.remove(alertOnRainKey);
    await sharedPreferences.remove(rainThresholdKey);
    await sharedPreferences.remove(alertOnHighUVKey);
    await sharedPreferences.remove(uvThresholdKey);
  }
}
