import 'package:flutter/material.dart';
import '../../domain/entities/alert_result.dart';
import '../widgets/alert_icon_widget.dart';
import '../widgets/alert_message_card.dart';
import '../widgets/alert_detail_card.dart';
import '../widgets/alert_action_buttons.dart';

/// Alert detail page showing alert information
class AlertDetailPage extends StatelessWidget {
  final AlertResult alertResult;

  const AlertDetailPage({super.key, required this.alertResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Alert'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),

            // Alert Icon
            AlertIconWidget(alertResult: alertResult),

            const SizedBox(height: 24),

            // Alert Title
            Text(
              _getAlertTitle(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Alert Message
            AlertMessageCard(alertResult: alertResult),

            const SizedBox(height: 32),

            // Alert Details
            AlertDetailCard(alertResult: alertResult),

            const Spacer(),

            // Action Buttons
            AlertActionButtons(
              onViewDashboard: () => Navigator.of(context).pop(),
              onDismiss: () => Navigator.of(context).pop(),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Gets the alert title based on triggered factor
  String _getAlertTitle() {
    switch (alertResult.triggeredFactor) {
      case 'temperature':
        return 'High Temperature!';
      case 'rain':
        return 'Rain Detected!';
      default:
        return 'Weather Alert';
    }
  }
}
