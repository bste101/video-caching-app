class ServerException implements Exception {
  final String? message;
  final int? statusCode;

  const ServerException({this.message, this.statusCode});
}

class CacheException implements Exception {
  final String? message;

  const CacheException({this.message});
}

class AuthException implements Exception {
  final String message;
  final String? provider;

  const AuthException({required this.message, this.provider});
}