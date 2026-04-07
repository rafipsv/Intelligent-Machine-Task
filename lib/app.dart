import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/weather/presentation/pages/weather_dashboard_page.dart';
import 'features/forecast/presentation/pages/forecast_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'shared/widgets/bottom_nav_bar.dart';

// Global navigator key for notification handling
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Main application widget with BLoC providers and navigation
class SkySentinelApp extends StatefulWidget {
  const SkySentinelApp({super.key});

  @override
  State<SkySentinelApp> createState() => _SkySentinelAppState();
}

class _SkySentinelAppState extends State<SkySentinelApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    WeatherDashboardPage(),
    ForecastPage(),
    SettingsPage(),
  ];

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkySentinel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onTabChanged,
        ),
      ),
    );
  }
}
