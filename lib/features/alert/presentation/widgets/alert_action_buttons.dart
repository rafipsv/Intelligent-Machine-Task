import 'package:flutter/material.dart';

/// Alert action buttons (View Dashboard and Dismiss)
class AlertActionButtons extends StatelessWidget {
  final VoidCallback onViewDashboard;
  final VoidCallback onDismiss;

  const AlertActionButtons({
    super.key,
    required this.onViewDashboard,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onViewDashboard,
          icon: const Icon(Icons.dashboard),
          label: const Text('View Full Dashboard'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onDismiss,
          icon: const Icon(Icons.close),
          label: const Text('Dismiss Alert'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
