import 'package:flutter/material.dart';
import '../../domain/entities/alert_result.dart';

/// Alert icon widget with dynamic color based on alert type
class AlertIconWidget extends StatelessWidget {
  final AlertResult alertResult;

  const AlertIconWidget({super.key, required this.alertResult});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.warning_amber_rounded,
      size: 80,
      color: Colors.orange.shade700,
    );
  }
}
