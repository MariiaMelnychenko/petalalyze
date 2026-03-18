import 'package:dio/dio.dart';

import 'api_client.dart';

/// Abstraction over HTTP client for dependency injection.
/// Wraps Dio to provide HTTP client to datasources.
class NetworkClient {
  NetworkClient({Dio? dio}) : _dio = dio ?? ApiClient.client.dio;

  final Dio _dio;

  Dio get dio => _dio;
}
