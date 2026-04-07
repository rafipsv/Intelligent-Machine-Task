import 'package:flutter/material.dart';
import '../../../weather/domain/entities/forecast.dart';
import '../../../../../core/utils/date_formatter.dart';

/// Forecast day tile showing daily weather summary
class ForecastDayTile extends StatelessWidget {
  final ForecastDayEntity forecast;

  const ForecastDayTile({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Date
          SizedBox(
            width: 100,
            child: Text(
              DateFormatter.formatDate(forecast.date),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(width: 16),

          // Weather icon
          Image.network(
            'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
            width: 50,
            height: 50,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.cloud, size: 40, color: Colors.grey);
            },
          ),

          const SizedBox(width: 16),

          // Description
          Expanded(
            child: Text(
              forecast.description,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 16),

          // Temperature
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${forecast.maxTemp.toStringAsFixed(0)}°',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${forecast.minTemp.toStringAsFixed(0)}°',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
