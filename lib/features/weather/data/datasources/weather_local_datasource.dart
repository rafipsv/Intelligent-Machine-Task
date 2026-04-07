import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/current_weather_model.dart';
import '../models/forecast_model.dart';

/// Local data source for caching weather data
class WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  WeatherLocalDataSource({required this.sharedPreferences});

  static const String cachedCurrentWeatherKey = 'cached_current_weather';
  static const String cachedForecastKey = 'cached_forecast';

  /// Caches current weather data
  Future<void> cacheCurrentWeather(CurrentWeatherModel weather) async {
    try {
      final String jsonString = json.encode(weather.toJson());
      await sharedPreferences.setString(cachedCurrentWeatherKey, jsonString);
    } catch (e) {
      throw const CacheException(
        message: 'Failed to cache current weather data',
      );
    }
  }

  /// Gets cached current weather data
  Future<CurrentWeatherModel?> getCachedCurrentWeather() async {
    try {
      final String? jsonString = sharedPreferences.getString(
        cachedCurrentWeatherKey,
      );

      if (jsonString == null) return null;

      final Map<String, dynamic> json =
          jsonDecode(jsonString) as Map<String, dynamic>;

      return CurrentWeatherModel.fromJson(json);
    } catch (e) {
      throw const CacheException(message: 'Failed to read cached weather data');
    }
  }

  /// Caches forecast data
  Future<void> cacheForecast(List<ForecastItemModel> forecast) async {
    try {
      final List<Map<String, dynamic>> jsonList = forecast
          .map((item) => item.toJson())
          .toList();

      final String jsonString = json.encode(jsonList);
      await sharedPreferences.setString(cachedForecastKey, jsonString);
    } catch (e) {
      throw const CacheException(message: 'Failed to cache forecast data');
    }
  }

  /// Gets cached forecast data
  Future<List<ForecastItemModel>?> getCachedForecast() async {
    try {
      final String? jsonString = sharedPreferences.getString(cachedForecastKey);

      if (jsonString == null) return null;

      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

      return jsonList
          .map(
            (item) => ForecastItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw const CacheException(
        message: 'Failed to read cached forecast data',
      );
    }
  }

  /// Clears all cached weather data
  Future<void> clearCache() async {
    await sharedPreferences.remove(cachedCurrentWeatherKey);
    await sharedPreferences.remove(cachedForecastKey);
  }
}
