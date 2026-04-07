import 'package:equatable/equatable.dart';
import '../../domain/entities/current_weather.dart';

/// Base state for Weather feature
abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

/// Loading state when fetching weather
class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

/// Loaded state with weather data
class WeatherLoaded extends WeatherState {
  final CurrentWeatherEntity weather;

  const WeatherLoaded(this.weather);

  @override
  List<Object?> get props => [weather];
}

/// Error state when weather fetch fails
class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}
