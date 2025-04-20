import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;
  late final _sharedPrefs;

  DioClient({
    required sharedPrefs,
  }) : _dio = Dio() {
    _sharedPrefs = sharedPrefs;
    final baseUrl = dotenv.env['BASE_URL'];
    _dio.options = BaseOptions(
      baseUrl: baseUrl ?? '',
    );
    print('Base URL: $baseUrl'); // Debug print

    _dio.interceptors.add(InterceptorsWrapper(
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
    ));
  }

  Future<Response> get({
    required String endpoint,
    Map<String, dynamic>? params,
    FormData? data,
  }) async {
    try {
      Response response;
      response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: params,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Request failed with status: ${response.statusCode}, message: ${response.statusMessage}\nResponse data: ${response.data}',
        );
      }
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
