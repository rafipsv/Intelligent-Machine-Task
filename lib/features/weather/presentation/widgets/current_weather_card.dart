import 'package:flutter/material.dart';
import '../../domain/entities/current_weather.dart';
import '../../../../../core/utils/date_formatter.dart';

/// Current weather card showing main weather information
class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeatherEntity weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // City name
          Text(
            weather.cityName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // Weather icon and temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Weather icon
              Image.network(
                'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.cloud, size: 80, color: Colors.grey);
                },
              ),

              const SizedBox(width: 16),

              // Temperature
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weather.temperature.toStringAsFixed(1)}°',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Feels like ${weather.feelsLike.toStringAsFixed(1)}°C',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 8),

          // Updated time
          Text(
            'Updated ${DateFormatter.getTimeAgo(weather.updatedAt)}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
