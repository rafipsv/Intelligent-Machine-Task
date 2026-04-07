/// OpenWeatherMap API constants
class ApiConstants {
  ApiConstants._();

  /// Base URL for OpenWeatherMap API
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  static const String apiKey = 'YOUR_API_KEY_HERE';

  /// API Endpoints
  static const String weatherEndpoint = '/weather';
  static const String forecastEndpoint = '/forecast';

  /// Build full URL for current weather
  static String currentWeatherUrl(double lat, double lon) {
    return '$baseUrl$weatherEndpoint?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
  }

  /// Build full URL for 5-day forecast
  static String forecastUrl(double lat, double lon) {
    return '$baseUrl$forecastEndpoint?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
  }
}
