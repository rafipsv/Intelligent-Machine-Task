/// Exception thrown when there's a server/network error
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    this.message = 'Server error occurred',
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Exception thrown when there's a cache/local storage error
class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Cache error occurred'});

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when there's a location error
class LocationException implements Exception {
  final String message;

  const LocationException({this.message = 'Location error occurred'});

  @override
  String toString() => 'LocationException: $message';
}
