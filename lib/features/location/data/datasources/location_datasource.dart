import 'package:geolocator/geolocator.dart';
import '../../../../core/errors/exceptions.dart';

/// Data source for location operations using Geolocator
class LocationDataSource {
  /// Gets current device position
  /// Throws [LocationException] if permission denied or location unavailable
  Future<Position> getCurrentPosition() async {
    try {
      // Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          throw const LocationException(message: 'Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw const LocationException(
          message:
              'Location permissions are permanently denied. Please enable in settings.',
        );
      }

      // Check if location services are enabled
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw const LocationException(
          message:
              'Location services are disabled. Please enable location services.',
        );
      }

      // Get current position with high accuracy
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } on LocationException {
      rethrow;
    } catch (e) {
      throw LocationException(
        message: 'Failed to get location: ${e.toString()}',
      );
    }
  }
}
