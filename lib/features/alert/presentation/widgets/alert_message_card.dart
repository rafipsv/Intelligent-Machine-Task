import 'package:flutter/material.dart';
import '../../domain/entities/alert_result.dart';

/// Alert message card displaying the alert description
class AlertMessageCard extends StatelessWidget {
  final AlertResult alertResult;

  const AlertMessageCard({super.key, required this.alertResult});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        alertResult.message,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }
}
