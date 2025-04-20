import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'interceptors.dart';

class DioClient {
  late final Dio _dio;
  late final _sharedPrefs;

  DioClient({
    required sharedPrefs,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _sharedPrefs = sharedPrefs;
    String? baseUrl;
    try {
      baseUrl = dotenv.env['BASE_URL'];
    } catch (e) {
      // Default value for tests
      baseUrl = 'https://mock-api.com';
    }
    print('Base URL: $baseUrl');
    _dio.options = BaseOptions(
      baseUrl: baseUrl ?? '',
    );

    _dio.interceptors.addAll(
      [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            print('Request: ${options.method} ${options.uri}');
            final String token = _sharedPrefs.getString('token') ?? '';
            options.headers['Authorization'] = token;
            return handler.next(options);
          },
          onResponse: (response, handler) {
            print('Response: ${response.statusCode} ${response.data}');
            return handler.next(response);
          },
          onError: (error, handler) {
            print('Error: ${error.message}');
            return handler.next(error);
          },
        ),
        LoggerInterceptor(),
      ],
    );
  }

  Future<Response> get({
    required String endpoint,
    Map<String, dynamic>? params,
    FormData? data,
    Options? options,
  }) async {
    try {
      Response response;
      response = await _dio.get(
        endpoint,
        data: params ?? data,
        queryParameters: params,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      print('Error Response: ${e.response?.data}');
      print('Error Status: ${e.response?.statusCode}');
      rethrow;
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }

  Future<Response> post({
    required String endpoint,
    Map<String, dynamic>? params,
    FormData? data,
    Options? options,
  }) async {
    try {
      Response response;
      response = await _dio.post(
        endpoint,
        queryParameters: params,
        data: params ?? data,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      print('Error Response: ${e.response?.data}');
      print('Error Status: ${e.response?.statusCode}');
      rethrow;
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }
}
