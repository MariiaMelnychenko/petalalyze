/// API configuration constants
class ApiEndpoints {
  ApiEndpoints._();

  /// Base URL for API. Фізичний пристрій — IP комп'ютера в мережі.
  static const String baseUrl = 'http://192.168.31.242:8000';

  /// API endpoints
  static const String health = '/health';
  static const String flowers = '/flowers';
  static const String detections = '/detections';
  static const String detect = '/detect';

  /// Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
