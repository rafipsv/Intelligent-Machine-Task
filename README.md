# SkySentinel - Intelligent Weather Monitoring & Alert System

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue)
![Dart](https://img.shields.io/badge/Dart-3.9.2-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey)

**SkySentinel** is a feature-rich weather monitoring application that provides real-time weather updates, 5-day forecasts, and intelligent alert notifications based on customizable thresholds. Built with **Flutter** following **Clean Architecture** and **BLoC pattern** for maintainability and scalability.

---

## 📱 Features

- **🌍 Location-Based Weather**: Automatically detects user location and fetches weather data
- **🌡️ Real-Time Weather**: Current temperature, humidity, wind speed, feels-like, and more
- **📅 5-Day Forecast**: Detailed daily weather predictions with hourly breakdowns
- **🔔 Smart Alerts**: Customizable threshold-based notifications for temperature, rain, and UV
- **💾 Offline Support**: Cached weather data works in airplane mode
- **🔄 Background Updates**: Periodic weather checks every 15 minutes
- **🌙 Dark Theme**: Beautiful dark UI optimized for readability
- **📱 Responsive Design**: Works on phones, tablets, and web

---

## 🏗️ Architecture

SkySentinel follows **Feature-First Clean Architecture** with **BLoC (Business Logic Component)** pattern for state management.

### Architecture Layers

```
lib/
├── core/                     # Shared core functionality
│   ├── constants/           # App-wide constants (API keys, strings)
│   ├── di/                  # Dependency injection (get_it)
│   ├── errors/              # Custom exceptions and failures
│   ├── network/             # HTTP client wrapper
│   ├── theme/               # App theme configuration
│   └── utils/               # Utility classes (date formatter, etc.)
│
├── features/                # Feature modules
│   ├── weather/            # Current weather feature
│   ├── forecast/           # 5-day forecast feature
│   ├── location/           # Geolocation feature
│   ├── settings/           # Alert settings feature
│   └── alert/              # Alert threshold checking
│       ├── domain/         # Business logic (entities, usecases, repositories)
│       ├── data/           # Data layer (models, datasources, repository impl)
│       └── presentation/   # UI layer (bloc, pages, widgets)
│
└── shared/                 # Shared widgets across features
    └── widgets/           # Loading, error, navigation components
```

### Clean Architecture Principles

- **Domain Layer**: Pure Dart, no dependencies on external packages
- **Data Layer**: Implements domain repositories, handles data sources (remote & local)
- **Presentation Layer**: BLoC pattern for state management, Flutter widgets for UI
- **Dependency Rule**: Inner layers know nothing about outer layers

---

## 🔄 State Management with BLoC

SkySentinel uses **flutter_bloc** for predictable state management:

### Main BLoCs

| BLoC             | Purpose                  | Events                                     | States                                               |
| ---------------- | ------------------------ | ------------------------------------------ | ---------------------------------------------------- |
| **LocationBloc** | Manages user geolocation | `FetchLocationEvent`                       | `LocationLoading`, `LocationLoaded`, `LocationError` |
| **WeatherBloc**  | Current weather data     | `FetchWeatherEvent(lat, lon)`              | `WeatherLoading`, `WeatherLoaded`, `WeatherError`    |
| **ForecastBloc** | 5-day forecast data      | `FetchForecastEvent(lat, lon)`             | `ForecastLoading`, `ForecastLoaded`, `ForecastError` |
| **SettingsBloc** | Alert threshold settings | `LoadSettingsEvent`, `UpdateSettingsEvent` | `SettingsLoading`, `SettingsLoaded`, `SettingsError` |

### BLoC Flow Example

```dart
// Event
locationBloc.add(FetchLocationEvent());

// State Stream
BlocBuilder<LocationBloc, LocationState>(
  builder: (context, state) {
    if (state is LocationLoading) return LoadingIndicator();
    if (state is LocationError) return ErrorMessageWidget(message: state.message);
    if (state is LocationLoaded) {
      // Use state.location.latitude/longitude
      return WeatherDashboard();
    }
  },
)
```

---

## 🤖 Generative AI Usage

This project was built using **Qoder AI** with the following prompting strategy:

### Prompts Used

1. **Phase-by-Phase Development**:

   ```
   "Complete Phase X from INSTRUCTIONS.md"
   ```

   - Followed detailed Bengali instructions in INSTRUCTIONS.md
   - Each phase completed atomically with verification

2. **Architecture Guidance**:

   ```
   "Implement Feature-First Clean Architecture with BLoC pattern"
   ```

   - Maintained strict layer separation
   - Used Entity suffix for domain objects to avoid naming conflicts

3. **Code Refactoring**:

   ```
   "Break down large page code into smaller reusable widgets"
   ```

   - Reduced page files by 37% (747 → 469 lines)
   - Created 9 new feature-specific widget files

4. **Error Handling**:
   ```
   "Verify all BlocBuilder error state handling and cache fallback"
   ```

   - Implemented offline-first architecture
   - All error states show retry buttons

### AI Assistance Benefits

- ✅ Consistent code style across all features
- ✅ Proper error handling in every BLoC
- ✅ Comprehensive widget refactoring
- ✅ Zero warnings/errors in flutter analyze
- ✅ Clean Architecture principles maintained throughout

---

## 🚀 How to Run

### Prerequisites

- **Flutter SDK**: 3.9.2 or higher
- **Dart SDK**: 3.9.2 or higher
- **Android Studio** / **VS Code** with Flutter extensions
- **OpenWeatherMap API Key**: Get free key from https://openweathermap.org/api

### Setup Instructions

1. **Clone the Repository**

   ```bash
   git clone https://github.com/YOUR_USERNAME/skysentinel.git
   cd skysentinel
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure API Key**

   Update the API key in `lib/core/constants/api_constants.dart`:

   ```dart
   class ApiConstants {
     static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
     static const String apiKey = 'YOUR_API_KEY_HERE'; // Replace with your key
   }
   ```

4. **Run the App**

   ```bash
   # Run on connected device or emulator
   flutter run

   # Run in debug mode
   flutter run --debug

   # Run in release mode
   flutter run --release
   ```

5. **Build Release APK** (Optional)

   ```bash
   flutter build apk --release
   ```

   The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

### Platform-Specific Setup

**Android:**

- All permissions are already configured in `AndroidManifest.xml`
- Minimum SDK: 21 (Android 5.0)

**iOS:**

- Run `cd ios && pod install`
- Update `Info.plist` with location permissions

**Web:**

- Geolocation requires HTTPS in production

---

## 📸 Screenshots

| Weather Dashboard                       | 5-Day Forecast                        | Alert Settings                        | Weather Alert                   |
| --------------------------------------- | ------------------------------------- | ------------------------------------- | ------------------------------- |
| ![Dashboard](screenshots/dashboard.png) | ![Forecast](screenshots/forecast.png) | ![Settings](screenshots/settings.png) | ![Alert](screenshots/alert.png) |

### Key UI Features

- **Dark Theme**: Background `#0A0E1A`, Cards `#1A1F2E`
- **Weather Icons**: Dynamic icons from OpenWeatherMap API
- **Pull-to-Refresh**: All data screens support refresh
- **Dismissible Alerts**: Swipe to dismiss weather alerts
- **Responsive Grid**: 2x2 weather stats layout

---

## 📦 Dependencies

### Core Dependencies

| Package                       | Version  | Purpose                              |
| ----------------------------- | -------- | ------------------------------------ |
| `flutter_bloc`                | ^9.1.1   | State management                     |
| `equatable`                   | ^2.0.5   | Value comparison for entities/states |
| `http`                        | ^1.2.1   | HTTP client for API calls            |
| `geolocator`                  | ^14.0.2  | Device location services             |
| `permission_handler`          | ^12.0.1  | Runtime permissions                  |
| `shared_preferences`          | ^2.3.2   | Local data caching                   |
| `flutter_local_notifications` | ^20.1.0  | Push notifications                   |
| `workmanager`                 | ^0.9.0+3 | Background task scheduling           |
| `get_it`                      | ^9.2.1   | Dependency injection                 |
| `intl`                        | ^0.20.2  | Date/time formatting                 |

### Dev Dependencies

| Package         | Version | Purpose                  |
| --------------- | ------- | ------------------------ |
| `bloc_test`     | ^10.0.0 | BLoC unit testing        |
| `mocktail`      | ^1.0.4  | Mock objects for testing |
| `flutter_lints` | ^6.0.0  | Linting rules            |

---

## 🧪 Testing

### Run Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/weather_bloc_test.dart
```

### Test Coverage

- ✅ BLoC state transitions
- ✅ Repository cache fallback logic
- ✅ Alert threshold checking
- ✅ Date/time formatting utilities
- ✅ Error handling scenarios

---

## 📁 Project Structure

```
intelligent_machine_task/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── app.dart                     # MaterialApp configuration
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart   # API base URL, keys
│   │   │   └── app_strings.dart     # App-wide strings
│   │   ├── di/
│   │   │   └── injection_container.dart  # get_it setup
│   │   ├── errors/
│   │   │   ├── exceptions.dart      # Custom exceptions
│   │   │   └── failures.dart        # Failure classes
│   │   ├── network/
│   │   │   └── http_client.dart     # HTTP wrapper
│   │   ├── theme/
│   │   │   └── app_theme.dart       # Dark theme
│   │   └── utils/
│   │       ├── date_formatter.dart
│   │       └── weather_icon_mapper.dart
│   │
│   ├── features/
│   │   ├── weather/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── weather_remote_datasource.dart
│   │   │   │   │   └── weather_local_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── current_weather_model.dart
│   │   │   │   │   └── forecast_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── weather_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── current_weather.dart
│   │   │   │   │   └── forecast.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── weather_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_current_weather.dart
│   │   │   │       └── get_forecast.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── weather_bloc.dart
│   │   │       │   ├── weather_event.dart
│   │   │       │   └── weather_state.dart
│   │   │       ├── pages/
│   │   │       │   └── weather_dashboard_page.dart
│   │   │       └── widgets/
│   │   │           ├── current_weather_card.dart
│   │   │           ├── weather_stat_tile.dart
│   │   │           ├── alert_banner_widget.dart
│   │   │           ├── weather_stats_grid.dart
│   │   │           └── hourly_outlook_section.dart
│   │   │
│   │   ├── forecast/
│   │   │   ├── presentation/
│   │   │   │   ├── bloc/
│   │   │   │   ├── pages/
│   │   │   │   │   └── forecast_page.dart
│   │   │   │   └── widgets/
│   │   │   │       └── forecast_day_tile.dart
│   │   │   └── ...
│   │   │
│   │   ├── location/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/bloc/
│   │   │
│   │   ├── settings/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       ├── pages/
│   │   │       │   └── settings_page.dart
│   │   │       └── widgets/
│   │   │           ├── threshold_slider_tile.dart
│   │   │           └── alert_switch_tile.dart
│   │   │
│   │   └── alert/
│   │       ├── domain/usecases/
│   │       │   └── check_alert_threshold.dart
│   │       └── presentation/
│   │           ├── pages/
│   │           │   └── alert_detail_page.dart
│   │           └── widgets/
│   │               ├── alert_icon_widget.dart
│   │               ├── alert_message_card.dart
│   │               ├── alert_detail_card.dart
│   │               └── alert_action_buttons.dart
│   │
│   └── shared/widgets/
│       ├── loading_indicator.dart
│       ├── error_message_widget.dart
│       └── bottom_nav_bar.dart
│
├── android/
├── ios/
├── test/
├── pubspec.yaml
└── README.md
```

---

## 🔧 Configuration

### Android Permissions

Already configured in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

### Notification Channels

- **Channel ID**: `high_importance_channel`
- **Channel Name**: SkySentinel Alerts
- **Importance**: High
- **Background Task**: Every 15 minutes via WorkManager

---

## 📊 Code Statistics

| Metric                  | Count        |
| ----------------------- | ------------ |
| **Total Dart Files**    | 50+          |
| **Total Lines of Code** | ~4,500       |
| **BLoCs**               | 4            |
| **Use Cases**           | 6            |
| **Repositories**        | 4            |
| **Widgets**             | 20+          |
| **flutter analyze**     | ✅ No issues |

---

## 🎯 Future Enhancements

- [ ] Weather maps integration
- [ ] Multiple location support
- [ ] Weather radar animations
- [ ] Widget support (home screen)
- [ ] Weather history charts
- [ ] Severe weather warnings
- [ ] Multi-language support (i18n)
- [ ] Light theme option

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Muhammad Fazlul Karim**

- GitHub: [@YOUR_GITHUB](https://github.com/YOUR_GITHUB)
- Email: your.email@example.com

---

## 🙏 Acknowledgments

- **OpenWeatherMap**: Free weather API
- **Flutter Team**: Amazing framework
- **Qoder AI**: AI-assisted development
- **Bloc Library**: State management solution

---

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/YOUR_GITHUB/skysentinel/issues) page
2. Create a new issue with detailed description
3. Contact via email

---

**⭐ If you find this project helpful, please give it a star on GitHub!**
