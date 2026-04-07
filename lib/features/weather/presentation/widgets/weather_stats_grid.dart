import 'package:flutter/material.dart';
import '../../../weather/domain/entities/current_weather.dart';
import '../../../weather/presentation/widgets/weather_stat_tile.dart';

/// Grid widget displaying weather statistics (humidity, wind, feels like, update time)
class WeatherStatsGrid extends StatelessWidget {
  final CurrentWeatherEntity weather;

  const WeatherStatsGrid({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weather Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            WeatherStatTile(
              icon: Icons.water_drop,
              label: 'Humidity',
              value: '${weather.humidity}',
              unit: '%',
            ),
            WeatherStatTile(
              icon: Icons.air,
              label: 'Wind Speed',
              value: weather.windSpeed.toStringAsFixed(1),
              unit: ' m/s',
            ),
            WeatherStatTile(
              icon: Icons.thermostat,
              label: 'Feels Like',
              value: weather.feelsLike.toStringAsFixed(1),
              unit: '°C',
            ),
            WeatherStatTile(
              icon: Icons.update,
              label: 'Updated',
              value:
                  '${weather.updatedAt.hour}:${weather.updatedAt.minute.toString().padLeft(2, '0')}',
              unit: '',
            ),
          ],
        ),
      ],
    );
  }
}
