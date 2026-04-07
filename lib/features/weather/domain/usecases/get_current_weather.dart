import '../../domain/entities/current_weather.dart';
import '../../domain/repositories/weather_repository.dart';

/// Use case for getting current weather
class GetCurrentWeather {
  final WeatherRepository repository;

  GetCurrentWeather({required this.repository});

  /// Executes the use case and returns current weather
  Future<CurrentWeatherEntity> call({
    required double lat,
    required double lon,
  }) async {
    return await repository.getCurrentWeather(lat, lon);
  }
}
