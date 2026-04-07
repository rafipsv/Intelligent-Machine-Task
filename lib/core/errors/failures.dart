import 'package:equatable/equatable.dart';

/// Abstract base class for all failures
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => '$runtimeType: $message';
}

/// Failure for server/network errors
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred. Please try again later.',
  });
}

/// Failure for cache/local storage errors
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error occurred. Please clear app data.',
  });
}

/// Failure for location errors
class LocationFailure extends Failure {
  const LocationFailure({
    super.message = 'Unable to get location. Please enable location services.',
  });
}
