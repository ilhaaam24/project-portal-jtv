
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = 'Server error occurred', this.statusCode});

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'No internet connection'});

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message = 'Cache error occurred'});

  @override
  String toString() => 'CacheException: $message';
}
