import '../../domain/entities/forecast.dart';
import '../../domain/repositories/weather_repository.dart';

/// Use case for getting 5-day forecast
class GetForecast {
  final WeatherRepository repository;

  GetForecast({required this.repository});

  /// Executes the use case and returns forecast list
  Future<List<ForecastDayEntity>> call({
    required double lat,
    required double lon,
  }) async {
    return await repository.getForecast(lat, lon);
  }
}
