import 'package:dio/dio.dart';
import '../../core/utilities/app_utils.dart';
import '../providers/providers.dart';
import 'http_client.dart';

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppUtils.log('token ${options.headers['AUTH_TOKEN']}');
    AppUtils.log(
        'REQUEST[${options.method}] => PATH: ${options.uri}=>DATA: ${options.data}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final uri = response.requestOptions.uri;
    AppUtils.log('RESPONSE[${response.statusCode}] => PATH: $uri');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final uri = err.requestOptions.uri;
    AppUtils.log('ERROR[${err.response?.statusCode}] => PATH: $uri');
    if (err.response != null) {
      if (err.response?.statusCode == 401) {
        final requestOptions = err.requestOptions;
        final token = await ApiProvider.refreshToken();
        if (token != null) {
          final opts = ApiClient.options(requestOptions.method, token);
          final response = await ApiClient.dio.request(
            requestOptions.path,
            options: opts,
            cancelToken: requestOptions.cancelToken,
            onReceiveProgress: requestOptions.onReceiveProgress,
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
          );
          return handler.resolve(response);
        } else {
          return handler.next(err);
        }
      }
      return super.onError(err, handler);
    }
  }
}
