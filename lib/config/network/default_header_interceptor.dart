import 'package:dio/dio.dart';

class DefaultHeaderInterceptor extends InterceptorsWrapper {
  final String? deviceId;
  final String? appVersion;
  DefaultHeaderInterceptor({this.deviceId, this.appVersion});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // options.headers['lang'] = locale;
    // options.headers['app-platform'] = Platform.isIOS ? 'iOS' : 'Android';
    // options.headers['app-version'] = appVersion;
    // options.headers['device-id'] = deviceId;

    super.onRequest(options, handler);
  }
}
