import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_datasource.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';

/// Implementation of LocationRepository
class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl({required this.dataSource});

  @override
  Future<LocationEntity> getCurrentLocation() async {
    try {
      final position = await dataSource.getCurrentPosition();

      return LocationEntity(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on LocationException catch (e) {
      throw LocationFailure(message: e.message);
    } catch (e) {
      throw LocationFailure(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }
}
