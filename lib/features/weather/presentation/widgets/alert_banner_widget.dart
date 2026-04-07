import 'package:flutter/material.dart';
import '../../../alert/domain/entities/alert_result.dart';
import '../../../alert/domain/usecases/check_alert_threshold.dart';
import '../../../alert/presentation/pages/alert_detail_page.dart';
import '../../../settings/domain/entities/alert_settings.dart';
import '../../../weather/domain/entities/current_weather.dart';

/// Dismissible alert banner shown when weather thresholds are exceeded
class AlertBannerWidget extends StatelessWidget {
  final CurrentWeatherEntity weather;
  final CheckAlertThreshold checkAlertThreshold;

  const AlertBannerWidget({
    super.key,
    required this.weather,
    required this.checkAlertThreshold,
  });

  @override
  Widget build(BuildContext context) {
    final settings = const AlertSettingsEntity();
    final alertResult = checkAlertThreshold(
      weather: weather,
      settings: settings,
    );

    if (!alertResult.isTriggered) {
      return const SizedBox.shrink();
    }

    return _AlertBanner(
      alertResult: alertResult,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AlertDetailPage(alertResult: alertResult),
          ),
        );
      },
    );
  }
}

class _AlertBanner extends StatelessWidget {
  final AlertResult alertResult;
  final VoidCallback onTap;

  const _AlertBanner({required this.alertResult, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('alert_${alertResult.triggeredFactor}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.orange,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {},
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.orange.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weather Alert',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alertResult.message,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
