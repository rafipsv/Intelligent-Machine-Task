import 'package:equatable/equatable.dart';
import '../../../weather/domain/entities/forecast.dart';

/// Base state for Forecast feature
abstract class ForecastState extends Equatable {
  const ForecastState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ForecastInitial extends ForecastState {
  const ForecastInitial();
}

/// Loading state when fetching forecast
class ForecastLoading extends ForecastState {
  const ForecastLoading();
}

/// Loaded state with forecast data
class ForecastLoaded extends ForecastState {
  final List<ForecastDayEntity> forecast;

  const ForecastLoaded(this.forecast);

  @override
  List<Object?> get props => [forecast];
}

/// Error state when forecast fetch fails
class ForecastError extends ForecastState {
  final String message;

  const ForecastError(this.message);

  @override
  List<Object?> get props => [message];
}
