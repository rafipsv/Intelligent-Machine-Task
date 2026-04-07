import '../entities/location.dart';

/// Abstract repository for location operations
abstract class LocationRepository {
  /// Gets the current device location
  /// Throws exception if permission denied or location unavailable
  Future<LocationEntity> getCurrentLocation();
}
