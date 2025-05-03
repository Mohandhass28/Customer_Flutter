import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

import 'interceptors.dart';

class DioClient {
  late final Dio _dio;
  late final SharedPreferences _sharedPrefs;
  static const int maxRetries = 3;

  DioClient({
    required SharedPreferences sharedPrefs,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _sharedPrefs = sharedPrefs;
    String? baseUrl;
    try {
      baseUrl = dotenv.env['BASE_URL'];
      debugPrint('Loaded BASE_URL from .env: $baseUrl');
    } catch (e) {
      debugPrint('Error loading .env file: $e');
      // Hardcoded fallback URL for release builds
      baseUrl = 'http://13.235.24.176:7600/mobile-api/';
    }

    // Ensure we always have a base URL
    if (baseUrl == null || baseUrl.isEmpty) {
      baseUrl = 'http://13.235.24.176:7600/mobile-api/';
      debugPrint('Using fallback BASE_URL: $baseUrl');
    }

    _dio.options = BaseOptions(
      baseUrl: baseUrl, // baseUrl is guaranteed to be non-null at this point
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    );

    _dio.interceptors.addAll([
      LoggerInterceptor(),
      RefreshTokenInterceptor(_dio, _sharedPrefs),
    ]);
  }

  Future<Response> _executeRequest(Future<Response> Function() request) async {
    int retryCount = 0;
    while (true) {
      try {
        return await request();
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          // Let the RefreshTokenInterceptor handle it
          rethrow;
        }

        if (retryCount >= maxRetries) {
          rethrow;
        }

        // Retry on network errors with exponential backoff
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          retryCount++;
          final waitTime =
              Duration(milliseconds: pow(2, retryCount).toInt() * 1000);
          await Future.delayed(waitTime);
          continue;
        }
        rethrow;
      }
    }
  }

  Future<Response> get({
    required String endpoint,
    Map<String, dynamic>? params,
    FormData? data,
    Options? options,
  }) async {
    return _executeRequest(() => _dio.get(
          endpoint,
          queryParameters: params,
          data: data,
          options: options,
        ));
  }

  Future<Response> post({
    required String endpoint,
    Map<String, dynamic>? params,
    FormData? data,
    Options? options,
  }) async {
    return _executeRequest(() => _dio.post(
          endpoint,
          data: params ?? data,
          options: options,
        ));
  }
}
