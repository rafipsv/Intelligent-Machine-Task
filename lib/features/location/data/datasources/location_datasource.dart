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

      // Try to get last known position first (faster and more reliable on emulator)
      Position? lastPosition = await Geolocator.getLastKnownPosition();

      if (lastPosition != null) {
        return lastPosition;
      }

      // Get current position with medium accuracy for emulator stability
      // Use timeLimit to prevent hanging
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
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
