import 'package:flutter/material.dart';

/// Weather stat tile showing humidity, wind speed, etc.
class WeatherStatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;

  const WeatherStatTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF4A90E2), size: 32),
          const SizedBox(height: 8),
          Text(
            '$value$unit',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
