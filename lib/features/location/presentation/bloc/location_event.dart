import 'package:equatable/equatable.dart';

/// Base event for Location feature
abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch current location
class FetchLocationEvent extends LocationEvent {
  const FetchLocationEvent();
}
