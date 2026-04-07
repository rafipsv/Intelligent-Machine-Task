/// Application-wide string constants
class AppStrings {
  AppStrings._();

  // App info
  static const String appName = 'SkySentinel';
  static const String appVersion = '1.0.0';

  // Navigation
  static const String navHome = 'Home';
  static const String navForecast = 'Forecast';
  static const String navSettings = 'Settings';

  // Weather Dashboard
  static const String currentWeather = 'Current Weather';
  static const String feelsLike = 'Feels Like';
  static const String humidity = 'Humidity';
  static const String windSpeed = 'Wind Speed';
  static const String uvIndex = 'UV Index';
  static const String updatedAgo = 'Updated';
  static const String hourlyOutlook = 'Hourly Outlook';
  static const String justNow = 'Just now';
  static const String minutesAgo = 'm ago';
  static const String hoursAgo = 'h ago';

  // Forecast
  static const String fiveDayForecast = '5-Day Forecast';
  static const String high = 'H';
  static const String low = 'L';

  // Settings
  static const String alertSettings = 'Alert Settings';
  static const String temperatureThreshold = 'Temperature Threshold';
  static const String rainAlert = 'Rain Alert';
  static const String rainThreshold = 'Rain Threshold';
  static const String uvAlert = 'High UV Alert';
  static const String uvThreshold = 'UV Threshold';
  static const String settingsSaved = 'Settings saved successfully';

  // Alerts
  static const String weatherAlert = 'Weather Alert';
  static const String highTemperatureAlert = 'High Temperature Alert';
  static const String rainAlertMessage = 'Rain detected in your area';
  static const String viewFullDashboard = 'View Full Dashboard';
  static const String dismissAlert = 'Dismiss Alert';
  static const String alertTriggered = 'Alert Triggered';
  static const String triggeredBy = 'Triggered by';

  // Error messages
  static const String errorFetchingLocation = 'Unable to fetch location';
  static const String errorFetchingWeather = 'Unable to fetch weather data';
  static const String errorFetchingForecast = 'Unable to fetch forecast';
  static const String networkError =
      'Network error. Please check your connection.';
  static const String locationPermissionDenied = 'Location permission denied';
  static const String enableLocationServices =
      'Please enable location services';
  static const String retry = 'Retry';
  static const String noDataAvailable = 'No data available';
  static const String somethingWentWrong = 'Something went wrong';

  // Loading
  static const String loading = 'Loading...';
  static const String fetchingLocation = 'Fetching location...';
  static const String fetchingWeather = 'Fetching weather data...';

  // Units
  static const String celsius = '°C';
  static const String fahrenheit = '°F';
  static const String ms = 'm/s';
  static const String kmh = 'km/h';
  static const String mm = 'mm';
  static const String percent = '%';

  // Permission messages
  static const String locationPermissionRequired =
      'Location permission is required for weather updates';
  static const String notificationPermissionRequired =
      'Notification permission is required for alerts';
}
