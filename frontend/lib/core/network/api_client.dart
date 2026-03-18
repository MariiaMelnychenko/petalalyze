import 'package:dio/dio.dart';

import 'dio_client.dart';

/// Singleton API client for the application
/// Use this to make API calls from repositories/datasources
class ApiClient {
  ApiClient._();

  static ApiClient? _instance;
  static DioClient? _dioClient;

  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  /// Initialize with optional custom base URL
  static void init({String? baseUrl}) {
    _dioClient = DioClient(baseUrl: baseUrl);
  }

  static Dio get dio {
    _dioClient ??= DioClient();
    return _dioClient!.dio;
  }

  static DioClient get client {
    _dioClient ??= DioClient();
    return _dioClient!;
  }
}
