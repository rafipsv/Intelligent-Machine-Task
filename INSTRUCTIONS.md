# SkySentinel — Build Instructions

> **Agent Guide:** প্রতিটা step ছোট ও atomic। একটা step শেষ করে test করো, তারপর পরেরটায় যাও।

---

## PHASE 0 — Project Setup

- [ ] **Step 0.1:** Flutter latest stable দিয়ে নতুন project create করো।
  ```
  flutter create sky_sentinel
  ```

- [ ] **Step 0.2:** `pubspec.yaml`-এ নিচের packages add করো, তারপর `flutter pub get` রান করো।
  ```yaml
  dependencies:
    flutter_bloc: ^8.1.6
    equatable: ^2.0.5
    http: ^1.2.1
    geolocator: ^13.0.2
    permission_handler: ^11.3.1
    shared_preferences: ^2.3.2
    flutter_local_notifications: ^18.0.1
    workmanager: ^0.5.2
    get_it: ^8.0.2          # Service Locator / DI
    intl: ^0.19.0

  dev_dependencies:
    bloc_test: ^9.1.7
    mocktail: ^1.0.4
  ```

- [ ] **Step 0.3:** Android `AndroidManifest.xml`-এ permissions add করো।
  ```xml
  <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
  <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
  <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
  ```

- [ ] **Step 0.4:** OpenWeatherMap-এ account খুলে একটা free API key নাও। `.env` বা `lib/core/constants/api_constants.dart`-এ রাখো।

---

## PHASE 1 — Folder Structure তৈরি করো

> ZB-Dezine project-এর মতো **Feature-First** structure, কিন্তু প্রতিটা feature-এর ভেতরে **data / domain / presentation** layer।

- [ ] **Step 1.1:** নিচের folder structure হুবহু তৈরি করো (ফাইল খালি রাখো এখন)।

```
lib/
├── main.dart
├── app.dart                          # MaterialApp setup
│
├── core/
│   ├── constants/
│   │   ├── api_constants.dart        # Base URL, API key
│   │   └── app_strings.dart          # UI strings
│   ├── errors/
│   │   ├── exceptions.dart           # Custom exceptions
│   │   └── failures.dart             # Failure classes
│   ├── network/
│   │   └── http_client.dart          # http package wrapper
│   ├── di/
│   │   └── injection_container.dart  # get_it registrations
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       ├── date_formatter.dart
│       └── weather_icon_mapper.dart
│
├── features/
│   │
│   ├── weather/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── weather_remote_datasource.dart   # http call
│   │   │   │   └── weather_local_datasource.dart    # shared_preferences cache
│   │   │   ├── models/
│   │   │   │   ├── current_weather_model.dart       # fromJson/toJson
│   │   │   │   └── forecast_model.dart
│   │   │   └── repositories/
│   │   │       └── weather_repository_impl.dart     # implements domain repo
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── current_weather.dart             # pure dart class
│   │   │   │   └── forecast.dart
│   │   │   ├── repositories/
│   │   │   │   └── weather_repository.dart          # abstract class
│   │   │   └── usecases/
│   │   │       ├── get_current_weather.dart
│   │   │       └── get_forecast.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── weather_bloc.dart
│   │       │   ├── weather_event.dart
│   │       │   └── weather_state.dart
│   │       ├── pages/
│   │       │   └── weather_dashboard_page.dart
│   │       └── widgets/
│   │           ├── current_weather_card.dart
│   │           ├── hourly_outlook_widget.dart
│   │           └── weather_stat_tile.dart
│   │
│   ├── forecast/
│   │   ├── data/                     # (weather feature-এর model reuse করবে)
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       └── get_five_day_forecast.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── forecast_bloc.dart
│   │       │   ├── forecast_event.dart
│   │       │   └── forecast_state.dart
│   │       ├── pages/
│   │       │   └── forecast_page.dart
│   │       └── widgets/
│   │           └── forecast_day_tile.dart
│   │
│   ├── location/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── location_datasource.dart         # geolocator wrapper
│   │   │   └── repositories/
│   │   │       └── location_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── location.dart
│   │   │   ├── repositories/
│   │   │   │   └── location_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_current_location.dart
│   │   └── presentation/
│   │       └── bloc/
│   │           ├── location_bloc.dart
│   │           ├── location_event.dart
│   │           └── location_state.dart
│   │
│   ├── settings/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── settings_local_datasource.dart   # shared_preferences
│   │   │   └── repositories/
│   │   │       └── settings_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── alert_settings.dart              # threshold model
│   │   │   ├── repositories/
│   │   │   │   └── settings_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_settings.dart
│   │   │       └── save_settings.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── settings_bloc.dart
│   │       │   ├── settings_event.dart
│   │       │   └── settings_state.dart
│   │       ├── pages/
│   │       │   └── settings_page.dart
│   │       └── widgets/
│   │           └── threshold_slider_tile.dart
│   │
│   └── alert/
│       ├── domain/
│       │   └── usecases/
│       │       └── check_alert_threshold.dart       # business logic only
│       └── presentation/
│           ├── bloc/                                # optional, alert state
│           └── pages/
│               └── alert_detail_page.dart
│
└── shared/
    └── widgets/
        ├── loading_indicator.dart
        ├── error_message_widget.dart
        └── bottom_nav_bar.dart
```

---

## PHASE 2 — Core Layer

- [ ] **Step 2.1:** `api_constants.dart` লিখো।
  - `baseUrl = 'https://api.openweathermap.org/data/2.5'`
  - `apiKey = 'YOUR_KEY'`

- [ ] **Step 2.2:** `exceptions.dart` লিখো।
  - `ServerException`, `CacheException`, `LocationException` class বানাও।

- [ ] **Step 2.3:** `failures.dart` লিখো।
  - `ServerFailure`, `CacheFailure`, `LocationFailure` — সব `Failure` abstract class extend করবে।

- [ ] **Step 2.4:** `http_client.dart` লিখো।
  - `http.get()` wrap করো।
  - Status 200 হলে decoded body return করো।
  - অন্য status হলে `ServerException` throw করো।

- [ ] **Step 2.5:** `app_theme.dart` লিখো।
  - Dark theme (design অনুযায়ী, background `#0A0E1A`)।
  - `ThemeData` define করো।

---

## PHASE 3 — Location Feature

- [ ] **Step 3.1:** `location.dart` entity লিখো।
  ```dart
  class Location extends Equatable {
    final double latitude;
    final double longitude;
    final String cityName; // optional, reverse geocode ছাড়া খালি রাখো
  }
  ```

- [ ] **Step 3.2:** `location_repository.dart` abstract class লিখো।
  ```dart
  abstract class LocationRepository {
    Future<Either<Failure, Location>> getCurrentLocation();
  }
  ```
  > `Either` use করবে না — সহজ করতে চাইলে `Future<Location>` আর try/catch ব্যবহার করো।

- [ ] **Step 3.3:** `location_datasource.dart` লিখো।
  - `geolocator` দিয়ে permission check করো।
  - Permission denied হলে `LocationException` throw করো।
  - `getCurrentPosition()` call করো।

- [ ] **Step 3.4:** `location_repository_impl.dart` লিখো।
  - datasource call করো।
  - Exception catch করে `LocationFailure` return করো।

- [ ] **Step 3.5:** `get_current_location.dart` usecase লিখো।
  - শুধু repository call করো।

- [ ] **Step 3.6:** `location_event.dart` লিখো।
  - `FetchLocationEvent` class।

- [ ] **Step 3.7:** `location_state.dart` লিখো।
  - `LocationInitial`, `LocationLoading`, `LocationLoaded(Location)`, `LocationError(String)` class।

- [ ] **Step 3.8:** `location_bloc.dart` লিখো।
  - `FetchLocationEvent` এলে usecase call করো।
  - State emit করো।

- [ ] **Step 3.9:** Test করো — একটা simple page বানাও, LocationBloc দিয়ে lat/lng print করো।

---

## PHASE 4 — Weather Feature (Data Layer)

- [ ] **Step 4.1:** `current_weather_model.dart` লিখো।
  - OpenWeatherMap current weather API response অনুযায়ী `fromJson()` লিখো।
  - Fields: `temperature`, `feelsLike`, `humidity`, `windSpeed`, `description`, `icon`, `rain1h`, `cityName`, `updatedAt`।

- [ ] **Step 4.2:** `forecast_model.dart` লিখো।
  - 5-day forecast API response অনুযায়ী।
  - `ForecastDayModel` list parse করো।

- [ ] **Step 4.3:** `weather_remote_datasource.dart` লিখো।
  - `getCurrentWeather(lat, lon)` → `GET /weather?lat=&lon=&appid=&units=metric`
  - `getForecast(lat, lon)` → `GET /forecast?lat=&lon=&appid=&units=metric`
  - `http_client.dart` use করো।

- [ ] **Step 4.4:** `weather_local_datasource.dart` লিখো।
  - `shared_preferences` দিয়ে last weather JSON save ও read করো।
  - Keys: `'cached_current_weather'`, `'cached_forecast'`।

- [ ] **Step 4.5:** `current_weather.dart` entity লিখো (pure Dart, no JSON).
  - Model থেকে আলাদা — শুধু app-এর দরকারি fields।

- [ ] **Step 4.6:** `forecast.dart` entity লিখো।

- [ ] **Step 4.7:** `weather_repository.dart` abstract class লিখো।
  ```dart
  abstract class WeatherRepository {
    Future<CurrentWeather> getCurrentWeather(double lat, double lon);
    Future<List<ForecastDay>> getForecast(double lat, double lon);
  }
  ```

- [ ] **Step 4.8:** `weather_repository_impl.dart` লিখো।
  - প্রথমে remote call করো।
  - Success হলে cache save করো।
  - Network error হলে cache থেকে পড়ো।
  - Cache-ও না থাকলে Exception throw করো।

---

## PHASE 5 — Weather Feature (Domain + BLoC)

- [ ] **Step 5.1:** `get_current_weather.dart` usecase লিখো।
  - Repository call করো, entity return করো।

- [ ] **Step 5.2:** `get_forecast.dart` usecase লিখো।

- [ ] **Step 5.3:** `weather_event.dart` লিখো।
  - `FetchWeatherEvent(double lat, double lon)`

- [ ] **Step 5.4:** `weather_state.dart` লিখো।
  - `WeatherInitial`, `WeatherLoading`, `WeatherLoaded(CurrentWeather)`, `WeatherError(String)`

- [ ] **Step 5.5:** `weather_bloc.dart` লিখো।
  - `FetchWeatherEvent` এলে usecase call করো।
  - State emit করো।

- [ ] **Step 5.6:** `forecast_event.dart`, `forecast_state.dart`, `forecast_bloc.dart` একইভাবে লিখো।

---

## PHASE 6 — Settings Feature

- [ ] **Step 6.1:** `alert_settings.dart` entity লিখো।
  ```dart
  class AlertSettings extends Equatable {
    final double tempThreshold;      // e.g., 30.0 °C
    final bool alertOnRain;
    final double rainThreshold;      // e.g., 0.1 mm
    final bool alertOnHighUV;
    final double uvThreshold;
  }
  ```

- [ ] **Step 6.2:** `settings_local_datasource.dart` লিখো।
  - `shared_preferences` দিয়ে settings save/read করো।

- [ ] **Step 6.3:** `settings_repository.dart` abstract + `settings_repository_impl.dart` লিখো।

- [ ] **Step 6.4:** `get_settings.dart` ও `save_settings.dart` usecase লিখো।

- [ ] **Step 6.5:** `settings_event.dart` লিখো।
  - `LoadSettingsEvent`, `UpdateSettingsEvent(AlertSettings)`

- [ ] **Step 6.6:** `settings_state.dart` লিখো।
  - `SettingsInitial`, `SettingsLoaded(AlertSettings)`, `SettingsError`

- [ ] **Step 6.7:** `settings_bloc.dart` লিখো।

---

## PHASE 7 — Alert Feature

- [ ] **Step 7.1:** `check_alert_threshold.dart` usecase লিখো।
  - `CurrentWeather` + `AlertSettings` নাও input হিসেবে।
  - Logic:
    - `weather.temperature > settings.tempThreshold` → alert
    - `settings.alertOnRain && weather.rain1h > settings.rainThreshold` → alert
  - Return: `AlertResult(isTriggered: bool, triggeredFactor: String, message: String)`

- [ ] **Step 7.2:** `alert_detail_page.dart` লিখো।
  - Design-এর 3rd screenshot অনুযায়ী।
  - "View Full Dashboard" button → Dashboard-এ navigate করো।
  - "Dismiss Alert" button → page pop করো।

---

## PHASE 8 — Dependency Injection

- [ ] **Step 8.1:** `injection_container.dart`-এ `get_it` দিয়ে সব register করো।
  ```
  Order:
  1. External (SharedPreferences, http.Client)
  2. Data Sources
  3. Repositories
  4. Use Cases
  5. BLoCs (registerFactory)
  ```

- [ ] **Step 8.2:** `main.dart`-এ app শুরুর আগে `await init()` call করো।

---

## PHASE 9 — UI (Presentation Layer)

- [ ] **Step 9.1:** `bottom_nav_bar.dart` shared widget লিখো।
  - 3 tabs: Home, Analytics (Forecast), Settings।

- [ ] **Step 9.2:** `app.dart` লিখো।
  - `MultiBlocProvider` দিয়ে সব BLoC inject করো।
  - `MaterialApp` dark theme set করো।

- [ ] **Step 9.3:** `weather_dashboard_page.dart` লিখো।
  - `BlocBuilder<LocationBloc>` দিয়ে location পাও।
  - Location পেলে `WeatherBloc` এবং `ForecastBloc`-এ event add করো।
  - `BlocBuilder<WeatherBloc>`:
    - Loading → `LoadingIndicator` widget
    - Error → `ErrorMessageWidget`
    - Loaded → weather cards দেখাও।

- [ ] **Step 9.4:** `current_weather_card.dart` লিখো।
  - বড় temperature text, description, "Updated X ago"।

- [ ] **Step 9.5:** `weather_stat_tile.dart` লিখো।
  - Humidity, Wind Speed, UV Index — প্রতিটা আলাদা tile।

- [ ] **Step 9.6:** `hourly_outlook_widget.dart` লিখো।
  - Horizontal scroll, forecast data থেকে প্রথম কয়েকটা entry দেখাও।

- [ ] **Step 9.7:** `forecast_page.dart` লিখো।
  - `BlocBuilder<ForecastBloc>` দিয়ে 5-day list দেখাও।

- [ ] **Step 9.8:** `forecast_day_tile.dart` লিখো।
  - Date, weather icon, high/low temp, condition label।

- [ ] **Step 9.9:** `settings_page.dart` লিখো।
  - Slider for temp threshold।
  - Switch for rain alert।
  - Slider for rain threshold।

- [ ] **Step 9.10:** Alert banner — Dashboard-এর top-এ দেখাও।
  - `BlocBuilder<WeatherBloc>` loaded হলে `check_alert_threshold` usecase call করো।
  - Triggered হলে dismissible banner দেখাও।
  - Banner tap করলে `alert_detail_page.dart`-এ navigate করো।

---

## PHASE 10 — Background Task & Notifications

- [ ] **Step 10.1:** `flutter_local_notifications` initialize করো `main.dart`-এ।
  - Android channel: `high_importance_channel`।
  - Notification tap callback setup করো।

- [ ] **Step 10.2:** Notification tap হলে app খুলে `alert_detail_page.dart`-এ navigate করার logic লিখো।

- [ ] **Step 10.3:** `workmanager` initialize করো `main.dart`-এ।
  ```dart
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask(
    "weather-check",
    "weatherBackgroundFetch",
    frequency: Duration(minutes: 15),
  );
  ```

- [ ] **Step 10.4:** `callbackDispatcher` top-level function লিখো।
  - SharedPreferences থেকে cached weather পড়ো।
  - SharedPreferences থেকে settings পড়ো।
  - `check_alert_threshold` logic manually call করো (BLoC ছাড়া)।
  - Threshold hit হলে `flutter_local_notifications` দিয়ে notification show করো।

---

## PHASE 11 — Error Handling & Loading States

- [ ] **Step 11.1:** `loading_indicator.dart` — `CircularProgressIndicator` centered।

- [ ] **Step 11.2:** `error_message_widget.dart` — icon + message + retry button।

- [ ] **Step 11.3:** সব BlocBuilder-এ error state handle করো।

- [ ] **Step 11.4:** Network না থাকলে cached data দিয়ে app চলে কিনা test করো (Airplane Mode)।

---

## PHASE 12 — Final Steps

- [ ] **Step 12.1:** সব hardcoded string `app_strings.dart`-এ সরাও।

- [ ] **Step 12.2:** `const` ও `final` যেখানে applicable সেখানে add করো।

- [ ] **Step 12.3:** `flutter analyze` রান করো, সব warning fix করো।

- [ ] **Step 12.4:** Release APK build করো।
  ```
  flutter build apk --release
  ```

- [ ] **Step 12.5:** `README.md` লিখো এই sections সহ:
  1. Project Title & Description
  2. Architecture (Feature-First + Clean Architecture + BLoC)
  3. Main BLoCs: `WeatherBloc`, `ForecastBloc`, `LocationBloc`, `SettingsBloc`
  4. Generative AI usage ও prompts
  5. How to Run
  6. Screenshots

- [ ] **Step 12.6:** GitHub-এ public repo তৈরি করে push করো।

- [ ] **Step 12.7:** APK Google Drive-এ upload করো, link README-এ add করো।

---

## Quick Reference — API Endpoints

```
Current Weather:
GET https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={key}&units=metric

5-Day Forecast:
GET https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={key}&units=metric
```

## Key Architecture Rules

| ZB-Dezine (GetX) | SkySentinel (BLoC) |
|---|---|
| `controller/` | `bloc/` (event, state, bloc) |
| `repositories/` | `data/repositories/` + `domain/repositories/` |
| `models/` | `data/models/` (JSON) + `domain/entities/` (pure Dart) |
| `views/` | `presentation/pages/` |
| `widgets/` | `presentation/widgets/` |
| `Get.find<>()` | `get_it` service locator |
| `GetX bindings` | `injection_container.dart` |
