import '../../domain/entities/current_weather.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_datasource.dart';
import '../datasources/weather_remote_datasource.dart';
import '../models/current_weather_model.dart';
import '../models/forecast_model.dart';

/// Implementation of WeatherRepository
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<CurrentWeatherEntity> getCurrentWeather(double lat, double lon) async {
    try {
      // Try to fetch from remote first
      final CurrentWeatherModel remoteWeather = await remoteDataSource
          .getCurrentWeather(lat: lat, lon: lon);

      // Cache the successful response
      await localDataSource.cacheCurrentWeather(remoteWeather);

      // Convert model to entity and return
      return _modelToEntity(remoteWeather);
    } catch (e) {
      // If remote fails, try to get from cache
      try {
        final CurrentWeatherModel? cachedWeather = await localDataSource
            .getCachedCurrentWeather();

        if (cachedWeather != null) {
          return _modelToEntity(cachedWeather);
        }

        // No cache available
        throw Exception(
          'No cached data available. Please check your connection.',
        );
      } catch (cacheError) {
        throw Exception('Failed to fetch weather data: ${e.toString()}');
      }
    }
  }

  @override
  Future<List<ForecastDayEntity>> getForecast(double lat, double lon) async {
    try {
      // Try to fetch from remote first
      final List<ForecastItemModel> remoteForecast = await remoteDataSource
          .getForecast(lat: lat, lon: lon);

      // Cache the successful response
      await localDataSource.cacheForecast(remoteForecast);

      // Convert and aggregate to daily forecast
      return _aggregateForecastByDay(remoteForecast);
    } catch (e) {
      // If remote fails, try to get from cache
      try {
        final List<ForecastItemModel>? cachedForecast = await localDataSource
            .getCachedForecast();

        if (cachedForecast != null) {
          return _aggregateForecastByDay(cachedForecast);
        }

        // No cache available
        throw Exception(
          'No cached forecast available. Please check your connection.',
        );
      } catch (cacheError) {
        throw Exception('Failed to fetch forecast data: ${e.toString()}');
      }
    }
  }

  /// Converts CurrentWeatherModel to CurrentWeatherEntity
  CurrentWeatherEntity _modelToEntity(CurrentWeatherModel model) {
    return CurrentWeatherEntity(
      temperature: model.temperature,
      feelsLike: model.feelsLike,
      humidity: model.humidity,
      windSpeed: model.windSpeed,
      description: model.description,
      icon: model.icon,
      rain1h: model.rain1h,
      cityName: model.cityName,
      updatedAt: model.updatedAt,
    );
  }

  /// Aggregates 3-hour forecast items into daily forecasts
  List<ForecastDayEntity> _aggregateForecastByDay(
    List<ForecastItemModel> items,
  ) {
    // Group items by date
    final Map<String, List<ForecastItemModel>> groupedByDate = {};

    for (final item in items) {
      final dateKey =
          '${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}';

      if (!groupedByDate.containsKey(dateKey)) {
        groupedByDate[dateKey] = [];
      }

      groupedByDate[dateKey]!.add(item);
    }

    // Convert each group to ForecastDayEntity
    return groupedByDate.entries.map((entry) {
      final items = entry.value;
      final temperatures = items.map((i) => i.temperature).toList();

      return ForecastDayEntity(
        date: items.first.dateTime,
        minTemp: temperatures.reduce((a, b) => a < b ? a : b),
        maxTemp: temperatures.reduce((a, b) => a > b ? a : b),
        description: items.first.description,
        icon: items.first.icon,
        hourlyItems: items
            .map(
              (item) => ForecastEntity(
                dateTime: item.dateTime,
                temperature: item.temperature,
                feelsLike: item.feelsLike,
                humidity: item.humidity,
                windSpeed: item.windSpeed,
                description: item.description,
                icon: item.icon,
                rain3h: item.rain3h,
              ),
            )
            .toList(),
      );
    }).toList();
  }
}
