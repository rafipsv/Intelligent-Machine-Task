import 'package:equatable/equatable.dart';
import '../../domain/entities/location.dart';

/// Base state for Location feature
abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class LocationInitial extends LocationState {
  const LocationInitial();
}

/// Loading state when fetching location
class LocationLoading extends LocationState {
  const LocationLoading();
}

/// Loaded state with location data
class LocationLoaded extends LocationState {
  final LocationEntity location;

  const LocationLoaded(this.location);

  @override
  List<Object?> get props => [location];
}

/// Error state when location fetch fails
class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}
