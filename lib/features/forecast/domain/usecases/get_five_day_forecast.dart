import '../../../weather/domain/entities/forecast.dart';
import '../../../weather/domain/repositories/weather_repository.dart';

/// Use case for getting 5-day forecast (reuses weather repository)
class GetFiveDayForecast {
  final WeatherRepository repository;

  GetFiveDayForecast({required this.repository});

  /// Executes the use case and returns 5-day forecast
  Future<List<ForecastDayEntity>> call({
    required double lat,
    required double lon,
  }) async {
    return await repository.getForecast(lat, lon);
  }
}
