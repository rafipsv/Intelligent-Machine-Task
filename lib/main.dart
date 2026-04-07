import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/di/injection_container.dart' as di;
import 'features/alert/domain/usecases/check_alert_threshold.dart';
import 'features/alert/domain/entities/alert_result.dart';
import 'features/settings/domain/entities/alert_settings.dart';
import 'features/weather/domain/entities/current_weather.dart';
import 'features/weather/data/models/current_weather_model.dart';
import 'features/alert/presentation/pages/alert_detail_page.dart';

// Global notification instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Notification tap callback (Step 10.2)
void onNotificationTap(NotificationResponse response) {
  // Handle notification tap - navigate to alert detail page
  if (response.payload == 'alert_detail') {
    // Create a default alert result for demonstration
    // In production, you'd retrieve the actual alert data from shared preferences
    final alertResult = AlertResult.temperatureAlert(
      35.0, // Example temperature
      30.0, // Example threshold
    );

    // Navigate to alert detail page using global navigator key
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => AlertDetailPage(alertResult: alertResult),
      ),
    );
  }
}

// Top-level function for WorkManager callback
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Initialize required services
      final prefs = await SharedPreferences.getInstance();

      // Get cached weather data
      final cachedWeatherJson = prefs.getString('cached_current_weather');
      if (cachedWeatherJson == null) {
        developer.log('No cached weather data available');
        return true;
      }

      // Parse weather from JSON (manual parsing since we can't use DI in background)
      // This is simplified - in production you'd want proper JSON parsing
      final weather = _parseWeatherFromCache(prefs);
      if (weather == null) {
        developer.log('Failed to parse cached weather');
        return true;
      }

      // Get settings
      final settings = _getSettingsFromCache(prefs);

      // Check alert threshold
      final checkAlert = CheckAlertThreshold();
      final alertResult = checkAlert(weather: weather, settings: settings);

      // Show notification if alert is triggered
      if (alertResult.isTriggered) {
        await _showBackgroundNotification(alertResult);
        developer.log('Alert notification shown: ${alertResult.message}');
      }

      return true;
    } catch (e) {
      developer.log('Background task error', error: e);
      return false;
    }
  });
}

// Helper: Parse weather from SharedPreferences
CurrentWeatherEntity? _parseWeatherFromCache(SharedPreferences prefs) {
  try {
    final cachedWeatherJson = prefs.getString('cached_current_weather');
    if (cachedWeatherJson == null) {
      return null;
    }

    // Parse JSON string to Map
    final Map<String, dynamic> json = jsonDecode(cachedWeatherJson);

    // Parse model from JSON
    final model = CurrentWeatherModel.fromJson(json);

    // Convert model to entity
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
  } catch (e) {
    developer.log('Error parsing weather cache', error: e);
    return null;
  }
}

// Helper: Get settings from SharedPreferences
AlertSettingsEntity _getSettingsFromCache(SharedPreferences prefs) {
  return AlertSettingsEntity(
    tempThreshold: prefs.getDouble('temp_threshold') ?? 30.0,
    alertOnRain: prefs.getBool('alert_on_rain') ?? true,
    rainThreshold: prefs.getDouble('rain_threshold') ?? 0.1,
    alertOnHighUV: prefs.getBool('alert_on_high_uv') ?? true,
    uvThreshold: prefs.getDouble('uv_threshold') ?? 7.0,
  );
}

// Helper: Show notification from background
Future<void> _showBackgroundNotification(AlertResult alert) async {
  const androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'SkySentinel Alerts',
    channelDescription: 'Weather alert notifications',
    importance: Importance.high,
    priority: Priority.high,
    showWhen: true,
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    id: 0,
    title: 'Weather Alert',
    body: alert.message,
    notificationDetails: notificationDetails,
    payload: 'alert_detail',
  );
}

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  // Initialize local notifications (Step 10.1)
  const androidInitSettings = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );
  const initializationSettings = InitializationSettings(
    android: androidInitSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: onNotificationTap,
    onDidReceiveBackgroundNotificationResponse: onNotificationTap,
  );

  // Initialize workmanager (Step 10.3)
  await Workmanager().initialize(callbackDispatcher);

  // Register periodic task for weather checking every 15 minutes
  await Workmanager().registerPeriodicTask(
    'weather-check',
    'weatherBackgroundFetch',
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const SkySentinelApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
