import 'package:equatable/equatable.dart';

/// Base event for Forecast feature
abstract class ForecastEvent extends Equatable {
  const ForecastEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch forecast data for specific coordinates
class FetchForecastEvent extends ForecastEvent {
  final double latitude;
  final double longitude;

  const FetchForecastEvent({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}
