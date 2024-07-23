import 'package:dio/dio.dart';
import 'auth_header_interceptor.dart';
import 'default_header_interceptor.dart';

Future<Dio> createAuthorizedHttpClient(String baseUrl) async {
  Dio dio = Dio();
  dio.options.baseUrl = baseUrl;
  dio.options.followRedirects = false;

  dio.options.connectTimeout = const Duration(seconds: 100000);
  dio.options.receiveTimeout = const Duration(seconds: 50000);
  dio.options.headers['Accept'] = 'application/json';

  dio.interceptors
    ..add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        request: true,
        requestHeader: true))
    // ..add(ResponseBodyPrinterInterceptor())
    ..add(DefaultHeaderInterceptor())
    ..add(BearerTokenInterceptor(dio));

  // (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
  //     (HttpClient client) {
  //   client.badCertificateCallback =
  //       (X509Certificate cert, String host, int port) => true;
  //   return client;
  // };

  return dio;
}
