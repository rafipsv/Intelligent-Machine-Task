import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';

/// Use case for getting current device location
class GetCurrentLocation {
  final LocationRepository repository;

  GetCurrentLocation({required this.repository});

  /// Executes the use case and returns current location
  Future<LocationEntity> call() async {
    return await repository.getCurrentLocation();
  }
}
