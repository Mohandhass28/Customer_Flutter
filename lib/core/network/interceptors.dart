import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggerInterceptor extends Interceptor {
  Logger logger = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    logger.d('REQUEST[${options.method}] => PATH: $requestPath');
    logger.d('Header: ${options.headers} \n'
        'Data: ${options.data}');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d('Status Code: ${response.statusCode} \n'
        'Status Message: ${response.statusMessage} \n'
        'Header: ${response.headers} \n'
        'Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger.e("Error Type: ${err.error}");
    logger.d('REQUEST[${options.method}] => PATH: $requestPath');
    handler.next(err);
  }
}

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  bool _isRefreshing = false;
  Queue<_RetryRequest> _queue = Queue();
  RefreshTokenInterceptor(this.dio, this.sharedPreferences);

  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = sharedPreferences.getString('token');
    print('options.headers: $token');
    if (token != null) {
      options.headers['Authorization'] = '$token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('Error: ${err.message}');
    if (err.response?.statusCode == 401) {
      final options = err.requestOptions;
      if (_isRefreshing) {
        _queue.add(_RetryRequest(
          options: options,
          handler: handler,
        ));
        return;
      }
      _isRefreshing = true;

      try {
        final number = sharedPreferences.getString('number');
        print('Number: $number');
        if (number == null) {
          return handler.next(err);
        }
        final response = await dio.post(
          'customer/loginWithoutOtp',
          data: {'phone': number},
        );
        if (response.statusCode == 200) {
          final token = response.data["payload"]['token'];

          sharedPreferences.setString('token', token);
          options.headers['Authorization'] = token;

          final retryResponce = await _retry(options);
          while (_queue.isNotEmpty) {
            final retryRequest = _queue.removeFirst();
            final retryResponce = await _retry(retryRequest.options);
            retryRequest.handler.resolve(retryResponce);
          }
          _isRefreshing = false;
          return handler.resolve(retryResponce);
        }
        _isRefreshing = false;
        return handler.next(err);
      } catch (e) {
        _isRefreshing = false;
        _queue.clear();
        return handler.next(err);
      }
    }
    return handler.next(err);
  }
}

class _RetryRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _RetryRequest({
    required this.options,
    required this.handler,
  });
}
