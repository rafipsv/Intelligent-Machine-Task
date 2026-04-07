import 'package:equatable/equatable.dart';

/// Entity representing user's alert settings and thresholds
class AlertSettingsEntity extends Equatable {
  final double tempThreshold; // Temperature threshold in °C (e.g., 30.0)
  final bool alertOnRain; // Enable/disable rain alerts
  final double rainThreshold; // Rain threshold in mm (e.g., 0.1)
  final bool alertOnHighUV; // Enable/disable UV alerts
  final double uvThreshold; // UV threshold (e.g., 7.0)

  const AlertSettingsEntity({
    this.tempThreshold = 30.0,
    this.alertOnRain = true,
    this.rainThreshold = 0.1,
    this.alertOnHighUV = true,
    this.uvThreshold = 7.0,
  });

  /// Creates a copy with modified fields
  AlertSettingsEntity copyWith({
    double? tempThreshold,
    bool? alertOnRain,
    double? rainThreshold,
    bool? alertOnHighUV,
    double? uvThreshold,
  }) {
    return AlertSettingsEntity(
      tempThreshold: tempThreshold ?? this.tempThreshold,
      alertOnRain: alertOnRain ?? this.alertOnRain,
      rainThreshold: rainThreshold ?? this.rainThreshold,
      alertOnHighUV: alertOnHighUV ?? this.alertOnHighUV,
      uvThreshold: uvThreshold ?? this.uvThreshold,
    );
  }

  @override
  List<Object?> get props => [
    tempThreshold,
    alertOnRain,
    rainThreshold,
    alertOnHighUV,
    uvThreshold,
  ];
}
