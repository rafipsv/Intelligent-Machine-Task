import 'package:flutter/material.dart';
import '../../domain/entities/forecast.dart';
import '../../../../../core/utils/date_formatter.dart';

/// Hourly outlook widget with horizontal scroll
class HourlyOutlookWidget extends StatelessWidget {
  final List<ForecastEntity> hourlyItems;

  const HourlyOutlookWidget({super.key, required this.hourlyItems});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyItems.length,
        itemBuilder: (context, index) {
          final item = hourlyItems[index];
          return _HourlyItemCard(
            time: DateFormatter.formatTime(item.dateTime),
            icon: item.icon,
            temperature: item.temperature,
          );
        },
      ),
    );
  }
}

class _HourlyItemCard extends StatelessWidget {
  final String time;
  final String icon;
  final double temperature;

  const _HourlyItemCard({
    required this.time,
    required this.icon,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            time,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
          ),
          Image.network(
            'https://openweathermap.org/img/wn/$icon.png',
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.cloud, size: 32, color: Colors.grey);
            },
          ),
          Text(
            '${temperature.toStringAsFixed(0)}°',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
