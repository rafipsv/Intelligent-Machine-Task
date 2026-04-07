import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/http_client.dart';
import '../models/current_weather_model.dart';
import '../models/forecast_model.dart';

/// Remote data source for weather data from OpenWeatherMap API
class WeatherRemoteDataSource {
  final HttpClient httpClient;

  WeatherRemoteDataSource({required this.httpClient});

  /// Fetches current weather data from API
  Future<CurrentWeatherModel> getCurrentWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      final url = ApiConstants.currentWeatherUrl(lat: lat, lon: lon);
      final response = await httpClient.get(url);

      return CurrentWeatherModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException(
        message: 'Failed to fetch current weather data',
      );
    }
  }

  /// Fetches 5-day forecast data from API
  Future<List<ForecastItemModel>> getForecast({
    required double lat,
    required double lon,
  }) async {
    try {
      final url = ApiConstants.forecastUrl(lat: lat, lon: lon);
      final response = await httpClient.get(url);

      final List<dynamic> list = response['list'] as List<dynamic>;

      return list
          .map(
            (item) => ForecastItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException(message: 'Failed to fetch forecast data');
    }
  }
}
