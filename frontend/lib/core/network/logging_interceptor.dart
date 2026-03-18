import 'dart:developer';

import 'package:dio/dio.dart';

/// Interceptor for logging HTTP requests and responses in development mode
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('╔══════════════════════════════════════════════════════════════');
    log('║ REQUEST: ${options.method} ${options.uri}');
    log('╠══════════════════════════════════════════════════════════════');
    log('║ Headers:');
    options.headers.forEach((key, value) {
      log('║   $key: $value');
    });
    if (options.queryParameters.isNotEmpty) {
      log('║ Query Parameters:');
      options.queryParameters.forEach((key, value) {
        log('║   $key: $value');
      });
    }
    if (options.data != null) {
      log('║ Body:');
      log('║   ${options.data}');
    }
    log('╚══════════════════════════════════════════════════════════════\n');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('╔══════════════════════════════════════════════════════════════');
    log('║ RESPONSE: ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}');
    log('╠══════════════════════════════════════════════════════════════');
    log('║ Headers:');
    response.headers.map.forEach((key, value) {
      log('║   $key: $value');
    });
    log('║ Body:');
    log('║   ${response.data}');
    log('╚══════════════════════════════════════════════════════════════\n');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('╔══════════════════════════════════════════════════════════════');
    log('║ ERROR: ${err.requestOptions.method} ${err.requestOptions.uri}');
    log('╠══════════════════════════════════════════════════════════════');
    log('║ Type: ${err.type}');
    log('║ Message: ${err.message}');
    if (err.response != null) {
      log('║ Status Code: ${err.response?.statusCode}');
      log('║ Response Data: ${err.response?.data}');
    }
    log('╚══════════════════════════════════════════════════════════════\n');
    handler.next(err);
  }
}
