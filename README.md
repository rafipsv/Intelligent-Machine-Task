# SkySentinel - Intelligent Weather Monitoring & Alert System

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue)
![Dart](https://img.shields.io/badge/Dart-3.9.2-blue)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-orange)
![State Management](https://img.shields.io/badge/State-BLoC-blueviolet)
![License](https://img.shields.io/badge/License-MIT-green)

**SkySentinel** is a production-ready weather monitoring application built with **Flutter** following **Feature-First Clean Architecture** and **BLoC pattern**. It provides real-time weather updates, 5-day forecasts, location-based services, and intelligent alert notifications with offline support.

---

## 📱 Features

✅ **Auto Location Detection** - Fetches user's current location using GPS  
✅ **Real-Time Weather** - Current temperature, humidity, wind speed, feels-like  
✅ **5-Day Forecast** - Daily weather predictions with hourly breakdowns  
✅ **Smart Alerts** - Customizable threshold-based notifications  
✅ **Offline Support** - Cached weather data works without internet  
✅ **Background Updates** - Periodic weather checks every 15 minutes  
✅ **Dark Theme** - Beautiful dark UI (#0A0E1A background)  
✅ **Responsive Design** - Works on Android, iOS, and Web

---

## 🏗️ Architecture Overview

SkySentinel uses **Feature-First Clean Architecture** combined with **BLoC (Business Logic Component)** pattern for predictable state management.

### Architecture Layers

```
lib/
├── core/                    # Shared utilities (DI, network, errors, theme)
├── features/                # Feature modules (weather, forecast, location, etc.)
│   ├── domain/             # Business logic (entities, usecases, repository interfaces)
│   ├── data/               # Data handling (models, datasources, repository implementations)
│   └── presentation/       # UI layer (BLoC, pages, widgets)
└── shared/                 # Reusable widgets across features
```

### The Dependency Flow

```
Presentation Layer (UI)
        ↓ calls
    BLoC (State Management)
        ↓ calls
    Use Cases (Domain)
        ↓ calls
    Repository Interfaces (Domain)
        ↓ implements
    Repository Implementation (Data)
        ↓ calls
    Data Sources (Remote API & Local Cache)
```

**Key Rule**: Inner layers know NOTHING about outer layers. Domain layer is pure Dart with no external dependencies!

---

## 🔄 Complete App Flow: Step-by-Step Explanation

Let me walk you through **EXACTLY** what happens when the app launches and how each component triggers the next!

### **STEP 1: App Initialization** (`main.dart`)

When you run `flutter run`, the app starts here:

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize dependency injection container
  await di.init();

  // 2. Initialize local notifications
  await _initializeNotifications();

  // 3. Initialize WorkManager for background tasks
  Workmanager().initialize(callbackDispatcher);

  // 4. Run the app
  runApp(const SkySentinelApp());
}
```

**What happens:**

1. ✅ Flutter engine initializes
2. ✅ **get_it** DI container registers all dependencies (BLoCs, repositories, usecases)
3. ✅ Notification system setup for alert push notifications
4. ✅ WorkManager configured for background weather checks

---

### **STEP 2: App Widget Tree** (`app.dart`)

```dart
// lib/app.dart
class SkySentinelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkySentinel',
      theme: AppTheme.darkTheme,  // Dark theme: #0A0E1A
      home: WeatherDashboardPage(),  // ← First screen
    );
  }
}
```

**What happens:**

1. ✅ MaterialApp created with dark theme
2. ✅ **WeatherDashboardPage** set as home screen
3. ✅ App renders on screen

---

### **STEP 3: Weather Dashboard Page Builds** (`weather_dashboard_page.dart`)

This is where the **magic begins**! Let's see the complete flow:

```dart
// lib/features/weather/presentation/pages/weather_dashboard_page.dart
class _WeatherDashboardPageState extends State<WeatherDashboardPage> {
  @override
  Widget build(BuildContext context) {
    // 1. MultiBlocProvider creates both BLoCs
    return MultiBlocProvider(
      providers: [
        // BLoC #1: LocationBloc - IMMEDIATELY triggers location fetch
        BlocProvider(
          create: (_) => di.sl<LocationBloc>()..add(const FetchLocationEvent()),
        ),
        // BLoC #2: WeatherBloc - Ready to fetch weather when location is available
        BlocProvider(
          create: (_) => di.sl<WeatherBloc>(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text('SkySentinel')),
        body: BlocListener<LocationBloc, LocationState>(
          listener: (context, state) {
            // 3. TRIGGER: When location is loaded, fetch weather!
            if (state is LocationLoaded) {
              context.read<WeatherBloc>().add(
                FetchWeatherEvent(
                  latitude: state.location.latitude,
                  longitude: state.location.longitude,
                ),
              );
            }
          },
          child: BlocBuilder<LocationBloc, LocationState>(
            builder: (context, locationState) {
              // 4. Show loading/error/data based on state
              if (locationState is LocationLoading) {
                return LoadingIndicator();
              }
              if (locationState is LocationError) {
                return ErrorMessageWidget(message: locationState.message);
              }
              if (locationState is LocationLoaded) {
                // 5. Show weather data (see STEP 6)
                return _buildWeatherContent();
              }
            },
          ),
        ),
      ),
    );
  }
}
```

**What happens here (The Chain Reaction):**

1. ✅ `MultiBlocProvider` creates **LocationBloc** and **WeatherBloc**
2. ✅ `FetchLocationEvent` is **immediately added** to LocationBloc
3. ✅ `BlocListener` waits for location state changes
4. ✅ `BlocBuilder` shows loading spinner while fetching location
5. ✅ **When location loads** → triggers `FetchWeatherEvent` on WeatherBloc
6. ✅ UI updates to show weather dashboard

---

### **STEP 4: LocationBloc Fetches Location** (`location_bloc.dart`)

```dart
// lib/features/location/presentation/bloc/location_bloc.dart
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocation getCurrentLocation;

  LocationBloc({required this.getCurrentLocation}) : super(LocationLoading()) {
    on<FetchLocationEvent>(_onFetchLocation);
  }

  Future<void> _onFetchLocation(
    FetchLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    // 1. Emit loading state
    emit(LocationLoading());

    try {
      // 2. Call domain usecase
      final result = await getCurrentLocation(NoParams());

      result.fold(
        // 3a. Error: Emit error state
        (failure) => emit(LocationError(message: failure.message)),
        // 3b. Success: Emit loaded state with location
        (location) => emit(LocationLoaded(location: location)),
      );
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }
}
```

**What happens:**

1. ✅ Receives `FetchLocationEvent`
2. ✅ Emits `LocationLoading` state → UI shows spinner
3. ✅ Calls `GetCurrentLocation` usecase
4. ✅ On success → emits `LocationLoaded` with coordinates
5. ✅ On error → emits `LocationError` with message

---

### **STEP 5: GetCurrentLocation UseCase → Repository → DataSource**

```dart
// DOMAIN: lib/features/location/domain/usecases/get_current_location.dart
class GetCurrentLocation implements UseCase<LocationEntity, NoParams> {
  final LocationRepository repository;

  GetCurrentLocation(this.repository);

  @override
  Future<Either<Failure, LocationEntity>> call(NoParams params) async {
    return await repository.getCurrentLocation();
  }
}

// DATA: lib/features/location/data/repositories/location_repository_impl.dart
class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    try {
      // Call data source
      final position = await dataSource.getCurrentPosition();

      // Convert to domain entity
      final location = LocationEntity(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      return Right(location);  // Success
    } catch (e) {
      return Left(LocationFailure(message: e.toString()));  // Error
    }
  }
}

// DATA: lib/features/location/data/datasources/location_datasource.dart
class LocationDataSource {
  Future<Position> getCurrentPosition() async {
    try {
      // 1. Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // 2. Try last known position first (faster)
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        return lastPosition;
      }

      // 3. Get current position with timeout
      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      throw LocationException(message: 'Failed to get location');
    }
  }
}
```

**Flow:**

```
UseCase.getCurrentLocation(NoParams)
    ↓ calls
Repository.getCurrentLocation()
    ↓ calls
DataSource.getCurrentPosition()
    ↓ calls
Geolocator API (device GPS)
    ↓ returns
Position(latitude, longitude)
    ↑ bubbles up
LocationEntity returned to BLoC
```

---

### **STEP 6: LocationLoaded Triggers Weather Fetch**

Back in `weather_dashboard_page.dart`, the `BlocListener` detects the state change:

```dart
BlocListener<LocationBloc, LocationState>(
  listener: (context, state) {
    if (state is LocationLoaded) {
      // 🎯 TRIGGER: Location obtained! Now fetch weather!
      context.read<WeatherBloc>().add(
        FetchWeatherEvent(
          latitude: state.location.latitude,   // e.g., 23.8103
          longitude: state.location.longitude, // e.g., 90.4125
        ),
      );
    }
  },
  child: ...,
)
```

**This triggers WeatherBloc!**

---

### **STEP 7: WeatherBloc Fetches Weather Data**

```dart
// lib/features/weather/presentation/bloc/weather_bloc.dart
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather getCurrentWeather;
  final GetForecast getForecast;

  WeatherBloc({
    required this.getCurrentWeather,
    required this.getForecast,
  }) : super(WeatherInitial()) {
    on<FetchWeatherEvent>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    // 1. Emit loading state
    emit(WeatherLoading());

    try {
      // 2. Fetch current weather
      final weatherResult = await getCurrentWeather(
        WeatherParams(
          latitude: event.latitude,
          longitude: event.longitude,
        ),
      );

      // 3. Fetch forecast
      final forecastResult = await getForecast(
        WeatherParams(
          latitude: event.latitude,
          longitude: event.longitude,
        ),
      );

      // 4. Handle results
      weatherResult.fold(
        (failure) => emit(WeatherError(message: failure.message)),
        (weather) {
          forecastResult.fold(
            (failure) => emit(WeatherError(message: failure.message)),
            (forecast) {
              // 5. Emit loaded state with both weather and forecast
              emit(WeatherLoaded(
                weather: weather,
                forecast: forecast,
              ));
            },
          );
        },
      );
    } catch (e) {
      emit(WeatherError(message: e.toString()));
    }
  }
}
```

**What happens:**

1. ✅ Receives `FetchWeatherEvent` with lat/lon
2. ✅ Emits `WeatherLoading` → UI shows spinner
3. ✅ Calls `GetCurrentWeather` usecase
4. ✅ Calls `GetForecast` usecase
5. ✅ On success → emits `WeatherLoaded` with data
6. ✅ On error → emits `WeatherError`

---

### **STEP 8: Weather Data Displayed on UI**

```dart
// Inside weather_dashboard_page.dart
Widget _buildWeatherContent() {
  return BlocBuilder<WeatherBloc, WeatherState>(
    builder: (context, weatherState) {
      if (weatherState is WeatherLoading) {
        return LoadingIndicator();  // Show loading
      }

      if (weatherState is WeatherError) {
        return Column(
          children: [
            ErrorMessageWidget(message: weatherState.message),
            ElevatedButton(
              onPressed: () {
                // Retry button
                context.read<WeatherBloc>().add(FetchWeatherEvent(
                  latitude: latitude,
                  longitude: longitude,
                ));
              },
              child: Text('Retry'),
            ),
          ],
        );
      }

      if (weatherState is WeatherLoaded) {
        // 🎉 SUCCESS! Build the complete weather dashboard
        return RefreshIndicator(
          onRefresh: () async {
            // Pull-to-refresh
            context.read<LocationBloc>().add(const FetchLocationEvent());
          },
          child: ListView(
            children: [
              // 1. Alert Banner (if thresholds exceeded)
              AlertBannerWidget(
                weather: weatherState.weather,
                checkAlertThreshold: di.sl<CheckAlertThreshold>(),
              ),

              // 2. Current Weather Card
              CurrentWeatherCard(weather: weatherState.weather),

              // 3. Weather Stats Grid (2x2)
              WeatherStatsGrid(weather: weatherState.weather),

              // 4. Hourly Outlook Section
              HourlyOutlookSection(forecast: weatherState.forecast),
            ],
          ),
        );
      }

      return Container();
    },
  );
}
```

**UI Components Shown:**

- ✅ **AlertBannerWidget** - Shows warning if temperature/humidity/UV exceeds threshold
- ✅ **CurrentWeatherCard** - Temperature, icon, description
- ✅ **WeatherStatsGrid** - 2x2 grid: Humidity, Wind Speed, Feels Like, UV Index
- ✅ **HourlyOutlookSection** - Next hours forecast
- ✅ **Pull-to-Refresh** - Drag down to refresh all data

---

## 📊 Complete Event Flow Diagram

```
APP LAUNCH
    ↓
main.dart
    ↓
init DI container (get_it)
    ↓
SkySentinelApp (app.dart)
    ↓
WeatherDashboardPage
    ↓
MultiBlocProvider creates:
    ├─ LocationBloc → add(FetchLocationEvent)
    └─ WeatherBloc (waiting)

LocationBloc receives FetchLocationEvent
    ↓
emit(LocationLoading)
    ↓
UI shows loading spinner
    ↓
GetCurrentLocation usecase
    ↓
LocationRepository.getCurrentLocation()
    ↓
LocationDataSource.getCurrentPosition()
    ↓
Geolocator.getCurrentPosition()
    ↓
✅ Position obtained (lat: 23.8103, lon: 90.4125)
    ↓
emit(LocationLoaded)
    ↓
BlocListener DETECTS state change
    ↓
ADD FetchWeatherEvent(lat, lon) to WeatherBloc
    ↓
WeatherBloc receives FetchWeatherEvent
    ↓
emit(WeatherLoading)
    ↓
UI shows loading spinner
    ↓
GetCurrentWeather usecase
    ↓
WeatherRepository.getCurrentWeather()
    ↓
WeatherRemoteDataSource.fetchWeather()
    ↓
HTTP GET → OpenWeatherMap API
    ↓
✅ CurrentWeatherModel received
    ↓
Convert to CurrentWeatherEntity
    ↓
Cache to SharedPreferences
    ↓
GetForecast usecase
    ↓
WeatherRepository.getForecast()
    ↓
HTTP GET → OpenWeatherMap API
    ↓
✅ ForecastModel received
    ↓
Convert to ForecastEntity
    ↓
Cache to SharedPreferences
    ↓
emit(WeatherLoaded)
    ↓
BlocBuilder rebuilds UI
    ↓
✅ Weather Dashboard Displayed:
    ├─ AlertBannerWidget
    ├─ CurrentWeatherCard
    ├─ WeatherStatsGrid
    └─ HourlyOutlookSection
```

---

## 🎯 Key BLoCs Explained

### 1️⃣ **LocationBloc**

**Purpose**: Manages user's GPS location

```dart
// Events
class FetchLocationEvent extends LocationEvent {}

// States
class LocationLoading extends LocationState {}
class LocationLoaded extends LocationState {
  final LocationEntity location;
}
class LocationError extends LocationState {
  final String message;
}
```

**Flow**:

```
FetchLocationEvent → LocationLoading → GPS API → LocationLoaded OR LocationError
```

---

### 2️⃣ **WeatherBloc**

**Purpose**: Manages current weather and forecast data

```dart
// Events
class FetchWeatherEvent extends WeatherEvent {
  final double latitude;
  final double longitude;
}

// States
class WeatherLoading extends WeatherState {}
class WeatherLoaded extends WeatherState {
  final CurrentWeatherEntity weather;
  final ForecastEntity forecast;
}
class WeatherError extends WeatherState {
  final String message;
}
```

**Flow**:

```
FetchWeatherEvent → WeatherLoading → API Call → WeatherLoaded OR WeatherError
```

---

### 3️⃣ **ForecastBloc**

**Purpose**: Manages 5-day forecast separately

```dart
// Events
class FetchForecastEvent extends ForecastEvent {
  final double latitude;
  final double longitude;
}

// States
class ForecastLoading extends ForecastState {}
class ForecastLoaded extends ForecastState {
  final ForecastEntity forecast;
}
class ForecastError extends ForecastState {
  final String message;
}
```

---

### 4️⃣ **SettingsBloc**

**Purpose**: Manages alert threshold settings

```dart
// Events
class LoadSettingsEvent extends SettingsEvent {}
class UpdateSettingsEvent extends SettingsEvent {
  final AlertSettingsEntity settings;
}

// States
class SettingsLoading extends SettingsState {}
class SettingsLoaded extends SettingsState {
  final AlertSettingsEntity settings;
}
class SettingsError extends SettingsState {
  final String message;
}
```

**Flow**:

```
LoadSettingsEvent → SettingsLoading → SharedPreferences → SettingsLoaded
UpdateSettingsEvent → Save to SharedPreferences → SettingsLoaded
```

---

## 📦 Dependency Injection (get_it)

All dependencies are registered in `lib/core/di/injection_container.dart`:

```dart
final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory<LocationBloc>(
    () => LocationBloc(getCurrentLocation: sl<GetCurrentLocation>())
  );

  sl.registerFactory<WeatherBloc>(
    () => WeatherBloc(
      getCurrentWeather: sl<GetCurrentWeather>(),
      getForecast: sl<GetForecast>(),
    )
  );

  // UseCases
  sl.registerLazySingleton<GetCurrentLocation>(
    () => GetCurrentLocation(repository: sl<LocationRepository>())
  );

  sl.registerLazySingleton<GetCurrentWeather>(
    () => GetCurrentWeather(repository: sl<WeatherRepository>())
  );

  // Repositories
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(dataSource: sl<LocationDataSource>())
  );

  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: sl<WeatherRemoteDataSource>(),
      localDataSource: sl<WeatherLocalDataSource>(),
    )
  );

  // Data Sources
  sl.registerLazySingleton<LocationDataSource>(
    () => LocationDataSource()
  );

  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSource(client: sl<HttpClient>())
  );

  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSource(prefs: sl<SharedPreferences>())
  );

  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);

  sl.registerLazySingleton<HttpClient>(
    () => HttpClient(dio: Dio())
  );
}
```

**Registration Types:**

- `registerFactory` - New instance every time (BLoCs)
- `registerLazySingleton` - Created once when first requested (usecases, repos, datasources)

---

## 🔔 Alert System Flow

### How Alerts Work:

```dart
// 1. CheckAlertThreshold Usecase (Domain Layer)
class CheckAlertThreshold {
  AlertResult call({
    required CurrentWeatherEntity weather,
    required AlertSettingsEntity settings,
  }) {
    // Check temperature
    if (weather.temperature > settings.temperatureThreshold) {
      return AlertResult.temperatureAlert(
        weather.temperature,
        settings.temperatureThreshold,
      );
    }

    // Check rain
    if (weather.rainProbability > settings.rainThreshold) {
      return AlertResult.rainAlert(
        weather.rainProbability,
        settings.rainThreshold,
      );
    }

    // Check UV
    if (weather.uvIndex > settings.uvThreshold) {
      return AlertResult.uvAlert(
        weather.uvIndex,
        settings.uvThreshold,
      );
    }

    return AlertResult.noAlert();
  }
}

// 2. AlertBannerWidget checks on every weather update
class AlertBannerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = AlertSettingsEntity(); // From cache
    final alertResult = checkAlertThreshold(
      weather: weather,
      settings: settings,
    );

    if (!alertResult.isTriggered) {
      return SizedBox.shrink(); // No alert
    }

    return Dismissible(
      key: Key('alert'),
      onDismissed: (_) => setState(() => dismissed = true),
      child: GestureDetector(
        onTap: () {
          // Navigate to AlertDetailPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AlertDetailPage(alertResult: alertResult),
            ),
          );
        },
        child: AlertBannerCard(
          icon: alertResult.icon,
          message: alertResult.message,
          color: alertResult.color,
        ),
      ),
    );
  }
}
```

**Alert Flow:**

```
WeatherLoaded → AlertBannerWidget builds
    ↓
CheckAlertThreshold(weather, settings)
    ↓
Compare weather values with thresholds
    ↓
If exceeded → Return AlertResult
    ↓
Show AlertBannerWidget
    ↓
User taps banner → AlertDetailPage
    ↓
Shows alert details with action buttons
```

---

## 🔄 Offline-First Architecture

SkySentinel implements a **smart caching strategy**:

```dart
// WeatherRepositoryImpl - Offline-First Logic
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;

  @override
  Future<Either<Failure, CurrentWeatherEntity>> getCurrentWeather(
    WeatherParams params,
  ) async {
    try {
      // 1. Try to fetch from remote API
      final weather = await remoteDataSource.fetchCurrentWeather(params);

      // 2. If successful, cache it locally
      await localDataSource.cacheCurrentWeather(weather);

      return Right(weather);
    } catch (e) {
      // 3. If remote fails, try cache
      try {
        final cachedWeather = await localDataSource.getCachedCurrentWeather();
        return Right(cachedWeather);
      } catch (cacheError) {
        // 4. If no cache, return error
        return Left(NetworkFailure(message: 'No internet and no cached data'));
      }
    }
  }
}
```

**Offline Flow:**

```
Internet Available?
    ├─ YES → Fetch from API → Cache → Return data
    └─ NO → Try cache
              ├─ Has cache? → Return cached data
              └─ No cache? → Return error with "Retry" button
```

---

## 🎨 UI Architecture

### Widget Refactoring Strategy

Large pages are broken into smaller, reusable widgets:

**Before Refactoring:**

```
weather_dashboard_page.dart - 281 lines ❌
```

**After Refactoring:**

```
weather_dashboard_page.dart - 151 lines ✅
├── widgets/
    ├── alert_banner_widget.dart (45 lines)
    ├── current_weather_card.dart (68 lines)
    ├── weather_stats_grid.dart (52 lines)
    └── hourly_outlook_section.dart (42 lines)
```

**Benefits:**

- ✅ 46% code reduction in main page
- ✅ Each widget has single responsibility
- ✅ Easier to test and maintain
- ✅ Reusable across features

---

## 🚀 How to Run

### Prerequisites

- **Flutter SDK**: 3.9.2 or higher
- **Dart SDK**: 3.9.2 or higher
- **Android Studio** / **VS Code** with Flutter extensions
- **OpenWeatherMap API Key**: Get free key from https://openweathermap.org/api

### Step-by-Step Setup

**1. Clone the Repository**

```bash
git clone https://github.com/YOUR_USERNAME/skysentinel.git
cd skysentinel
```

**2. Install Dependencies**

```bash
flutter pub get
```

**3. Configure API Key**

Update `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String apiKey = 'YOUR_API_KEY_HERE'; // ← Replace with your key
}
```

**4. Run the App**

```bash
# Run on connected device or emulator
flutter run

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

**5. Build Release APK** (Optional)

```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📁 Complete Project Structure

```
intelligent_machine_task/
├── lib/
│   ├── main.dart                         # Entry point, DI init, notifications
│   ├── app.dart                          # MaterialApp with theme
│   │
│   ├── core/                             # Shared utilities
│   │   ├── constants/
│   │   │   ├── api_constants.dart        # API URL and key
│   │   │   └── app_strings.dart          # App-wide string constants
│   │   ├── di/
│   │   │   └── injection_container.dart  # get_it dependency injection
│   │   ├── errors/
│   │   │   ├── exceptions.dart           # Custom exceptions
│   │   │   └── failures.dart             # Failure classes for error handling
│   │   ├── network/
│   │   │   └── http_client.dart          # HTTP client wrapper (Dio)
│   │   ├── theme/
│   │   │   └── app_theme.dart            # Dark theme configuration
│   │   └── utils/
│   │       ├── date_formatter.dart       # Date/time formatting utilities
│   │       └── weather_icon_mapper.dart  # Weather code to icon mapping
│   │
│   ├── features/                         # Feature modules
│   │   │
│   │   ├── weather/                      # Weather feature
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── current_weather.dart  # CurrentWeatherEntity
│   │   │   │   │   └── forecast.dart         # ForecastEntity
│   │   │   │   ├── repositories/
│   │   │   │   │   └── weather_repository.dart  # Interface
│   │   │   │   └── usecases/
│   │   │   │       ├── get_current_weather.dart
│   │   │   │       └── get_forecast.dart
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── current_weather_model.dart  # Extends entity
│   │   │   │   │   └── forecast_model.dart
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── weather_remote_datasource.dart  # API calls
│   │   │   │   │   └── weather_local_datasource.dart   # Cache
│   │   │   │   └── repositories/
│   │   │   │       └── weather_repository_impl.dart    # Implementation
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── weather_bloc.dart
│   │   │       │   ├── weather_event.dart
│   │   │       │   └── weather_state.dart
│   │   │       ├── pages/
│   │   │       │   └── weather_dashboard_page.dart
│   │   │       └── widgets/
│   │   │           ├── alert_banner_widget.dart
│   │   │           ├── current_weather_card.dart
│   │   │           ├── weather_stats_grid.dart
│   │   │           └── hourly_outlook_section.dart
│   │   │
│   │   ├── forecast/                     # Forecast feature
│   │   │   ├── presentation/
│   │   │   │   ├── bloc/
│   │   │   │   ├── pages/
│   │   │   │   │   └── forecast_page.dart
│   │   │   │   └── widgets/
│   │   │   │       └── forecast_day_tile.dart
│   │   │   └── ...
│   │   │
│   │   ├── location/                     # Location feature
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── location.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── location_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       └── get_current_location.dart
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── location_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── location_repository_impl.dart
│   │   │   └── presentation/
│   │   │       └── bloc/
│   │   │           ├── location_bloc.dart
│   │   │           ├── location_event.dart
│   │   │           └── location_state.dart
│   │   │
│   │   ├── settings/                     # Settings feature
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── alert_settings.dart
│   │   │   │   └── repositories/
│   │   │   │       └── settings_repository.dart
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── settings_local_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── settings_repository_impl.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── settings_bloc.dart
│   │   │       │   ├── settings_event.dart
│   │   │       │   └── settings_state.dart
│   │   │       ├── pages/
│   │   │       │   └── settings_page.dart
│   │   │       └── widgets/
│   │   │           ├── threshold_slider_tile.dart
│   │   │           └── alert_switch_tile.dart
│   │   │
│   │   └── alert/                        # Alert feature
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── alert_result.dart
│   │       │   └── usecases/
│   │       │       └── check_alert_threshold.dart
│   │       └── presentation/
│   │           ├── pages/
│   │           │   └── alert_detail_page.dart
│   │           └── widgets/
│   │               ├── alert_icon_widget.dart
│   │               ├── alert_message_card.dart
│   │               ├── alert_detail_card.dart
│   │               └── alert_action_buttons.dart
│   │
│   └── shared/                           # Shared widgets
│       └── widgets/
│           ├── loading_indicator.dart
│           ├── error_message_widget.dart
│           └── bottom_nav_bar.dart
│
├── android/                              # Android platform files
├── ios/                                  # iOS platform files
├── test/                                 # Unit and widget tests
├── pubspec.yaml                          # Dependencies
└── README.md                             # This file
```

---

## 📊 Code Statistics

| Metric                  | Count                                     |
| ----------------------- | ----------------------------------------- |
| **Total Dart Files**    | 50+                                       |
| **Total Lines of Code** | ~4,500                                    |
| **BLoCs**               | 4 (Location, Weather, Forecast, Settings) |
| **Use Cases**           | 6                                         |
| **Repositories**        | 4                                         |
| **Data Sources**        | 6                                         |
| **Widgets**             | 20+                                       |
| **flutter analyze**     | ✅ Zero issues                            |

---

## 🤖 AI-Assisted Development

This project was built using **Qoder AI** with a systematic phase-by-phase approach:

### Development Phases

- **Phase 0-2**: Project setup, core utilities, error handling
- **Phase 3-5**: Location and weather features with BLoC
- **Phase 6-8**: Forecast and settings features
- **Phase 9**: UI refinement and widget refactoring
- **Phase 10**: Background tasks and notifications
- **Phase 11**: Error handling and offline support
- **Phase 12**: Code optimization and documentation

### Refactoring Achievements

- ✅ Reduced page files by **37%** (747 → 469 lines)
- ✅ Created **9 new reusable widgets**
- ✅ **Zero warnings/errors** in flutter analyze
- ✅ Clean Architecture principles maintained throughout

---

## 🎯 Future Enhancements

- [ ] Weather maps integration
- [ ] Multiple location support
- [ ] Weather radar animations
- [ ] Home screen widget support
- [ ] Weather history charts with graphs
- [ ] Severe weather warnings from government APIs
- [ ] Multi-language support (i18n)
- [ ] Light theme option

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Muhammad Fazlul Karim**

Built with ❤️ using Flutter, Clean Architecture, and BLoC pattern.

---

## 📞 Support

If you encounter any issues:

1. Check existing [Issues](https://github.com/YOUR_USERNAME/skysentinel/issues)
2. Create a new issue with detailed description
3. Include steps to reproduce the problem

---

**⭐ If you find this project helpful, please give it a star on GitHub!**

---

## 🎓 Quick Reference: How Data Flows

```
User Opens App
    ↓
WeatherDashboardPage builds
    ↓
MultiBlocProvider creates LocationBloc + WeatherBloc
    ↓
FetchLocationEvent added to LocationBloc
    ↓
LocationBloc calls GetCurrentLocation usecase
    ↓
Usecase calls LocationRepository
    ↓
Repository calls LocationDataSource
    ↓
DataSource calls Geolocator API
    ↓
Position obtained (lat, lon)
    ↓
LocationLoaded state emitted
    ↓
BlocListener detects LocationLoaded
    ↓
FetchWeatherEvent added to WeatherBloc with lat/lon
    ↓
WeatherBloc calls GetCurrentWeather + GetForecast usecases
    ↓
Usecases call WeatherRepository
    ↓
Repository tries remote API first
    ↓
RemoteDataSource calls OpenWeatherMap API
    ↓
Weather data received
    ↓
Cache data to SharedPreferences
    ↓
WeatherLoaded state emitted with weather + forecast
    ↓
BlocBuilder rebuilds UI
    ↓
✅ User sees weather dashboard!
```

**Congratulations! You now understand the complete SkySentinel architecture! 🎉**
