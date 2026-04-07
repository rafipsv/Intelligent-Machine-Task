import 'package:equatable/equatable.dart';

/// Forecast item entity (pure domain object)
class ForecastEntity extends Equatable {
  final DateTime dateTime;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final double? rain3h;

  const ForecastEntity({
    required this.dateTime,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    this.rain3h,
  });

  @override
  List<Object?> get props => [
    dateTime,
    temperature,
    feelsLike,
    humidity,
    windSpeed,
    description,
    icon,
    rain3h,
  ];
}

/// Daily forecast entity (aggregated from hourly items)
class ForecastDayEntity extends Equatable {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String description;
  final String icon;
  final List<ForecastEntity> hourlyItems;

  const ForecastDayEntity({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.description,
    required this.icon,
    required this.hourlyItems,
  });

  @override
  List<Object?> get props => [
    date,
    minTemp,
    maxTemp,
    description,
    icon,
    hourlyItems,
  ];
}
