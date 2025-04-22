import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

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
