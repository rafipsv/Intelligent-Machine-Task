import 'package:equatable/equatable.dart';

/// Current weather entity (pure domain object, no JSON)
class CurrentWeatherEntity extends Equatable {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final double? rain1h;
  final String cityName;
  final DateTime updatedAt;

  const CurrentWeatherEntity({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    this.rain1h,
    required this.cityName,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    temperature,
    feelsLike,
    humidity,
    windSpeed,
    description,
    icon,
    rain1h,
    cityName,
    updatedAt,
  ];
}
