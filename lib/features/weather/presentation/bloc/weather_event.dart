import 'package:equatable/equatable.dart';

/// Base event for Weather feature
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch weather data for specific coordinates
class FetchWeatherEvent extends WeatherEvent {
  final double latitude;
  final double longitude;

  const FetchWeatherEvent({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}
