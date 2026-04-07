import '../entities/current_weather.dart';
import '../entities/forecast.dart';

/// Abstract repository for weather operations
abstract class WeatherRepository {
  /// Gets current weather for given coordinates
  Future<CurrentWeatherEntity> getCurrentWeather(double lat, double lon);

  /// Gets 5-day forecast for given coordinates
  Future<List<ForecastDayEntity>> getForecast(double lat, double lon);
}
