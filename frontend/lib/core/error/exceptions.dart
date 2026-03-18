/// Base exception for API errors
class ServerException implements Exception {
  ServerException([this.message]);

  final String? message;

  @override
  String toString() => 'ServerException: $message';
}

/// Exception when no network connection
class NetworkException implements Exception {
  NetworkException([this.message]);

  final String? message;

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception for cache/local storage errors
class CacheException implements Exception {
  CacheException([this.message]);

  final String? message;

  @override
  String toString() => 'CacheException: $message';
}
