import 'package:equatable/equatable.dart';

/// Result of alert threshold check
class AlertResult extends Equatable {
  final bool isTriggered; // Whether any alert threshold is exceeded
  final String
  triggeredFactor; // What triggered the alert (e.g., 'temperature', 'rain')
  final String message; // User-friendly alert message

  const AlertResult({
    required this.isTriggered,
    required this.triggeredFactor,
    required this.message,
  });

  /// Creates a non-triggered alert result
  factory AlertResult.noAlert() {
    return const AlertResult(
      isTriggered: false,
      triggeredFactor: '',
      message: '',
    );
  }

  /// Creates a temperature alert
  factory AlertResult.temperatureAlert(double temperature, double threshold) {
    return AlertResult(
      isTriggered: true,
      triggeredFactor: 'temperature',
      message:
          'High temperature alert! Current: ${temperature.toStringAsFixed(1)}°C exceeds threshold of ${threshold.toStringAsFixed(1)}°C',
    );
  }

  /// Creates a rain alert
  factory AlertResult.rainAlert(double rainMm, double threshold) {
    return AlertResult(
      isTriggered: true,
      triggeredFactor: 'rain',
      message:
          'Rain detected! ${rainMm.toStringAsFixed(1)}mm rainfall exceeds threshold of ${threshold.toStringAsFixed(1)}mm',
    );
  }

  @override
  List<Object?> get props => [isTriggered, triggeredFactor, message];
}
