import 'package:flutter/material.dart';

/// Section widget for hourly weather outlook (placeholder for future implementation)
class HourlyOutlookSection extends StatelessWidget {
  const HourlyOutlookSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hourly Outlook',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Text('Coming soon...', textAlign: TextAlign.center),
      ],
    );
  }
}
