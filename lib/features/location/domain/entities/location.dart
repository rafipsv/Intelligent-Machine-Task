import 'package:equatable/equatable.dart';

/// Location entity representing geographic coordinates
class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  final String? cityName;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.cityName,
  });

  @override
  List<Object?> get props => [latitude, longitude, cityName];

  @override
  String toString() {
    return 'LocationEntity(lat: $latitude, lon: $longitude, city: $cityName)';
  }
}
