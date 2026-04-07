import 'package:flutter/material.dart';
import '../../domain/entities/alert_result.dart';

/// Alert details card showing triggered factor and status
class AlertDetailCard extends StatelessWidget {
  final AlertResult alertResult;

  const AlertDetailCard({super.key, required this.alertResult});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alert Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _DetailRow('Triggered By', _getTriggeredFactorLabel()),
          const SizedBox(height: 8),
          _DetailRow('Status', 'Active'),
        ],
      ),
    );
  }

  String _getTriggeredFactorLabel() {
    switch (alertResult.triggeredFactor) {
      case 'temperature':
        return 'Temperature Threshold';
      case 'rain':
        return 'Rainfall Threshold';
      default:
        return 'Unknown';
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade400)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
