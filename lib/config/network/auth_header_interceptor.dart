import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qaz_tracker/common/data/personal/repository/global_user_secure_repository.dart';
import 'package:qaz_tracker/constants/app_global_prefs_consts.dart';
import 'package:qaz_tracker/di/di_locator.dart';

/// interceptor для отправки авторизационного хэдера
/// и обработки ошибок [401] и [403]
class BearerTokenInterceptor extends InterceptorsWrapper {
  final Dio dio;
  final GlobalPersonalSecureDataRepository _secureDataRepository;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// максимальное количесво повтори при авторизационных ошибках
  static const maxRepeatCount = 3;

  /// счетчик для повторов запроса в случае авторизационных ошибок [401] и [403]
  int _repeatCounter = 0;

  BearerTokenInterceptor(this.dio) : _secureDataRepository = locator();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _secureDataRepository.accessToken;
    options.headers[GlobalPrefConstant.authorization] =
        '${GlobalPrefConstant.bearer} $accessToken';
    // log('$accessToken');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _resetRepeatCounter();
    return handler.next(response);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 403 || err.response?.statusCode == 401) {

      // dio.interceptors.requestLock.lock();
      // dio.interceptors.responseLock.lock();

      RequestOptions requestOptions = err.response!.requestOptions;

      try {
        // final authResponse = await _authRepository.refreshToken();
        // final accessToken = authResponse.access;
        // _secureDataRepository.setAccessToken(accessToken);
        // requestOptions.headers[GlobalNetworkConstant.authorization] =
        //     '${GlobalNetworkConstant.bearer} $accessToken';

        // dio.interceptors.requestLock.unlock();
        // dio.interceptors.responseLock.unlock();

        /// обновляем счетчик если количество повторов превисило лимит
        if (_repeatCounter >= maxRepeatCount) {
          _resetRepeatCounter();
          return handler.reject(err);
        }

        _repeatCounter++;

        final Response response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      } catch (ex) {
        // dio.interceptors.requestLock.unlock();
        // dio.interceptors.responseLock.unlock();

        _resetRepeatCounter();
        return handler.reject(err);
      }
    } else {
      _resetRepeatCounter();
      return handler.reject(err);
    }
  }

  /// обновляет счетчик _repeatCounter
  /// необходимо обновление в случае успешного ответа от сервера
  /// или при ошибках кроме 401 и 403
  void _resetRepeatCounter() {
    _repeatCounter = 0;
  }
}
