import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Core
import '../network/http_client.dart';

// Location Feature
import '../../features/location/data/datasources/location_datasource.dart';
import '../../features/location/data/repositories/location_repository_impl.dart';
import '../../features/location/domain/repositories/location_repository.dart';
import '../../features/location/domain/usecases/get_current_location.dart';
import '../../features/location/presentation/bloc/location_bloc.dart';

// Weather Feature - Data
import '../../features/weather/data/datasources/weather_local_datasource.dart';
import '../../features/weather/data/datasources/weather_remote_datasource.dart';
import '../../features/weather/data/repositories/weather_repository_impl.dart';
import '../../features/weather/domain/repositories/weather_repository.dart';

// Weather Feature - Domain
import '../../features/weather/domain/usecases/get_current_weather.dart';
import '../../features/weather/domain/usecases/get_forecast.dart';

// Weather Feature - Presentation
import '../../features/weather/presentation/bloc/weather_bloc.dart';

// Forecast Feature - Domain
import '../../features/forecast/domain/usecases/get_five_day_forecast.dart';

// Forecast Feature - Presentation
import '../../features/forecast/presentation/bloc/forecast_bloc.dart';

// Settings Feature - Data
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';

// Settings Feature - Domain
import '../../features/settings/domain/usecases/get_settings.dart';
import '../../features/settings/domain/usecases/save_settings.dart';

// Settings Feature - Presentation
import '../../features/settings/presentation/bloc/settings_bloc.dart';

// Alert Feature - Domain
import '../../features/alert/domain/usecases/check_alert_threshold.dart';

final sl = GetIt.instance;

/// Initialize all dependencies
/// Order:
/// 1. External (SharedPreferences, http.Client)
/// 2. Data Sources
/// 3. Repositories
/// 4. Use Cases
/// 5. BLoCs (registerFactory)
Future<void> init() async {
  // ==========================================
  // 1. EXTERNAL DEPENDENCIES
  // ==========================================

  // SharedPreferences singleton
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // ==========================================
  // 2. CORE
  // ==========================================

  // HTTP Client Wrapper
  sl.registerLazySingleton<HttpClient>(
    () => HttpClient(client: sl<http.Client>()),
  );

  // ==========================================
  // 3. DATA SOURCES
  // ==========================================

  // Location
  sl.registerLazySingleton<LocationDataSource>(() => LocationDataSource());

  // Weather
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSource(httpClient: sl<HttpClient>()),
  );

  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSource(sharedPreferences: sl<SharedPreferences>()),
  );

  // Settings
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSource(sharedPreferences: sl<SharedPreferences>()),
  );

  // ==========================================
  // 4. REPOSITORIES
  // ==========================================

  // Location
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(dataSource: sl<LocationDataSource>()),
  );

  // Weather
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: sl<WeatherRemoteDataSource>(),
      localDataSource: sl<WeatherLocalDataSource>(),
    ),
  );

  // Settings
  sl.registerLazySingleton<SettingsRepository>(
    () =>
        SettingsRepositoryImpl(localDataSource: sl<SettingsLocalDataSource>()),
  );

  // ==========================================
  // 5. USE CASES
  // ==========================================

  // Location
  sl.registerLazySingleton<GetCurrentLocation>(
    () => GetCurrentLocation(repository: sl<LocationRepository>()),
  );

  // Weather
  sl.registerLazySingleton<GetCurrentWeather>(
    () => GetCurrentWeather(repository: sl<WeatherRepository>()),
  );

  sl.registerLazySingleton<GetForecast>(
    () => GetForecast(repository: sl<WeatherRepository>()),
  );

  // Forecast
  sl.registerLazySingleton<GetFiveDayForecast>(
    () => GetFiveDayForecast(repository: sl<WeatherRepository>()),
  );

  // Settings
  sl.registerLazySingleton<GetSettings>(
    () => GetSettings(repository: sl<SettingsRepository>()),
  );

  sl.registerLazySingleton<SaveSettings>(
    () => SaveSettings(repository: sl<SettingsRepository>()),
  );

  // Alert
  sl.registerLazySingleton<CheckAlertThreshold>(() => CheckAlertThreshold());

  // ==========================================
  // 6. BLoCs (registerFactory - new instance each time)
  // ==========================================

  // Location BLoC
  sl.registerFactory<LocationBloc>(
    () => LocationBloc(getCurrentLocation: sl<GetCurrentLocation>()),
  );

  // Weather BLoC
  sl.registerFactory<WeatherBloc>(
    () => WeatherBloc(
      getCurrentWeather: sl<GetCurrentWeather>(),
      getForecast: sl<GetForecast>(),
    ),
  );

  // Forecast BLoC
  sl.registerFactory<ForecastBloc>(
    () => ForecastBloc(getForecast: sl<GetForecast>()),
  );

  // Settings BLoC
  sl.registerFactory<SettingsBloc>(
    () => SettingsBloc(
      getSettings: sl<GetSettings>(),
      saveSettings: sl<SaveSettings>(),
    ),
  );
}
